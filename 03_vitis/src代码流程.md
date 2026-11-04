# Vitis 双核 AMP 协同流程与修复记录

工程：yolov5n_speed_prj；更新：2026-10-15；当前协议：DUAL_CORE_VERSION=3。

本文以当前 v3 源码和用户最新上板日志为准。v3 已实测 avg16=2.640 FPS、稳态 lat=757 ms；下文修正三阶段与三帧并行的区别，补充 slot 复用、排队及首帧/稳态时序。本轮仅修改三份 Markdown，未改 Vitis 源码或构建配置，未执行 Build、打包或上板操作。

## 1. 本轮修复与原因

| 原实现 / 原记录的问题 | 当前实现 | 原因 |
|---|---|---|
| CPU0 预处理完另一帧就再次改 p_act/Start，未等待现有运行结束 | active_slot 跟踪唯一 PL 任务；PREPARED 等待现有任务完成再启动 | 两份 arena 不等于存在两个可并行接受任务的加速器 |
| CPU1 直接读取 IsDone，CPU0 不掌握硬件完成时刻 | CPU0 独占所有 PL 控制与完成读取；CPU1 只消费 POST_READY | AP_CTRL 的 ap_done 是读清状态，单一读取者能避免丢失完成通知 |
| 多个 bool 标志分散更新，slot 与硬件运行关系不明确 | 一个 slot_state 搭配 frame_id、arena_addr、snapshot_addr | 状态交接和资源所有权保持一致 |
| 声称 OCM 不可缓存，实际只做部分字段 flush/invalidate | 两核首次访问前实际配置 NORM_NONCACHE，交接加 DMB | 避免缓存陈旧值以及同一缓存行中对方字段被回写覆盖 |
| 两核并行调用会操作共享 L2 的 BSP 缓存函数 | OCM Peterson 锁串行化缓存范围操作 | 保护共享 L2 控制器及调试寄存器 |
| 唤醒函数复位 CPU1、将 SCU 电源状态误解为取指/执行状态、修改 GIC 发 SGI | 已加载 ELF 检查 + 写入口字 + DSB/SEV | 使用 BootROM 约定的 AMP 交接，消除额外共享外设改写 |
| CPU1 普通启动会重配 L2、重置 global timer | 应用内 AMP boot.S、xil-crt0.S | CPU1 启动时保留 CPU0 已使用的共享缓存和计时器 |
| 两核按各自软件帧号推测采集 buffer，CPU1 在推理后重读实时采集环 | CPU0 从稳定采集帧保存 slot 快照；pre 和显示共用该快照 | 防止原图被持续采集覆盖后，框与画面错帧 |
| CPU0 的 VIDEO_Mode 没有明确赋值便传给 DisplaySetMode | 显式选择 VMODE_800x480，并检查初始化返回值 | 避免将零尺寸/零时钟的模式传入显示链 |
| CPU1 超时后仍声称单核运行，但没有后处理且可能重复启动 PL | 使用真实计时器超时，记录错误并停住流水线 | 失败时保持可诊断现场 |
| 文档将 DDR 写成 512 MB，却把 CPU1 放到 0x20000000 以上 | 核对实际 BD/BSP 的 1 GiB 声明；两核与视频主动分配在前 512 MiB | 更正文档矛盾，并在应用内明确隔离内存 |

v3 新增修正：v2 每帧停车到下一 store 并等待，产生多余采集等待；现改为当前 store 停车，仅启动/切换竞态需要等待。v2 混合计时现拆为 pre/cap/prep 与 post/inv/draw/postall；新增按显示缓存 flush 完成时刻计算的瞬时 FPS、16 间隔平均 FPS、启动间隔及统计序列锁。

没有手工修改模型导出的权重、requant、描述符、pre/post/draw 算法或 PL 接口。

## 2. 分工与数据流

| 执行单元 | 工作 |
|---|---|
| CPU0 | 摄像头/VDMA/HDMI/PL 初始化、唤醒 CPU1、采集快照、pre、PL 调度和完成服务、超时与串口 |
| PL | 单实例执行一次完整网络推理，84 条算子 |
| CPU1 | 接收完成 slot、输出缓存交接、后处理、复制快照、绘制、显示缓存刷新、释放 slot |

~~~text
OV5640 -> VDMA S2MM 三帧采集环
                     |
                     v
CPU0: 稳定帧 -> frame_snapshot[slot] -> app_preprocess()
                     |                         |
                     |                         v
                     |                    arena[slot] 输入
                     |                         |
                     |                         v
                     |               CPU0 Start -> PL 推理
                     |                         |
                     |                  CPU0 IsDone
                     |                         |
                     |               发布 SLOT_POST_READY
                     |                         |
                     |                         v
                     |              CPU1 app_postprocess()
                     |                         |
                     +-------> 显示缓存 <--- 同帧检测框
                                   |
                              flush 到 DDR
                                   |
                             VDMA MM2S -> HDMI
~~~

摄像头像素存储字节序为 B、G、R。pre 从 800×480 中心裁剪 640×480，缩到 512×384，再转模型 RGB、int8 和 c4；这些已有算法本次保持不变。显示仍为 800×480，后处理阈值位于 CPU1 main_1.c：CONF_THR=0.50、IOU_THR=0.45、MAX_DET=32。

v3 中 CPU1 找不到 POST_READY 时使用 WFE 等待，避免持续轮询 OCM；CPU0 发布完成 slot 后执行 DSB/SEV，停止请求也发送事件。事件锁存覆盖“检查后、睡眠前”的窗口，唤醒后重新扫描状态；CPU0 仍负责轮询 PL 完成。

## 3. 状态交接与双缓冲约束

每组 slot 都拥有一份 5,745,408 B arena 和一份 1,152,000 B 快照。状态值与共享头完全一致：

| 值 | 状态 | 进入者 / 资源所有权 |
|---:|---|---|
| 0 | SLOT_FREE | CPU1 释放；CPU0 可开始下一帧 |
| 1 | SLOT_PREPARING | CPU0 保存快照并预处理 |
| 2 | SLOT_PREPARED | CPU0 已完成输入和快照 flush，等待 PL 空闲 |
| 3 | SLOT_PL_RUNNING | CPU0 已启动 PL；禁止改该 slot 输入 |
| 4 | SLOT_POST_READY | CPU0 已观察到 PL 完成；交给 CPU1 |
| 5 | SLOT_POSTING | CPU1 正在后处理/绘制；CPU0 禁止复用 |

CPU0 主循环顺序：

1. service_pl() 非阻塞读取当前 PL 任务的完成状态；完成后记录 infer_ms 并发布 POST_READY。
2. start_prepared_slot() 在 active_slot < 0 时启动较早的 PREPARED slot。
3. 若轮到的写 slot 为 FREE，则取得所有权，保存稳定快照、pre、刷新缓存、发布 PREPARED。
4. 再次服务 PL 完成和启动，继续下一轮。

CPU1 遍历 POST_READY，以 frame_id 选择较早的一帧，处理后**最后发布 FREE**。它不访问 PL AXI-Lite 寄存器。计数比较支持 uint32_t 回绕。

### 3.1 “三阶段”与“三帧同时并行”的区别

当前软件确实分为三个阶段：CPU0 的 prep、PL 的 infer、CPU1 的 postall。但它只有两组完整 YOLO slot，不能同时容纳“正在 prep 的 N+1、正在 infer 的 N、正在 post 的 N-1”三份不同帧。

原图中“另一组 slot 先 post、再 prep”的顺序是正确的；缺少明确的时间段、slot 复用和 PREPARED 排队，容易误读。当前应称为 **双 slot、三阶段分工的重叠流水**，不能画成三个不同帧全程同时执行三个阶段。

还需区分两类缓冲：

| 缓冲 | 数量 | 用途 | 是否提供第三个推理 slot |
|---|---:|---|---|
| VDMA 采集环 | 3 张图像 | 摄像头连续采集、选择稳定已完成帧 | 否 |
| YOLO slot | 2 组 | 每组一份完整 arena、一张快照及状态 | 当前只有这两组可交替推理 |
| 显示 framebuffer | 1 张图像 | 接收 CPU1 画好的结果，供 MM2S 扫描 | 否 |

### 3.2 用本次 v3 输出标注的稳态分段图

用户提供的 v3 日志中：pre=25 ms、cap=13 ms、prep=38～39 ms、infer=378 ms、postall≈17 ms，稳态 avg16=2.640、lat=757 ms，采样的 wait=0、gap=1 us。

下面取 P=39 ms（完整 prep）、H=17 ms（完整 postall）。T≈1000/2.640≈378.8 ms 是由完成率换算的平均周期；infer/start 的整数日志也是约 378 ms。忽略微小调度间隔后，以“PL 启动帧 N”为相对 t=0：

~~~text
interval (ms)    [0,17)         [17,56)        [56,378.8)
CPU0            wait FREE      prep N+1       PREPARED: wait PL / poll
PL              infer N        infer N        infer N
CPU1            postall N-1    WFE            WFE
slot A          PL_RUNNING N   PL_RUNNING N   PL_RUNNING N
slot B          POSTING N-1     PREPARING N+1  PREPARED N+1

t ~= 17 ms:     N-1 finishes; CPU1 releases slot B; CPU0 reuses B for N+1.
t ~= 56 ms:     N+1 is prepared; it waits for the only PL accelerator.
t ~= 378.8 ms:  PL N finishes; PL starts N+1 on B; CPU1 processes N on A.
next period:    CPU0 waits for postall N to release A, then prepares N+2.
~~~

同一 PL 周期内可以先后出现 N-1、N、N+1 三个帧号，但 N-1 已释放后，N+1 才进入同一组 slot；不是三帧同时驻留。postall 和下一帧 prep 在这组 slot 上串行复用：

~~~text
H + P ~= 17 + 39 = 56 ms < T ~= 378.8 ms
~~~

因此 CPU 阶段可以被当前 PL 推理覆盖，约剩 322.8 ms 等待加速器。CPU0 的“等待”仍包含完成服务和轮询，不能据此直接推算 CPU0 的实际低功耗空闲率。

### 3.3 连续三帧的完整时序表

这是稳态的三帧推导示意，**不是开机帧 0/1/2，也不是新增采样的精确时间戳**。以 F_k 开始准备为 t=0，使用上面的 P/H/T 近似值；更早帧已在流水线中运行。表中时间单位为 ms：

| 帧 | slot | CPU0 prep | PREPARED 等待 PL | PL infer | CPU1 postall | 结果缓存完成时刻 |
|---|---:|---|---|---|---|---:|
| F_k | 0 | 0～39 | 39～361.8 | 361.8～740.6 | 740.6～757.6 | 757.6 |
| F_(k+1) | 1 | 378.8～417.8 | 417.8～740.6 | 740.6～1119.4 | 1119.4～1136.4 | 1136.4 |
| F_(k+2) | 0 | 757.6～796.6 | 796.6～1119.4 | 1119.4～1498.2 | 1498.2～1515.2 | 1515.2 |

slot 0 的 F_k 完成 postall 后，才在 757.6 ms 被 F_(k+2) 复用。slot 1 同样先完成更早帧，再准备 F_(k+1)。这是状态机 FREE -> PREPARING -> PREPARED -> PL_RUNNING -> POST_READY -> POSTING -> FREE 所表达的保护。

相邻结果缓存完成时刻相差约 378.8 ms，对应约 2.640 FPS；每帧自身从 prep 开始到 postall 结束，却约为 757.6 ms。两者分别是吞吐周期和单帧延迟。

### 3.4 为什么首帧 lat=435 ms，稳态 lat=757 ms

首帧前面没有排队，大致是 prep≈38 + infer≈378 + postall≈18，再加被整数打印截去的小数和交接时间，吻合 lat=435 ms。

稳态中下一帧被提前准备，它在 PREPARED 状态等待前一帧占用的 PL。按图示，一帧的等待约为：

~~~text
W ~= T - H - P ~= 378.8 - 17 - 39 = 322.8 ms
L ~= P + W + T + H
  ~= 39 + 322.8 + 378.8 + 17 = 757.6 ms
~~~

在阶段耗时稳定、PL 连续运行且 H+P<T 的近似条件下，L≈2T，吻合日志的整数 lat=757 ms。这是排队造成的延迟，不表示每输出一帧都要等待 757 ms；输出仍约每 378.8 ms 完成一次。lat 的起点是软件开始准备，不是摄像头曝光时刻；终点是显示缓存 flush 完成，不是显示器扫描到该图像。

理想调度下吞吐周期受 max(T_infer, T_postall + T_prep) 约束，还存在缓存、总线、轮询及调度开销。本次样本说明当前处于 PL 主导的状态；无需将各阶段简单相加计算 FPS，也不能把整数 infer=378 ms 当成精确的 378.000 ms。

## 4. 稳定采集与同帧显示

prime_capture() 只在启动时等待一次实际帧号推进，确保首张快照完整。v3 的 capture_snapshot() 读取实际当前 S2MM store，将它本身设为停车目标，通常可立即选择前一个已完成 store；只有寄存器编程恰逢帧切换时才等待停车目标确认。复制之前不猜测当前写入位置，也不取消稳定帧保护。

CPU0 invalidate 该稳定帧后，将其复制到 frame_snapshot[slot]，随后恢复 S2MM 循环模式。pre 读取快照而非实时采集环；CPU1 数百毫秒后也只读这份快照。快照与 arena 同时受 slot 生命周期保护。

方案使用现有三帧 S2MM、固定 MM2S 缓冲和停车寄存器，不增加硬件功能。快照复制和缓存维护仍有成本，计入 cap 和总准备时间 prep；pre 只计预处理及输入 flush。竞态等待单列 wait，不再主动每帧等待新采集帧。

停车目标与当前帧号的含义参考 [AMD PG020 PARK_PTR_REG](https://docs.amd.com/r/en-US/pg020_axi_vdma/PARK_PTR_REG-Park-Pointer-Register-Offset-28h)。当前增加 S2MM 错误检查，因为 [PG020 Hardware Debug](https://docs.amd.com/r/en-US/pg020_axi_vdma/Hardware-Debug) 说明帧/行错误会锁存 park pointer 的当前帧号；错误情况下不能继续把它当实时写入索引。

显示仍是一张固定 framebuffer，CPU1 边更新、MM2S 边扫描；本轮没有做显示页翻转，因此同帧对应修复不代表已经消除扫描撕裂。

## 5. 内存布局

### 5.1 DDR 分区

| 区域 | 地址范围 | 使用方式 |
|---|---|---|
| 低端保留区 | 0x00000000～0x000FFFFF | 不分配给两个应用 ELF |
| CPU0 应用区 | 0x00100000～0x0FFFFFFF | 代码、数据、两份 arena、两份快照、堆栈 |
| 视频区 | 0x10000000～0x10464FFF | 3 张采集帧 + 1 张显示帧 |
| 中间未分配区 | 0x10465000～0x1EFFFFFF | 当前应用不使用 |
| CPU1 应用区 | 0x1F000000～0x1FFFFFFF | 16 MiB，CPU1 代码/数据/堆栈 |

FRAME_BYTES=800×480×3=1,152,000：

~~~text
CAP(0)    = 0x10000000
CAP(1)    = 0x10119400
CAP(2)    = 0x10232800
DISP_BASE = 0x1034BC00
~~~

CPU0 lscript.ld：ORIGIN=0x00100000，LENGTH=0x0FF00000。
CPU1 lscript.ld：ORIGIN=0x1F000000，LENGTH=0x01000000。
共享头 CPU1_ENTRY_ADDR=0x1F000000，两个脚本含向量表与内存边界断言。

当前 zynq.bd 与两核 xparameters.h 声明 DDR 高地址 0x3FFFFFFF；BD 使用 32-bit DDR 和 MT41K256M16 RE-125。旧文档“512 MB”与此不一致。这里只将应用分配限制在前 512 MiB，不据此断言实物容量，不要求修改 Vivado DDR 参数。

### 5.2 OCM

Zynq OCM 总计 256 KiB；当前高地址 bank 为 0xFFFF0000～0xFFFFFFFF，只有 **64 KiB**，其余 OCM bank 的映射另计。本工程只清零前 4 KiB，不覆盖高 OCM 尾部的 BootROM 等待代码或 0xFFFFFFF0 交接字。

dual_core_ctrl_t 当前为 280 B，编译期检查不超过 4 KiB。保留 v2 的 128 B 前缀，追加 timing[2]（2×36 B）、stats_seq（4 B）和 perf（76 B）；包括精确分段耗时、拆分的 64 位准备开始时间戳、完成间隔/FPS、统计发布序号。

调试常用地址：cpu1_state=0xFFFF0018，cpu1_error=0xFFFF001C，slot_state=0xFFFF0020/24，post_count=0xFFFF0060；新增 timing=0xFFFF0080/0xFFFF00A4，stats_seq=0xFFFF00C8，perf=0xFFFF00CC。今后若改结构体，必须同步两份头、调试地址表和本文。

### 5.3 arena 输出

| 张量 | 偏移 | 尺寸 CH×H×W | c4 实际字节数 |
|---|---:|---|---:|
| 输入 | 0 | 3×384×512 | 786432 |
| P3 | 4697088 | 67×48×64 | 208896 |
| P4 | 5495808 | 67×24×32 | 52224 |
| P5 | 5695488 | 67×12×16 | 13056 |

67 通道补齐到 68；三个检测头合计 274176 B，均不超过 arena 边界且按缓存行对齐。

## 6. 缓存一致性

| 数据 | 写入者 / 后续读取者 | 维护 |
|---|---|---|
| 权重、requant、描述符 | CPU0 / PL | CPU0 初始化 flush |
| arena 初始 .bss | CPU0 启动清零 / PL | CPU0 初始化一次性 flush 全 arena，消除潜在脏行 |
| 采集帧 | VDMA / CPU0 | 停驻后 CPU0 invalidate，再复制快照 |
| slot 快照 | CPU0 / CPU1 | CPU0 flush；CPU1 获取 POST_READY 后 invalidate |
| 输入 tensor | CPU0 / PL | CPU0 pre 后 flush |
| 三个输出 tensor | PL / CPU1 | CPU1 获取 POST_READY 后 invalidate |
| 显示 framebuffer | CPU1 / VDMA | CPU1 draw 后 flush |
| OCM 状态 | 两核 | 两核均配置 NORM_NONCACHE，DMB 交接；无字段级 cache 操作 |

当前 standalone 7.3 范围维护函数会操作共享 L2 控制器。两核运行期调用这些函数前后使用 dual_cache_enter(core)/leave(core)。该锁使用不可缓存 OCM 的两个意愿字和 turn，加全系统 DMB；不能从可重入的中断处理程序调用。

初始化阶段的整库 flush 发生在 CPU1 ready 前；正式进入流水线后仅维护明确的数据范围。CPU1 启动的 USE_AMP=1 仅作用于应用中的两份汇编文件，BSP 缓存函数仍保留 L2 范围操作。

## 7. CPU1 启动与工程配置

1. CPU0 映射/初始化 OCM，发布协议版本和地址表。
2. CPU0 完成视频、PL 和初始缓存处理，再发布 cpu0_ready。
3. cpu0_wakeup_cpu1() 检查 CPU1 入口首字、写 0xFFFFFFF0，执行 DSB/SEV。
4. CPU1 从自己的 _vector_table 经应用内 boot.S、xil-crt0.S 进入 main；启动不重置共享 L2、global timer 或可选 TTC。
5. CPU1 映射 OCM，检查 magic/version 和 cpu0_ready，发布 cpu1_ready。
6. CPU0 最多等待 5 s，然后开始调度；失败则记录错误并停止。

BootROM 等待入口字/事件的行为可参见 [AMD XAPP1078](https://docs.amd.com/api/khub/documents/U2aDeBklgLytsMnofLbQig/content)。本工程不使用其 Linux 部分，而采用两个 standalone 应用。

CPU1 .cproject 的 Debug/Release 均新增汇编配置：s,S 输入、解析后的 BSP include、-mcpu=cortex-a9、-mfpu=vfpv3、-mfloat-abi=hard、SIM_MODE=0。CPU1 链接脚本要求 cpu1_amp_boot、cpu1_amp_crt0 存在；若新 .S 未参与构建，会明确报错。

不要额外把整个 CPU1 BSP 编译成跳过 L2 范围维护的配置；那与本轮的缓存交接方案不同。升级 BSP 时应重新核对应用内启动代码。

## 8. 超时与调试

| 条件 | 时间 / 错误码 |
|---|---|
| CPU1 入口首字为空或入口不符 | error=6 |
| CPU1 未就绪 | 5 s，error=2 |
| PL 未完成 | 10 s，error=3 |
| post 未完成 | 5 s，error=4 |
| 视频初始化/采集边界等待失败 | 边界等待 1 s，error=5 |
| CPU1 协议版本不符 | cpu1_error=1；CPU0 汇总 error=7 |

停止时 CPU0 写 stop_requested，保留缓存、显示及共享状态，便于调试。CPU1 在等待工作时响应停止；不会再进入旧的“CPU0-only 无 post/draw”路径。cpu1_state 的当前定义见 CPU1 README；旧的 PL 驱动初始化和等待 IsDone 状态说明已失效。

### 8.1 v3 日志口径、FPS 与验证边界

#### v3 用户上板结果补记

本次提供的 v3 采样显示完成计数到65，稳态 avg16=2.640 FPS、period/start=378 ms、gap=1 us，pre=25 ms、cap=13 ms且wait=0、prep=38～39 ms、post=2 ms、inv=3 ms、draw=11～12 ms、postall≈17 ms。首帧lat=435 ms，稳态lat=757 ms。

这确认了当前样本中的输出吞吐与阶段重叠。CPU1 本帧处理成本应看 postall≈17 ms，不能只拿 post=2 ms 代表完整消费阶段；CPU0 同理应以 prep≈39 ms 参与流水线预算。双 slot 上的 postall+prep≈56 ms 小于 PL 周期，因此不会在这些样本中拖长稳态吞吐周期。

图示和阶段起止是依据代码状态机及上述汇总日志推导的近似稳态模型，不是硬件 trace；实际小数部分、逐帧唤醒/轮询延迟不能从这些整数打印完全复原。该次日志也不能替代长期稳定性或显示器扫描延迟测试。本轮仅修订三份 Markdown，未改动 Vitis 源码或构建配置，也未运行 Build。

v2 已由用户上板：CPU1 正常就绪，完成计数至少到 337；所给采样中 pre=46～107 ms、infer=378 ms、post/draw=11～21 ms。v2 的 pre 把采集等待、快照复制、pre 和两份缓存刷新合在一起；post/draw 也不是纯后处理。v2 没有完成帧时间戳，因此不能据这份日志精确计算吞吐 FPS，也不能将重叠阶段简单相加。

v3 修正了实际采集等待，并保留全部成本的可见性：

| 日志字段 | 当前含义 |
|---|---|
| pre | app_preprocess + 输入 tensor flush，便于与旧单核 pre 约 23 ms 的口径比较；含锁等待 |
| cap(wait) | 稳定帧选择、采集帧 invalidate、快照复制和快照 flush；括号 wait 是停车切换确认的子耗时 |
| prep | 从开始保存这一帧到 PREPARED 的总时间，约等于 cap+pre；对应 v2 的 pre 总口径 |
| infer | PL 启动到 CPU0 观察到完成，可能包含轮询延迟 |
| post | 仅 app_postprocess，便于核对约 10 ms 的算法后处理 |
| inv / draw | inv 是 CPU1 输出/快照缓存失效；draw 是快照复制、画框和显示 flush，均含相应锁等待 |
| postall | inv+post+draw 的完整消费耗时，对应 v2 post/draw 总口径 |
| period / fps | CPU1 两次显示缓存 flush 完成之间的间隔 / 其倒数 |
| avg16 | 16 个完成间隔的总帧数÷总时间；不是瞬时 FPS 的算术平均 |
| start | 相邻两次 PL 启动的间隔，第一帧为 0 |
| gap | CPU0 观察到上一帧完成至本帧启动的间隔，单位 us；不含观察完成之前的轮询延迟 |
| lat | 本帧准备开始到显示 flush 完成，包括等待 PL 的排队；不是传感器曝光延迟 |

除 gap 标注 us、FPS 为帧/秒外，各耗时以整数 ms 打印，内部以 us 保存。FPS 用原始 64 位 global timer ticks 计算，保留三位小数，不使用浮点 printf；例如准确的 378 ms 完成周期约对应 2.646 FPS，但这只是换算示例，不是 v3 实测承诺。

首帧没有上一完成时间，打印 fps=warmup avg16=warmup。第 17 个完成帧产生首个 16 间隔平均值，以后每 16 个间隔打印一次；FPS 指检测结果写入显示缓存的完成率，不是 HDMI 扫描刷新率。不要用 1/(pre+infer+post) 计算流水线 FPS。

CPU1 用 stats_seq 奇偶序列锁发布同一帧的完整统计，CPU0 读前后序号一致且为偶数才接受，防止跨帧混合。三项 last_* 和 pre_ms/post_ms 在 v3 分别使用新的 pre/post 算法口径；完整阶段看 perf.prepare_us、perf.post_total_us。

CPU1 就绪超时 5 s；首次采集就绪和切换竞态确认各限 1 s；PL 超时 10 s；post 超时 5 s。失败后记录错误并保留现场。当前增加 VDMA 错误检查，因为错误状态会使 park pointer 的当前帧号停止跟踪。

v3 代码修改时已完成源码/API/布局检查、19,632 次稳定采集模型、64 位 FPS/16 间隔/抖动/延迟观察计算检查、91 个有序统计发布交错检查。**v3 现已有上述用户上板结果。** 模型检查与用户硬件日志应分别理解；本次仅修正文档，未再次构建或执行硬件验证。当前采样的吞吐与阶段耗时见本节实测补记。



## 9. 使用者后续操作与 Vivado 结论

本轮没有必须同步修改的 Vivado 内容。原因是双 Cortex-A9、共享 DDR/OCM、现有 AXI-Lite/HLS 和三帧 VDMA 已支持该软件分工；没有新增 PL 端口、地址、中断或时钟要求。也不需要为本次协同重新综合 HLS 或生成 bitstream。

由使用者执行：

1. Vitis 刷新两个应用；必要时关闭再打开 CPU1 工程以加载新的 .cproject 设置。确认 CPU1 新增 boot.S、xil-crt0.S 可参与编译；使用 IDE 重新生成应用的构建文件。
2. Clean/Rebuild 两个应用。当前 CPU1 BSP 已存在，本轮未改平台/BSP。
3. 如采用 SD 启动，使用现有 bitstream 与新 CPU0/CPU1 ELF 重新打包。CPU1 应按新 ELF 的 0x1F000000 地址加载；若自定义 BIF 有旧 load/start 地址覆盖，需相应更新。
4. 冷启动观察 CPU1 ready、done 递增以及与冻结图像对应的检测框。确认协议与地址一致后测量阶段耗时和帧率。
5. JTAG 调试要区分 CPU1 的 BootROM 事件等待与调试器暂停；SEV 无法解除后者，应按双核调试流程在共享区初始化后运行 CPU1。

## 10. 本次检查与文件索引

已完成源码/API/280 B 共享结构布局检查，19,632 次采集停车/帧边界/复制稳定性模型，64 位计时、启动排除、16 个完成间隔、抖动与延迟观察的 FPS 检查，以及统计序列锁 91 个有序状态检查。v2 的 slot 回压与启动约束继续保留。

用户已提供 v3 的 ARM 目标运行日志，实测结论与模型检查分别列出；本轮只修正文档，源码保持不变，无需为本轮文档修订重新构建两个应用。

| 文件 | 内容 |
|---|---|
| yolov5n_speed/src/main.c | CPU0 初始化、快照、pre、PL 调度/完成、超时 |
| yolov5n_speed/src/cpu0_wakeup.c | BootROM 入口字 + DSB/SEV |
| 两个应用 src/dual_core_shared.h | 协议 v3、地址/状态、slot 计时、perf/序列锁、缓存维护锁 |
| 两个应用 src/lscript.ld | 互不重叠的 ELF 分区及断言 |
| yolov5n_speed_1/src/main_1.c | CPU1 消费完成 slot、post、快照绘制 |
| yolov5n_speed_1/src/boot.S、xil-crt0.S | 保留共享资源的 CPU1 启动 |
| yolov5n_speed_1/.cproject | 两种构建配置的汇编源支持 |
| [CPU0 README](yolov5n_speed/src/README.md) | CPU0 使用说明与模型数据说明 |
| [CPU1 README](yolov5n_speed_1/src/README.md) | CPU1 使用说明、共享字段与状态表 |
| Makefile_Windows兼容问题修复记录.md | 独立的历史 Makefile 问题，本轮未改 |

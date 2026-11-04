# Vitis HLS 驱动 Makefile Windows 兼容问题修复记录

## 一、问题描述

Vitis HLS 2020.2 导出 IP 时，自动生成的驱动 Makefile 在 Windows 平台下编译报错，导致 Platform Generate 失败。

### 典型报错信息

```
process_begin: CreateProcess(NULL, #echo "Copying 'xyolov5n_top.h' to '../../../include/xyolov5n_top.h'", ...) failed.
make (e=2): 系统找不到指定的文件。
make[2]: *** [Makefile:40: ../../../include/xyolov5n_top.h] Error 2
```

报错可能出现在三个位置中的任意一个：
- `#echo "Compiling $@ from $<"`
- `#echo "Linking $@"`
- `#echo "Copying '$<' to '$@'"`

---

## 二、根因分析

### 2.1 直接原因

HLS 自动生成的 Makefile 在**命令行规则内**（Tab 缩进后）使用了 `#echo "..."` 作为注释：

```makefile
$(OBJDIR)/%.o: %.c
	#echo "Compiling $@ from $<"    ← 这行有问题
	$(COMPILER) ...
```

- **Linux 环境**：make 识别行首 `#` 为注释，直接跳过，正常编译。
- **Windows 环境**：Vitis 调用的 make 工具**不会把缩进后的 `#` 识别为注释**，会把 `#echo` 当成一个可执行程序去调用，系统找不到名为 `#echo` 的程序，直接报错。

### 2.2 为什么换 XSA 后会复现

Vitis Platform Generate 时，会从 `hw/drivers/` 驱动源母本目录复制 Makefile 到每个 BSP 目录（`zynq_fsbl_bsp` 和 `standalone_ps7_cortexa9_0/bsp`）。

- 重新导入 XSA → 触发 BSP 重新生成 → 从母本复制原始 Makefile → 覆盖之前手动修复的 BSP 副本 → bug 复现。
- 如果只修改 BSP 副本，不修改母本，每次 Clean Platform / 换 XSA 都会复现。

### 2.3 为什么 FSBL 能通过、standalone 报错

两个域的 BSP 是分别生成的：
- FSBL 域可能沿用了之前修复过的旧副本，所以编译通过。
- standalone 域被重新生成了原始带 bug 的版本，所以报错。

---

## 三、涉及的文件路径

### 3.1 HLS 工程侧（源头母本，最关键）

```
<HLS工程目录>\solution1\impl\ip\drivers\yolov5n_top_v1_0\src\Makefile
```

### 3.2 Vitis 平台侧（hw/drivers 母本）

```
<平台工程>\hw\drivers\yolov5n_top_v1_0\src\Makefile
```

### 3.3 Vitis 平台侧（FSBL BSP 副本）

```
<平台工程>\zynq_fsbl\zynq_fsbl_bsp\ps7_cortexa9_0\libsrc\yolov5n_top_v1_0\src\Makefile
```

### 3.4 Vitis 平台侧（standalone BSP 副本）

```
<平台工程>\ps7_cortexa9_0\standalone_ps7_cortexa9_0\bsp\ps7_cortexa9_0\libsrc\yolov5n_top_v1_0\src\Makefile
```

> 注：驱动目录名 `yolov5n_top_v1_0` 由 HLS top 函数名和 IP 版本号决定，如果 HLS 中修改了版本号，目录名会相应变化（如 `yolov5n_top_v2_0`）。

---

## 四、修复方法

### 4.1 方法一：HLS 源头根治（推荐，一次修复永久生效）

**适用场景**：每次 HLS 重新 C-Synthesis + Export IP 后。

**操作步骤**：

1. HLS 导出 IP 完成后，打开以下文件：
   ```
   <HLS工程>\solution1\impl\ip\drivers\yolov5n_top_v1_0\src\Makefile
   ```

2. 找到以下 **3 行带 Tab 缩进的 `#echo` 注释行，整行删除**（包括前面的 Tab 字符）：
   ```makefile
   	#echo "Compiling $@ from $<"
   	#echo "Linking $@"
   	#echo "Copying '$<' to '$@'"
   ```

3. 保存文件。

**效果**：后续 Vivado 打包 IP、Vitis 导入 XSA、Generate Platform 时，所有 BSP 副本都会从修复后的母本复制，**不会再报错**。只要不从 HLS 重新 Export IP，这个修复永久有效。

---

### 4.2 方法二：Vitis hw/drivers 母本修复（半永久）

**适用场景**：HLS 侧忘记改了，但 IP 已经导入 Vitis，不想重新走 HLS 流程。

**操作步骤**：

1. 打开 Vitis 平台下的母本：
   ```
   <平台工程>\hw\drivers\yolov5n_top_v1_0\src\Makefile
   ```

2. 同样删除 3 行缩进的 `#echo`，保存。

3. 右键平台工程 → **Clean Platform**（清理旧 BSP 副本）。

4. 右键平台工程 → **Generate Platform**（从修复后的母本重新生成 BSP）。

**效果**：只要不从 HLS 重新 Export IP 覆盖 `hw/drivers` 目录，后续换 XSA、重生成平台都不会复现。

---

### 4.3 方法三：直接修改 BSP 副本（应急快速修复）

**适用场景**：Vitis 已经报错，想立刻编译通过，不做 Clean。

**操作步骤**：

直接修改两个 BSP 副本里的 Makefile，各删除 3 行缩进的 `#echo`：

1. FSBL BSP 副本：
   ```
   <平台工程>\zynq_fsbl\zynq_fsbl_bsp\ps7_cortexa9_0\libsrc\yolov5n_top_v1_0\src\Makefile
   ```

2. standalone BSP 副本：
   ```
   <平台工程>\ps7_cortexa9_0\standalone_ps7_cortexa9_0\bsp\ps7_cortexa9_0\libsrc\yolov5n_top_v1_0\src\Makefile
   ```

3. 保存后，右键平台工程 → **Generate Platform**，即可编译通过。

**注意**：这是临时修复，下次 Clean Platform 或换 XSA 后会被覆盖，需要重新修改。

---

## 五、标准化操作流程（每次 HLS 重新生成 IP / Vivado 生成 XSA 和 bit）

```
┌─────────────────────────────────────────────────────────┐
│  第1步：HLS 侧                                            │
│  C-Synthesis → Export RTL → Export IP                    │
│         ↓                                                 │
│  【必做】修改 HLS 工程下 ip/drivers/.../Makefile        │
│          删除 3 行缩进的 #echo                            │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  第2步：Vivado 侧                                         │
│  刷新 IP 缓存 → 重新 Generate Output Products            │
│  → Create HDL Wrapper（如需要）                           │
│  → Generate Bitstream                                     │
│  → Export Hardware（包含 bit）→ 生成 .xsa 文件           │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│  第3步：Vitis 侧                                          │
│  右键平台工程 → Update Hardware Specification             │
│  → 选择新生成的 .xsa 文件                                 │
│         ↓                                                 │
│  右键平台工程 → Clean Platform                            │
│         ↓                                                 │
│  右键平台工程 → Generate Platform ✅ 编译通过             │
│         ↓                                                 │
│  右键 app 工程 → Build Project                            │
│         ↓                                                 │
│  下载到板子运行                                            │
└─────────────────────────────────────────────────────────┘
```

### 关键原则

> **在 HLS 导出 IP 的源头就修好母本**，后续 Vivado、Vitis 流程全部自动继承修复后的版本，一劳永逸。
>
> 如果忘记在 HLS 侧修改，就在 Vitis 的 `hw/drivers` 母本修改后 Clean + Generate，效果相同。

---

## 六、注意事项

### 6.1 绝对不要做的修改

| 错误做法 | 后果 |
|---------|------|
| 把 `CP=cp` 改成 `CP=copy` | Windows `copy` 不支持正斜杠路径，报「命令语法不正确」 |
| 把 `RM=rm` 改成 `RM=del` | 同上，`del` 不支持正斜杠路径 |
| 删除顶部无缩进的 `#` 注释 | 顶部注释是合法的，删除不影响但没必要 |
| 只改一个 BSP 副本 | 另一个域可能仍报错，或下次 Clean 后复现 |

### 6.2 为什么 Vitis 环境支持 `cp` / `rm`

Vitis 2020.2 的 make 运行在自带的 **msys64 环境**中，该环境原生提供 `cp`、`rm` 等 Unix 命令，且兼容正斜杠路径（`../../../include`）。因此保持 `CP=cp`、`RM=rm` 是正确的。

### 6.3 如何验证修复是否生效

修改 Makefile 后，可以用以下 PowerShell 命令快速检查是否还有 `#echo`：

```powershell
$mk = "<Makefile路径>"
$content = Get-Content $mk -Raw
if ($content -match "#echo") {
    Write-Host "仍存在 #echo bug"
} else {
    Write-Host "已修复"
}
```

### 6.4 banner 行的引号（可选优化）

```makefile
banner:
	echo "Building $(CORENAME)"
```

Windows cmd 下 echo 会把引号也原样打印出来，不影响编译，只是输出不美观。可以去掉引号：

```makefile
banner:
	echo Building $(CORENAME)
```

---

## 七、修复历史记录

| 日期 | 操作 | 修复位置 | 备注 |
|------|------|---------|------|
| 2026-10-10 | 首次修复 | standalone BSP 副本 | 临时修复，build platform 通过 |
| 2026-10-10 | 二次修复 | hw/drivers 母本 + 两个 BSP 副本 | 半永久修复 |
| 2026-10-11 | 重新导入 XSA 后复现 | standalone BSP 副本 | FSBL 沿用旧副本已修复，standalone 被重新生成带 bug 版本 |
| 2026-10-11 | 三次修复 | standalone BSP 副本 | 当前已全部修复 |

---

## 八、相关参考

- Vitis HLS 2020.2 官方文档：UG1399
- Xilinx 社区论坛搜索关键词：`HLS driver Makefile Windows #echo CreateProcess failed`
- 本问题是 HLS 2020.2 在 Windows 平台的已知 bug，Linux 平台不受影响

---

*文档生成时间：2026-10-11*
*适用工程：yolov5n_speed_prj（YOLOv5n 裂缝检测 INT8 量化部署）*

---

# 九、2026-10-12 补充：Clean 失败的第二个坑 + "持久性"实测更正 + 一键工具

## 9.1 第二个坑（B）：FSBL 应用 Makefile 的 clean 规则

`<平台>/zynq_fsbl/Makefile` 第 42 行由 `generate_app` 生成：

```make
clean:
	rm -rf $(OBJS) $(LIBS) $(EXEC) *.o      ← 末尾这个裸通配是多余的
```

- **触发条件**：目录里**没有 `.o` 文件**时（新建平台、或刚 clean 过一次）。
- **报错**（IDE 里表现为 `Failed to do platform clean`）：

```
rm: lstat'*.o'失败: Invalid argument
make: *** [Makefile:42: clean] Error 1
```

- **机理**：Windows 的 cmd 不做通配符展开 → 字面量 `*.o` 直接进了 rm；
  **Xilinx 自带 `Vitis/2020.2/gnuwin/bin/rm.exe` 对含 `*` 的路径报 EINVAL**，
  而 Git/MSYS 的 rm 反而会吞掉（`-f` 时返回 0）。所以它只在"没有 .o 可展开"时爆。
- **修法**：删掉 ` *.o` 即可（`$(OBJS)` 已覆盖全部 .o）。
- **注意**：它由 IDE 内部生成，模板编在 `Vitis/2020.2/lib/win64.o/librdi_hsm.dll` 里，
  所以**每次域重生成都会把 `*.o` 写回来**，手改只能撑到下次重生成。

## 9.2 实测更正：`hw/drivers` 母本修复不是"半永久"

2026-10-12 在 `03_vitis` 的**副本**上用 `xsct` 做了两次受控实验（改文件后打标记，跑 `platform generate`，再看文件）：

| 文件 | 实验结果 |
|------|---------|
| `<平台>/hw/drivers/<drv>/src/Makefile` | **每次 `platform generate` 都被平台内 XSA 重新解包覆盖**，`#echo` 回来 → §五"关键原则"里"改 hw/drivers 母本效果相同"只对**当次**构建成立 |
| `<平台>/**/libsrc/<drv>/src/Makefile` | 本次未被重拷（BSP 判定 up-to-date）；**平台新建 / 换 XSA 引起 BSP 重生成时会从 hw/drivers 重拷**（两者逐字节相同已验证）→ 坑 A 于是每换一次 XSA 就复发 |
| `<平台>/zynq_fsbl/Makefile` | 本次未重生成；换 XSA / 重生成域时会重写回 `*.o` |
| **把 `hw/*.xsa` 里的 `drivers/*/src/Makefile` 修干净后**再 `platform generate` | **重解包出来的 hw/drivers 里 `#echo = 0` ✅** |

> **结论：唯一"修一次就永久"的位置是 XSA 本身**（或进 XSA 之前的 ip_repo）。
> HLS 侧修母本是同样效果的上游做法（§五流程不变）；如果懒得进 HLS，就在 **XSA 交到 Vitis 手里之前**把它修干净。

## 9.3 一键工具（Vitis 侧）

`03_vitis/tools/fix_platform_makefiles.py`（配套 `fix_platform.bat`）：同时治坑 A 和坑 B。

```bat
:: 1) 新导出的 XSA，Import 进 Vitis 之前跑（治根治本）
python -I 03_vitis\tools\fix_platform_makefiles.py --xsa D:\...\yolov5n_speed_wrapper_6.xsa

:: 2) 平台已经脏了/刚换完 XSA，构建前跑（修 hw/drivers + 各 BSP 副本 + FSBL Makefile + 平台内 XSA）
python -I 03_vitis\tools\fix_platform_makefiles.py            :: 自动找 03_vitis 下的 *_platform
:: 3) 顺手修 HLS 导出目录 / ip_repo（上游）
python -I 03_vitis\tools\fix_platform_makefiles.py --dir 02_vivado\ip_repo
:: 加 --dry 只列不改
```

特性：幂等（修过再跑报 0 改动）；改 XSA 前自动留 `.xsa.bak`；`--dry` 预演。

## 9.4 本次（2026-10-12）实际修复与验证

| 文件 | 改动 | 备份 |
|------|------|------|
| `<平台>/hw/drivers/yolov5n_top_v1_0/src/Makefile` | 删 3 行 `#echo` | `03_vitis/_fix_backup_20261012/hw_drivers_...bak` |
| `<平台>/ps7_cortexa9_0/.../bsp/.../libsrc/yolov5n_top_v1_0/src/Makefile` | 删 3 行 `#echo` | 同上 |
| `<平台>/zynq_fsbl/zynq_fsbl_bsp/.../libsrc/...` | 删 3 行 `#echo` | （随 BSP 重生成） |
| `<平台>/zynq_fsbl/Makefile` | clean 规则去掉 `*.o` | `_fix_backup_20261012/zynq_fsbl_Makefile.bak` |
| `<平台>/hw/yolov5n_speed_wrapper_5.xsa` | 内部驱动 Makefile 删 3 行 `#echo`（1479→1396 B） | 同目录 `.xsa.bak` |

验证（命令行等价复现 IDE 的动作）：

```
make（standalone BSP）        → EXIT=0，libxil.a 生成、BSP include/ 收到 xyolov5n_top.h
make -C zynq_fsbl_bsp; make   → EXIT=0，fsbl.elf 552,348 B
make clean（FSBL）            → CLEAN_EXIT=0（修复前是 Error 1）
xsct: platform generate       → rc=0（副本上，XSA 修好后 hw/drivers 重解包 #echo=0）
```

> IDE 里接下来照常 **Clean Platform → Generate Platform** 即可；
> 若某次换 XSA 后忘了预处理，先跑 9.3 的第 2 条再构建。

## 9.5 还留在台面上的（未做，需要你拍板）

1. **Vitis DLL 补丁**：把 `librdi_hsm.dll` 里模板串 `rm -rf $(OBJS) $(LIBS) $(EXEC) *.o` 的 ` *.o`（3 字节）改成空格 → 以后所有平台的 FSBL Makefile 一生成就是干净的（需关掉 Vitis 再打，Vitis 升级/重装会失效）。
2. **接进导出脚本**：把 `--xsa` 这一步加到 Vivado 的 XSA 导出脚本（或 `scripts/VITIS&HLS_export`）里，以后连"手动跑一次"都省了（属于动 Vivado 侧脚本，所以先问一句）。
3. `02_vivado/` 下现存的 5 个 XSA（`_xsa` ~ `_5.xsa`）**都带着脏驱动**；要重用到哪个就用 `--xsa` 现修（工具不改未指定的文件）。


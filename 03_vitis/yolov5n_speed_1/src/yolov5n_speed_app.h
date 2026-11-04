/*
 * yolov5n_app.h -- shared definitions of the Zynq PS application.
 *
 * The PS owns everything around the accelerator: camera, frame buffers, the
 * pre-processing that turns an 800x480 RGB frame into the 512x384 int8 c4
 * input image, and the detection head post-processing that the model yaml
 * deliberately keeps off the PL (DFL 16-bin softmax, class sigmoid, bbox
 * decode, NMS).
 */
#ifndef YOLOV5N_SPEED_APP_H
#define YOLOV5N_SPEED_APP_H

#include <stdint.h>
#include "xparameters.h"
#include "yolov5n_speed_desc.h"
#include "yolov5n_speed_layers.h"

/* ------------------------------------------------------------------ model --- */
#define YOLO_IN_H       YOLO_INPUT_H            /* 384 */
#define YOLO_IN_W       YOLO_INPUT_W            /* 512 */
#define YOLO_NC         3
#define YOLO_REG_MAX    16
#define YOLO_STRIDE_P3  8
#define YOLO_STRIDE_P4  16
#define YOLO_STRIDE_P5  32

/* ------------------------------------------------------------- video chain --- */
#define CAM_W           800
#define CAM_H           480
#define DISP_W          800
#define DISP_H          480

/* the capture frame buffers laid out by vdma_api (3 x 800*480*3 bytes) */
#define FB_BYTES        (CAM_W * CAM_H * 3)

/* center-crop of the camera picture that matches the model's 4:3 field */
#define CROP_W          640
#define CROP_H          480
#define CROP_X0         ((CAM_W - CROP_W) / 2)

/* --------------------------------------------------------------- interface --- */
void app_preprocess(const uint8_t *fb, int8_t *dst);
int  app_postprocess(const int8_t *arena, float conf_thr, float iou_thr,
                     int16_t out[][4], float *out_conf, int16_t *out_cls, int max_out);
void app_draw_boxes(uint8_t *fb, const int16_t boxes[][4], const int16_t *cls,
                    const float *conf, int n);

#endif

/*
 * 最终版交接说明 2026年10月27日
 * 文件角色：Vitis双核固件与视频外设
 * 本文件活动代码对应已验证R6.6 IP1.16 COLOR_AWB，交接阶段不增加算法。
 * 依赖：HLS2020.2或Vitis2020.2，具体目录和构建顺序见根目录上板运行操作步骤。
 * 修改要求：保持C4布局、64B描述符、量化截断顺序、双核共享内存和缓冲所有权。
 * 删除/替换记录：下方仅在确有前驱差异时保存禁用旧代码；不虚构曾删除的代码。
 */

/* 交接补充
 * 本次仅补充中文职责和历史替换说明；活动表达式、寄存器、延时和默认返回值均保留。未删除的历史代码不伪造删除块。
 */

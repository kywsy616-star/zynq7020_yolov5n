// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - enable ap_done interrupt (Read/Write)
//        bit 1  - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - ap_done (COR/TOW)
//        bit 1  - ap_ready (COR/TOW)
//        others - reserved
// 0x10 : Data signal of p_act
//        bit 31~0 - p_act[31:0] (Read/Write)
// 0x14 : Data signal of p_act
//        bit 31~0 - p_act[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of p_wgt
//        bit 31~0 - p_wgt[31:0] (Read/Write)
// 0x20 : Data signal of p_wgt
//        bit 31~0 - p_wgt[63:32] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of p_rqt
//        bit 31~0 - p_rqt[31:0] (Read/Write)
// 0x2c : Data signal of p_rqt
//        bit 31~0 - p_rqt[63:32] (Read/Write)
// 0x30 : reserved
// 0x34 : Data signal of p_tbl
//        bit 31~0 - p_tbl[31:0] (Read/Write)
// 0x38 : Data signal of p_tbl
//        bit 31~0 - p_tbl[63:32] (Read/Write)
// 0x3c : reserved
// 0x40 : Data signal of start_op
//        bit 31~0 - start_op[31:0] (Read/Write)
// 0x44 : reserved
// 0x48 : Data signal of n_ops
//        bit 31~0 - n_ops[31:0] (Read/Write)
// 0x4c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL       0x00
#define XYOLOV5N_TOP_CONTROL_ADDR_GIE           0x04
#define XYOLOV5N_TOP_CONTROL_ADDR_IER           0x08
#define XYOLOV5N_TOP_CONTROL_ADDR_ISR           0x0c
#define XYOLOV5N_TOP_CONTROL_ADDR_P_ACT_DATA    0x10
#define XYOLOV5N_TOP_CONTROL_BITS_P_ACT_DATA    64
#define XYOLOV5N_TOP_CONTROL_ADDR_P_WGT_DATA    0x1c
#define XYOLOV5N_TOP_CONTROL_BITS_P_WGT_DATA    64
#define XYOLOV5N_TOP_CONTROL_ADDR_P_RQT_DATA    0x28
#define XYOLOV5N_TOP_CONTROL_BITS_P_RQT_DATA    64
#define XYOLOV5N_TOP_CONTROL_ADDR_P_TBL_DATA    0x34
#define XYOLOV5N_TOP_CONTROL_BITS_P_TBL_DATA    64
#define XYOLOV5N_TOP_CONTROL_ADDR_START_OP_DATA 0x40
#define XYOLOV5N_TOP_CONTROL_BITS_START_OP_DATA 32
#define XYOLOV5N_TOP_CONTROL_ADDR_N_OPS_DATA    0x48
#define XYOLOV5N_TOP_CONTROL_BITS_N_OPS_DATA    32


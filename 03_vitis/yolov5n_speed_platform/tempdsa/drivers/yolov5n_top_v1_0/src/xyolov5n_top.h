// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XYOLOV5N_TOP_H
#define XYOLOV5N_TOP_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xyolov5n_top_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u32 Control_BaseAddress;
} XYolov5n_top_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XYolov5n_top;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XYolov5n_top_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XYolov5n_top_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XYolov5n_top_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XYolov5n_top_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XYolov5n_top_Initialize(XYolov5n_top *InstancePtr, u16 DeviceId);
XYolov5n_top_Config* XYolov5n_top_LookupConfig(u16 DeviceId);
int XYolov5n_top_CfgInitialize(XYolov5n_top *InstancePtr, XYolov5n_top_Config *ConfigPtr);
#else
int XYolov5n_top_Initialize(XYolov5n_top *InstancePtr, const char* InstanceName);
int XYolov5n_top_Release(XYolov5n_top *InstancePtr);
#endif

void XYolov5n_top_Start(XYolov5n_top *InstancePtr);
u32 XYolov5n_top_IsDone(XYolov5n_top *InstancePtr);
u32 XYolov5n_top_IsIdle(XYolov5n_top *InstancePtr);
u32 XYolov5n_top_IsReady(XYolov5n_top *InstancePtr);
void XYolov5n_top_EnableAutoRestart(XYolov5n_top *InstancePtr);
void XYolov5n_top_DisableAutoRestart(XYolov5n_top *InstancePtr);

void XYolov5n_top_Set_p_act(XYolov5n_top *InstancePtr, u64 Data);
u64 XYolov5n_top_Get_p_act(XYolov5n_top *InstancePtr);
void XYolov5n_top_Set_p_wgt(XYolov5n_top *InstancePtr, u64 Data);
u64 XYolov5n_top_Get_p_wgt(XYolov5n_top *InstancePtr);
void XYolov5n_top_Set_p_rqt(XYolov5n_top *InstancePtr, u64 Data);
u64 XYolov5n_top_Get_p_rqt(XYolov5n_top *InstancePtr);
void XYolov5n_top_Set_p_tbl(XYolov5n_top *InstancePtr, u64 Data);
u64 XYolov5n_top_Get_p_tbl(XYolov5n_top *InstancePtr);
void XYolov5n_top_Set_start_op(XYolov5n_top *InstancePtr, u32 Data);
u32 XYolov5n_top_Get_start_op(XYolov5n_top *InstancePtr);
void XYolov5n_top_Set_n_ops(XYolov5n_top *InstancePtr, u32 Data);
u32 XYolov5n_top_Get_n_ops(XYolov5n_top *InstancePtr);

void XYolov5n_top_InterruptGlobalEnable(XYolov5n_top *InstancePtr);
void XYolov5n_top_InterruptGlobalDisable(XYolov5n_top *InstancePtr);
void XYolov5n_top_InterruptEnable(XYolov5n_top *InstancePtr, u32 Mask);
void XYolov5n_top_InterruptDisable(XYolov5n_top *InstancePtr, u32 Mask);
void XYolov5n_top_InterruptClear(XYolov5n_top *InstancePtr, u32 Mask);
u32 XYolov5n_top_InterruptGetEnabled(XYolov5n_top *InstancePtr);
u32 XYolov5n_top_InterruptGetStatus(XYolov5n_top *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif

// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xyolov5n_top.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XYolov5n_top_CfgInitialize(XYolov5n_top *InstancePtr, XYolov5n_top_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XYolov5n_top_Start(XYolov5n_top *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL) & 0x80;
    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XYolov5n_top_IsDone(XYolov5n_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XYolov5n_top_IsIdle(XYolov5n_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XYolov5n_top_IsReady(XYolov5n_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XYolov5n_top_EnableAutoRestart(XYolov5n_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XYolov5n_top_DisableAutoRestart(XYolov5n_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_AP_CTRL, 0);
}

void XYolov5n_top_Set_p_act(XYolov5n_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_ACT_DATA, (u32)(Data));
    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_ACT_DATA + 4, (u32)(Data >> 32));
}

u64 XYolov5n_top_Get_p_act(XYolov5n_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_ACT_DATA);
    Data += (u64)XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_ACT_DATA + 4) << 32;
    return Data;
}

void XYolov5n_top_Set_p_wgt(XYolov5n_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_WGT_DATA, (u32)(Data));
    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_WGT_DATA + 4, (u32)(Data >> 32));
}

u64 XYolov5n_top_Get_p_wgt(XYolov5n_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_WGT_DATA);
    Data += (u64)XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_WGT_DATA + 4) << 32;
    return Data;
}

void XYolov5n_top_Set_p_rqt(XYolov5n_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_RQT_DATA, (u32)(Data));
    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_RQT_DATA + 4, (u32)(Data >> 32));
}

u64 XYolov5n_top_Get_p_rqt(XYolov5n_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_RQT_DATA);
    Data += (u64)XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_RQT_DATA + 4) << 32;
    return Data;
}

void XYolov5n_top_Set_p_tbl(XYolov5n_top *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_TBL_DATA, (u32)(Data));
    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_TBL_DATA + 4, (u32)(Data >> 32));
}

u64 XYolov5n_top_Get_p_tbl(XYolov5n_top *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_TBL_DATA);
    Data += (u64)XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_P_TBL_DATA + 4) << 32;
    return Data;
}

void XYolov5n_top_Set_start_op(XYolov5n_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_START_OP_DATA, Data);
}

u32 XYolov5n_top_Get_start_op(XYolov5n_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_START_OP_DATA);
    return Data;
}

void XYolov5n_top_Set_n_ops(XYolov5n_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_N_OPS_DATA, Data);
}

u32 XYolov5n_top_Get_n_ops(XYolov5n_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_N_OPS_DATA);
    return Data;
}

void XYolov5n_top_InterruptGlobalEnable(XYolov5n_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_GIE, 1);
}

void XYolov5n_top_InterruptGlobalDisable(XYolov5n_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_GIE, 0);
}

void XYolov5n_top_InterruptEnable(XYolov5n_top *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_IER);
    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_IER, Register | Mask);
}

void XYolov5n_top_InterruptDisable(XYolov5n_top *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_IER);
    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_IER, Register & (~Mask));
}

void XYolov5n_top_InterruptClear(XYolov5n_top *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XYolov5n_top_WriteReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_ISR, Mask);
}

u32 XYolov5n_top_InterruptGetEnabled(XYolov5n_top *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_IER);
}

u32 XYolov5n_top_InterruptGetStatus(XYolov5n_top *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XYolov5n_top_ReadReg(InstancePtr->Control_BaseAddress, XYOLOV5N_TOP_CONTROL_ADDR_ISR);
}


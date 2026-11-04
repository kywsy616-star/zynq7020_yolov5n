// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2020.2 (64-bit)
// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xyolov5n_top.h"

extern XYolov5n_top_Config XYolov5n_top_ConfigTable[];

XYolov5n_top_Config *XYolov5n_top_LookupConfig(u16 DeviceId) {
	XYolov5n_top_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XYOLOV5N_TOP_NUM_INSTANCES; Index++) {
		if (XYolov5n_top_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XYolov5n_top_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XYolov5n_top_Initialize(XYolov5n_top *InstancePtr, u16 DeviceId) {
	XYolov5n_top_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XYolov5n_top_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XYolov5n_top_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif


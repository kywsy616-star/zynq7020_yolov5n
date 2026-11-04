# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\02_workspace\02_vitis_projects\yolov5n_speed_prj\03_vitis\yolov5n_speed_platform\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\02_workspace\02_vitis_projects\yolov5n_speed_prj\03_vitis\yolov5n_speed_platform\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {yolov5n_speed_platform}\
-hw {D:\02_workspace\02_vitis_projects\yolov5n_speed_prj\02_vivado\yolov5n_speed_wrapper_5.xsa}\
-fsbl-target {psu_cortexa53_0} -out {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/03_vitis}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {empty_application}
platform generate -domains 
platform active {yolov5n_speed_platform}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
platform active {yolov5n_speed_platform}
domain active {zynq_fsbl}
bsp reload
catch {bsp regenerate}
domain active {standalone_ps7_cortexa9_0}
bsp reload
catch {bsp regenerate}
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_6.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
platform active {yolov5n_speed_platform}
domain create -name {standalone_ps7_cortexa9_1} -os {standalone} -proc {ps7_cortexa9_1} -arch {32-bit} -display-name {standalone_ps7_cortexa9_1} -desc {} -runtime {cpp}
platform generate -domains 
platform write
domain -report -json
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
bsp reload
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_7.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_7.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
platform clean
platform generate
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_7_1.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_7_2.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_9.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_10.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
platform active {yolov5n_speed_platform}
platform clean
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_11.xsa}
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
platform generate -domains 
platform config -updatehw {D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/02_vivado/yolov5n_speed_wrapper_12.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {yolov5n_speed_platform}
platform generate -domains 

# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: D:\02_workspace\02_vitis_projects\yolov5\yolov5n_speed_prj\yolov5n_speed_prj\03_vitis\yolov5n_speed_system\_ide\scripts\systemdebugger_yolov5n_speed_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source D:\02_workspace\02_vitis_projects\yolov5\yolov5n_speed_prj\yolov5n_speed_prj\03_vitis\yolov5n_speed_system\_ide\scripts\systemdebugger_yolov5n_speed_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent JTAG-SMT3 210357A7D00EA" && level==0 && jtag_device_ctx=="jsn-JTAG-SMT3-210357A7D00EA-23727093-0"}
fpga -file D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/03_vitis/yolov5n_speed_platform/hw/yolov5n_speed_wrapper_12.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw D:/02_workspace/02_vitis_projects/yolov5n_speed_prj/03_vitis/yolov5n_speed_platform/export/yolov5n_speed_platform/hw/yolov5n_speed_wrapper_10.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/03_vitis/yolov5n_speed/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/03_vitis/yolov5n_speed/Debug/yolov5n_speed.elf
targets -set -nocase -filter {name =~ "*A9*#1"}
dow D:/02_workspace/02_vitis_projects/yolov5/yolov5n_speed_prj/yolov5n_speed_prj/03_vitis/yolov5n_speed_1/Debug/yolov5n_speed_1.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
targets -set -nocase -filter {name =~ "*A9*#1"}
con

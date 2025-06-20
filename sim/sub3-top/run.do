# ========================< 清空软件残留信息 >==============================

#1.exit modelsim simulation
quit -sim

#2.clear messages
# .main clear

#3.delete the existing work dir
if [file exists work] {vdel -all}

# =========================< 建立工程并仿真 >===============================

#4.建立新的工程库
vlib work

#5.映射逻辑库到物理目录
vmap work work

set ROOT ../../rtl
set UDP $ROOT/eth
set AXIS $ROOT/axis
#6.编译仿真文件
vlog -work work ./tb_udp_top.v
vlog -work work $ROOT/*.v
vlog -work work $AXIS/*.v
vlog -work work $UDP/*.v
# vlog -work work $ROOT/debounce_switch.v
# vlog -work work $ROOT/sync_signal.v
# vlog -work work $ROOT/udp_top.v
# vlog -work work $ROOT/fpga_core.v
#7.start simulation
vsim -t ns -voptargs=+acc work.tb_udp_top

# Load wave configuration from wave.do
do wave.do
# do wave_ghe.do

#9.run
# temp
run 16000ns

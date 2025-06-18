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
vlog -work work ./tb_udp_rx_path.v
vlog -work work $ROOT/udp_rx_path.v
vlog -work work $AXIS/axis_async_fifo.v
#7.start simulation
vsim -t ns -voptargs=+acc work.tb_udp_rx_path

# Load wave configuration from wave.do
do wave2.do
# do wave_ghe.do

#9.run
# temp
run 4000ns

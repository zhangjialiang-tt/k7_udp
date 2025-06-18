
config wave -signalnamewidth 1

add wave -divider "tb"
add wave -group tb                  -radix unsigned demod_tb/*
add wave -group drive                  -radix unsigned demod_tb/ch1_drv_sweep_inst/*
add wave -group carieer    -radix unsigned demod_tb/ch1_car_sweep_inst/*
add wave -divider "carrier"
add wave -group demodulation_core   -radix unsigned demod_tb/demodulation_core_inst/*
add wave -group cic1                -radix unsigned demod_tb/demodulation_core_inst/cic1_inst/*
add wave -group stage1_lpf           -radix unsigned demod_tb/demodulation_core_inst/stage1_lpf_inst/*
add wave -group moving_average_filter           -radix unsigned demod_tb/demodulation_core_inst/moving_average_filter_inst/*
# add wave -group cic2                -radix unsigned demod_tb/demodulation_core_inst/cic2_inst/*
# add wave -group stage2_lpf           -radix unsigned demod_tb/demodulation_core_inst/stage2_lpf_inst/*

restart

run 5ms
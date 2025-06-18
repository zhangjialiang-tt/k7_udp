config wave -signalnamewidth 1

add wave -divider "tb"
add wave -group tb           -radix unsigned tb_udp_rx_path/*
add wave -group udp_rx_path  -radix unsigned tb_udp_rx_path/dut/*
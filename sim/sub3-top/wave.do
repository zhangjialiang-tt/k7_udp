config wave -signalnamewidth 1

add wave -divider "tb"
add wave -group tb           -radix unsigned tb_udp_top/*
add wave -divider "user_logic"
add wave -group user_logic      -radix unsigned tb_udp_top/DUT/*
add wave -group udp_tx_path  -radix unsigned tb_udp_top/DUT/udp_tx_path_inst/*
add wave -group udp_rx_path  -radix unsigned tb_udp_top/DUT/udp_rx_path_inst/*
add wave -divider "test_logic"
add wave -group test_logic              -radix unsigned tb_udp_top/TEST_DUT/*
add wave -group eth_mac_1g_rgmii_fifo   -radix unsigned tb_udp_top/TEST_DUT/eth_mac_inst/*
# add wave -group eth_mac_1g_rgmii        -radix unsigned tb_udp_top/TEST_DUT/eth_mac_inst/eth_mac_1g_rgmii_inst/*
# add wave -group rgmii_phy_if            -radix unsigned tb_udp_top/TEST_DUT/eth_mac_inst/eth_mac_1g_rgmii_inst/rgmii_phy_if_inst/*
# add wave -group ssio_ddr_in             -radix unsigned tb_udp_top/TEST_DUT/eth_mac_inst/eth_mac_1g_rgmii_inst/rgmii_phy_if_inst/rx_ssio_ddr_inst/*
# add wave -group eth_mac_1g             -radix unsigned tb_udp_top/TEST_DUT/eth_mac_inst/eth_mac_1g_rgmii_inst/eth_mac_1g_inst/*
add wave -group eth_axis_rx   -radix unsigned tb_udp_top/TEST_DUT/eth_axis_rx_inst/*
add wave -group udp_complete   -radix unsigned tb_udp_top/TEST_DUT/udp_complete_inst/*
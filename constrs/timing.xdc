create_clock -period 8.000 -name phy2_rx_clk [get_ports phy2_rx_clk]
create_clock -period 5.000 -name sys_clk_p [get_ports sys_clk_p]

# Ethernet constraints

# IDELAY on RGMII from PHY chip
# set_property IDELAY_VALUE 0 [get_cells {phy2_rx_ctl_idelay phy2_rxd_idelay_*}]



set_false_path -to [get_ports {led[*]}]
set_output_delay 0.000 [get_ports {led[*]}]

set_false_path -to [get_ports uart_txd]
set_output_delay 0.000 [get_ports uart_txd]
set_false_path -from [get_ports uart_rxd]
set_input_delay 0.000 [get_ports uart_rxd]


# set_false_path -from [get_ports {btnu btnl btnd btnr btnc}]
# set_input_delay 0.000 [get_ports {btnu btnl btnd btnr btnc}]


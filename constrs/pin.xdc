# XDC constraints for the Digilent Nexys Video board
# part: xc7a200tsbg484-1

# General configuration
# set_property CFGBVS VCCO [current_design]
# set_property CONFIG_VOLTAGE 3.3 [current_design]
# set_property BITSTREAM.GENERAL.COMPRESS true [current_design]

# 100 MHz clock
set_property -dict {LOC AD12 IOSTANDARD SSTL135} [get_ports clk]

# Key
set_property -dict {LOC Y28 IOSTANDARD LVCMOS18} [get_ports {key_in[0]}]
# set_property -dict {LOC Y28   IOSTANDARD LVCMOS18 } [get_ports {key_in[1]}]
# set_property -dict {LOC AA28  IOSTANDARD LVCMOS18 } [get_ports {key_in[2]}]

# LEDs
set_property -dict {LOC AB28 IOSTANDARD LVCMOS18} [get_ports {led[0]}]
set_property -dict {LOC AA27 IOSTANDARD LVCMOS18} [get_ports {led[1]}]
set_property -dict {LOC J21 IOSTANDARD LVCMOS18} [get_ports {led[2]}]

# Reset button
# set_property -dict {LOC G4 IOSTANDARD LVCMOS15} [get_ports reset_n]

# set_false_path -from [get_ports {reset_n}]
# set_input_delay 0 [get_ports {reset_n}]

# UART
set_property -dict {LOC Y26 IOSTANDARD LVCMOS18} [get_ports uart_txd]
set_property -dict {LOC AA26 IOSTANDARD LVCMOS18} [get_ports uart_rxd]

# Push buttons
# set_property -dict {LOC D26 IOSTANDARD LVCMOS33} [get_ports btnu]
# set_property -dict {LOC G25 IOSTANDARD LVCMOS33} [get_ports btnl]
# set_property -dict {LOC E26 IOSTANDARD LVCMOS33} [get_ports btnd]
# set_property -dict {LOC G26 IOSTANDARD LVCMOS33} [get_ports btnr]
# set_property -dict {LOC H26 IOSTANDARD LVCMOS33} [get_ports btnc]

#------------------- Ethernet MII PHY1 ----------------------

# set_property -dict {PACKAGE_PIN AE2  IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[0]}]
# set_property -dict {PACKAGE_PIN AE1  IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[1]}]
# set_property -dict {PACKAGE_PIN AC1  IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[2]}]
# set_property -dict {PACKAGE_PIN AB1  IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[3]}]
# set_property -dict {PACKAGE_PIN AF3  IOSTANDARD LVCMOS33} [get_ports phy1_rx_ctl]
# set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS33} [get_ports phy1_rx_clk]
# set_property -dict {PACKAGE_PIN AB4  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy1_txd[0]}]
# set_property -dict {PACKAGE_PIN AA4  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy1_txd[1]}]
# set_property -dict {PACKAGE_PIN AA3  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy1_txd[2]}]
# set_property -dict {PACKAGE_PIN AA2  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy1_txd[3]}]
# set_property -dict {PACKAGE_PIN Y3  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy1_tx_ctl]
# set_property -dict {PACKAGE_PIN AC2 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy1_tx_clk]
# set_property -dict {PACKAGE_PIN W1  IOSTANDARD LVCMOS33} [get_ports phy1_reset_n]
# set_property -dict {PACKAGE_PIN Y3 } [get_ports phy2_mdc]
# set_property -dict {PACKAGE_PIN Y1  } [get_ports phy2_mdio]

#------------------- Ethernet MII PHY2 ----------------------

set_property -dict {PACKAGE_PIN AH27 IOSTANDARD LVCMOS18} [get_ports {phy2_rxd[0]}]
set_property -dict {PACKAGE_PIN AJ27 IOSTANDARD LVCMOS18} [get_ports {phy2_rxd[1]}]
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVCMOS18} [get_ports {phy2_rxd[2]}]
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVCMOS18} [get_ports {phy2_rxd[3]}]
set_property -dict {PACKAGE_PIN AH26 IOSTANDARD LVCMOS18} [get_ports phy2_rx_ctl]
set_property -dict {PACKAGE_PIN AG29 IOSTANDARD LVCMOS18} [get_ports phy2_rx_clk]
set_property -dict {PACKAGE_PIN AH30 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {phy2_txd[0]}]
set_property -dict {PACKAGE_PIN AJ28 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {phy2_txd[1]}]
set_property -dict {PACKAGE_PIN AJ29 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {phy2_txd[2]}]
set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {phy2_txd[3]}]
set_property -dict {PACKAGE_PIN AG30 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports phy2_tx_ctl]
set_property -dict {PACKAGE_PIN AK26 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports phy2_tx_clk]
set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS18} [get_ports phy2_reset_n]
# set_property -dict {PACKAGE_PIN AA25 } [get_ports phy2_mdc]
# set_property -dict {PACKAGE_PIN Y25  } [get_ports phy2_mdio]




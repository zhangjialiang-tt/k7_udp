# XDC constraints for the Digilent Nexys Video board
# part: xc7a200tsbg484-1

# General configuration
# set_property CFGBVS VCCO [current_design]
# set_property CONFIG_VOLTAGE 3.3 [current_design]
# set_property BITSTREAM.GENERAL.COMPRESS true [current_design]

# 100 MHz clock
set_property -dict {LOC G22 IOSTANDARD LVCMOS33} [get_ports clk]


# LEDs
set_property -dict {LOC E25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[7]}]
set_property -dict {LOC D25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[6]}]
set_property -dict {LOC D24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[5]}]
set_property -dict {LOC C26 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[4]}]
set_property -dict {LOC C24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[3]}]
set_property -dict {LOC D23 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[2]}]
set_property -dict {LOC A24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[1]}]
set_property -dict {LOC A23 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[0]}]

# Reset button
# set_property -dict {LOC G4 IOSTANDARD LVCMOS15} [get_ports reset_n]

# set_false_path -from [get_ports {reset_n}]
# set_input_delay 0 [get_ports {reset_n}]

# UART
set_property -dict {LOC A17 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports uart_txd]
set_property -dict {LOC B17 IOSTANDARD LVCMOS33} [get_ports uart_rxd]

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

set_property -dict {PACKAGE_PIN V26  IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[0]}]
set_property -dict {PACKAGE_PIN V21  IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[1]}]
set_property -dict {PACKAGE_PIN U24  IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[2]}]
set_property -dict {PACKAGE_PIN U25  IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[3]}]
set_property -dict {PACKAGE_PIN U26  IOSTANDARD LVCMOS33} [get_ports phy2_rx_ctl]
set_property -dict {PACKAGE_PIN AA23 IOSTANDARD LVCMOS33} [get_ports phy2_rx_clk]
set_property -dict {PACKAGE_PIN V22  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[0]}]
set_property -dict {PACKAGE_PIN W26  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[1]}]
set_property -dict {PACKAGE_PIN W25  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[2]}]
set_property -dict {PACKAGE_PIN W21  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[3]}]
set_property -dict {PACKAGE_PIN W23  IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy2_tx_ctl]
set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy2_tx_clk]
set_property -dict {PACKAGE_PIN H22  IOSTANDARD LVCMOS33} [get_ports phy2_reset_n]
# set_property -dict {PACKAGE_PIN AA25 } [get_ports phy2_mdc]
# set_property -dict {PACKAGE_PIN Y25  } [get_ports phy2_mdio]


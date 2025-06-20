# XDC constraints for the Digilent Nexys Video board
# part: xc7a200tsbg484-1

# General configuration
# set_property CFGBVS VCCO [current_design]
# set_property CONFIG_VOLTAGE 3.3 [current_design]
# set_property BITSTREAM.GENERAL.COMPRESS true [current_design]

# 100 MHz clock
set_property -dict {LOC R4 IOSTANDARD DIFF_SSTL15} [get_ports sys_clk_p]


# LEDs
# set_property -dict {LOC E25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[7]}]
# set_property -dict {LOC D25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[6]}]
# set_property -dict {LOC D24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[5]}]
# set_property -dict {LOC C26 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[4]}]
# set_property -dict {LOC C24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[3]}]
# set_property -dict {LOC D23 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[2]}]
# set_property -dict {LOC A24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[1]}]
set_property -dict {LOC V17 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led[0]}]

# Reset button
# set_property -dict {LOC G4 IOSTANDARD LVCMOS15} [get_ports reset_n]

# set_false_path -from [get_ports {reset_n}]
# set_input_delay 0 [get_ports {reset_n}]

# UART
set_property -dict {LOC AA14 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports uart_txd]
set_property -dict {LOC Y13 IOSTANDARD LVCMOS33} [get_ports uart_rxd]

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

# 以太网 RTL8211FI-CG
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[3]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[2]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[1]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[0]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports phy2_rx_ctl]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports phy2_rx_clk]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[3]}]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[2]}]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[1]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[0]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy2_tx_ctl]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy2_tx_clk]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports phy2_reset_n]
# set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports eth_mdio_mdio_io]
# set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports eth_mdio_mdc]
# set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports eth_init]


# 黑金开发板
# set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[3]}]
# set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[2]}]
# set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[1]}]
# set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {phy1_rxd[0]}]
# set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports phy1_rx_ctl]
# set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports phy1_rx_clk]
# set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33 LVCMOS33 SLEW FAST} [get_ports {phy1_txd[3]}]
# set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33 LVCMOS33 SLEW FAST} [get_ports {phy1_txd[2]}]
# set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33 LVCMOS33 SLEW FAST} [get_ports {phy1_txd[1]}]
# set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33 LVCMOS33 SLEW FAST} [get_ports {phy1_txd[0]}]
# set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33 LVCMOS33 SLEW FAST} [get_ports phy1_tx_ctl]
# set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33 LVCMOS33 SLEW FAST} [get_ports phy1_tx_clk]
# set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports phy1_reset_n]
# set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports phy1_mdc]
# set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports phy1_mdio]

# 黑金开发板
# set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[3]}]
# set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[2]}]
# set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[1]}]
# set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {phy2_rxd[0]}]
# set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports phy2_rx_ctl]
# set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports phy2_rx_clk]
# set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[3]}]
# set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[2]}]
# set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[1]}]
# set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {phy2_txd[0]}]
# set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy2_tx_ctl]
# set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports phy2_tx_clk]
# set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports phy2_reset_n]
# set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports phy2_mdc]
# set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports phy2_mdio]
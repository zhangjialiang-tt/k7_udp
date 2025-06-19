create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_int]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_eth_type[0]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[1]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[2]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[3]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[4]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[5]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[6]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[7]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[8]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[9]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[10]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[11]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[12]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[13]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[14]} {udp_top_inst/udp_core_inst/rx_ip_eth_type[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[0]} {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[1]} {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[2]} {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[3]} {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[4]} {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[5]} {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[6]} {udp_top_inst/udp_core_inst/rx_eth_payload_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {udp_top_inst/udp_core_inst/rx_eth_type[0]} {udp_top_inst/udp_core_inst/rx_eth_type[1]} {udp_top_inst/udp_core_inst/rx_eth_type[2]} {udp_top_inst/udp_core_inst/rx_eth_type[3]} {udp_top_inst/udp_core_inst/rx_eth_type[4]} {udp_top_inst/udp_core_inst/rx_eth_type[5]} {udp_top_inst/udp_core_inst/rx_eth_type[6]} {udp_top_inst/udp_core_inst/rx_eth_type[7]} {udp_top_inst/udp_core_inst/rx_eth_type[8]} {udp_top_inst/udp_core_inst/rx_eth_type[9]} {udp_top_inst/udp_core_inst/rx_eth_type[10]} {udp_top_inst/udp_core_inst/rx_eth_type[11]} {udp_top_inst/udp_core_inst/rx_eth_type[12]} {udp_top_inst/udp_core_inst/rx_eth_type[13]} {udp_top_inst/udp_core_inst/rx_eth_type[14]} {udp_top_inst/udp_core_inst/rx_eth_type[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 48 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {udp_top_inst/udp_core_inst/rx_eth_dest_mac[0]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[1]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[2]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[3]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[4]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[5]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[6]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[7]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[8]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[9]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[10]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[11]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[12]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[13]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[14]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[15]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[16]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[17]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[18]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[19]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[20]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[21]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[22]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[23]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[24]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[25]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[26]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[27]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[28]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[29]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[30]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[31]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[32]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[33]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[34]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[35]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[36]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[37]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[38]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[39]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[40]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[41]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[42]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[43]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[44]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[45]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[46]} {udp_top_inst/udp_core_inst/rx_eth_dest_mac[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_dest_ip[0]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[1]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[2]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[3]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[4]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[5]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[6]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[7]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[8]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[9]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[10]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[11]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[12]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[13]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[14]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[15]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[16]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[17]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[18]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[19]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[20]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[21]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[22]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[23]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[24]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[25]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[26]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[27]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[28]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[29]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[30]} {udp_top_inst/udp_core_inst/rx_ip_dest_ip[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 48 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[0]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[1]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[2]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[3]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[4]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[5]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[6]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[7]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[8]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[9]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[10]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[11]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[12]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[13]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[14]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[15]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[16]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[17]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[18]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[19]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[20]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[21]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[22]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[23]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[24]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[25]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[26]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[27]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[28]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[29]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[30]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[31]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[32]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[33]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[34]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[35]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[36]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[37]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[38]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[39]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[40]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[41]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[42]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[43]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[44]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[45]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[46]} {udp_top_inst/udp_core_inst/rx_ip_eth_dest_mac[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 48 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[0]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[1]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[2]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[3]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[4]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[5]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[6]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[7]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[8]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[9]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[10]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[11]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[12]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[13]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[14]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[15]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[16]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[17]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[18]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[19]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[20]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[21]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[22]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[23]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[24]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[25]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[26]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[27]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[28]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[29]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[30]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[31]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[32]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[33]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[34]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[35]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[36]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[37]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[38]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[39]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[40]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[41]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[42]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[43]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[44]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[45]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[46]} {udp_top_inst/udp_core_inst/rx_ip_eth_src_mac[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {udp_top_inst/udp_core_inst/rx_axis_tdata[0]} {udp_top_inst/udp_core_inst/rx_axis_tdata[1]} {udp_top_inst/udp_core_inst/rx_axis_tdata[2]} {udp_top_inst/udp_core_inst/rx_axis_tdata[3]} {udp_top_inst/udp_core_inst/rx_axis_tdata[4]} {udp_top_inst/udp_core_inst/rx_axis_tdata[5]} {udp_top_inst/udp_core_inst/rx_axis_tdata[6]} {udp_top_inst/udp_core_inst/rx_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 48 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {udp_top_inst/udp_core_inst/rx_eth_src_mac[0]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[1]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[2]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[3]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[4]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[5]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[6]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[7]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[8]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[9]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[10]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[11]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[12]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[13]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[14]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[15]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[16]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[17]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[18]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[19]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[20]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[21]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[22]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[23]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[24]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[25]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[26]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[27]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[28]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[29]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[30]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[31]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[32]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[33]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[34]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[35]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[36]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[37]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[38]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[39]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[40]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[41]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[42]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[43]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[44]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[45]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[46]} {udp_top_inst/udp_core_inst/rx_eth_src_mac[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 6 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_dscp[0]} {udp_top_inst/udp_core_inst/rx_ip_dscp[1]} {udp_top_inst/udp_core_inst/rx_ip_dscp[2]} {udp_top_inst/udp_core_inst/rx_ip_dscp[3]} {udp_top_inst/udp_core_inst/rx_ip_dscp[4]} {udp_top_inst/udp_core_inst/rx_ip_dscp[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 2 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_ecn[0]} {udp_top_inst/udp_core_inst/rx_ip_ecn[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 4 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_ihl[0]} {udp_top_inst/udp_core_inst/rx_ip_ihl[1]} {udp_top_inst/udp_core_inst/rx_ip_ihl[2]} {udp_top_inst/udp_core_inst/rx_ip_ihl[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_source_ip[0]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[1]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[2]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[3]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[4]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[5]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[6]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[7]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[8]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[9]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[10]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[11]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[12]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[13]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[14]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[15]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[16]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[17]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[18]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[19]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[20]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[21]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[22]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[23]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[24]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[25]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[26]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[27]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[28]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[29]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[30]} {udp_top_inst/udp_core_inst/rx_ip_source_ip[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 4 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_ihl[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_ihl[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_ihl[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_ihl[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 8 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[0]} {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[1]} {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[2]} {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[3]} {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[4]} {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[5]} {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[6]} {udp_top_inst/udp_core_inst/rx_udp_payload_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_ttl[0]} {udp_top_inst/udp_core_inst/rx_ip_ttl[1]} {udp_top_inst/udp_core_inst/rx_ip_ttl[2]} {udp_top_inst/udp_core_inst/rx_ip_ttl[3]} {udp_top_inst/udp_core_inst/rx_ip_ttl[4]} {udp_top_inst/udp_core_inst/rx_ip_ttl[5]} {udp_top_inst/udp_core_inst/rx_ip_ttl[6]} {udp_top_inst/udp_core_inst/rx_ip_ttl[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 48 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[0]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[1]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[2]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[3]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[4]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[5]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[6]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[7]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[8]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[9]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[10]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[11]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[12]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[13]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[14]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[15]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[16]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[17]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[18]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[19]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[20]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[21]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[22]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[23]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[24]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[25]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[26]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[27]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[28]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[29]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[30]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[31]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[32]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[33]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[34]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[35]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[36]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[37]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[38]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[39]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[40]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[41]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[42]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[43]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[44]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[45]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[46]} {udp_top_inst/udp_core_inst/rx_udp_eth_dest_mac[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 13 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[0]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[1]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[2]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[3]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[4]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[5]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[6]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[7]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[8]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[9]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[10]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[11]} {udp_top_inst/udp_core_inst/rx_ip_fragment_offset[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 16 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_length[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[7]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[8]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[9]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[10]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[11]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[12]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[13]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[14]} {udp_top_inst/udp_core_inst/rx_udp_ip_length[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 8 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_protocol[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 4 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_version[0]} {udp_top_inst/udp_core_inst/rx_ip_version[1]} {udp_top_inst/udp_core_inst/rx_ip_version[2]} {udp_top_inst/udp_core_inst/rx_ip_version[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 16 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[7]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[8]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[9]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[10]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[11]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[12]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[13]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[14]} {udp_top_inst/udp_core_inst/rx_udp_ip_header_checksum[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 16 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_identification[0]} {udp_top_inst/udp_core_inst/rx_ip_identification[1]} {udp_top_inst/udp_core_inst/rx_ip_identification[2]} {udp_top_inst/udp_core_inst/rx_ip_identification[3]} {udp_top_inst/udp_core_inst/rx_ip_identification[4]} {udp_top_inst/udp_core_inst/rx_ip_identification[5]} {udp_top_inst/udp_core_inst/rx_ip_identification[6]} {udp_top_inst/udp_core_inst/rx_ip_identification[7]} {udp_top_inst/udp_core_inst/rx_ip_identification[8]} {udp_top_inst/udp_core_inst/rx_ip_identification[9]} {udp_top_inst/udp_core_inst/rx_ip_identification[10]} {udp_top_inst/udp_core_inst/rx_ip_identification[11]} {udp_top_inst/udp_core_inst/rx_ip_identification[12]} {udp_top_inst/udp_core_inst/rx_ip_identification[13]} {udp_top_inst/udp_core_inst/rx_ip_identification[14]} {udp_top_inst/udp_core_inst/rx_ip_identification[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 8 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[0]} {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[1]} {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[2]} {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[3]} {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[4]} {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[5]} {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[6]} {udp_top_inst/udp_core_inst/rx_ip_payload_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 3 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_flags[0]} {udp_top_inst/udp_core_inst/rx_ip_flags[1]} {udp_top_inst/udp_core_inst/rx_ip_flags[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 32 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[7]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[8]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[9]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[10]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[11]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[12]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[13]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[14]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[15]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[16]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[17]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[18]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[19]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[20]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[21]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[22]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[23]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[24]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[25]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[26]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[27]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[28]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[29]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[30]} {udp_top_inst/udp_core_inst/rx_udp_ip_source_ip[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 3 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_flags[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_flags[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_flags[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 13 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[7]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[8]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[9]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[10]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[11]} {udp_top_inst/udp_core_inst/rx_udp_ip_fragment_offset[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 32 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[7]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[8]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[9]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[10]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[11]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[12]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[13]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[14]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[15]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[16]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[17]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[18]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[19]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[20]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[21]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[22]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[23]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[24]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[25]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[26]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[27]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[28]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[29]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[30]} {udp_top_inst/udp_core_inst/rx_udp_ip_dest_ip[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 4 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_version[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_version[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_version[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_version[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 16 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_length[0]} {udp_top_inst/udp_core_inst/rx_udp_length[1]} {udp_top_inst/udp_core_inst/rx_udp_length[2]} {udp_top_inst/udp_core_inst/rx_udp_length[3]} {udp_top_inst/udp_core_inst/rx_udp_length[4]} {udp_top_inst/udp_core_inst/rx_udp_length[5]} {udp_top_inst/udp_core_inst/rx_udp_length[6]} {udp_top_inst/udp_core_inst/rx_udp_length[7]} {udp_top_inst/udp_core_inst/rx_udp_length[8]} {udp_top_inst/udp_core_inst/rx_udp_length[9]} {udp_top_inst/udp_core_inst/rx_udp_length[10]} {udp_top_inst/udp_core_inst/rx_udp_length[11]} {udp_top_inst/udp_core_inst/rx_udp_length[12]} {udp_top_inst/udp_core_inst/rx_udp_length[13]} {udp_top_inst/udp_core_inst/rx_udp_length[14]} {udp_top_inst/udp_core_inst/rx_udp_length[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 16 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_dest_port[0]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[1]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[2]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[3]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[4]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[5]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[6]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[7]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[8]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[9]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[10]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[11]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[12]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[13]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[14]} {udp_top_inst/udp_core_inst/rx_udp_dest_port[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 16 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_source_port[0]} {udp_top_inst/udp_core_inst/rx_udp_source_port[1]} {udp_top_inst/udp_core_inst/rx_udp_source_port[2]} {udp_top_inst/udp_core_inst/rx_udp_source_port[3]} {udp_top_inst/udp_core_inst/rx_udp_source_port[4]} {udp_top_inst/udp_core_inst/rx_udp_source_port[5]} {udp_top_inst/udp_core_inst/rx_udp_source_port[6]} {udp_top_inst/udp_core_inst/rx_udp_source_port[7]} {udp_top_inst/udp_core_inst/rx_udp_source_port[8]} {udp_top_inst/udp_core_inst/rx_udp_source_port[9]} {udp_top_inst/udp_core_inst/rx_udp_source_port[10]} {udp_top_inst/udp_core_inst/rx_udp_source_port[11]} {udp_top_inst/udp_core_inst/rx_udp_source_port[12]} {udp_top_inst/udp_core_inst/rx_udp_source_port[13]} {udp_top_inst/udp_core_inst/rx_udp_source_port[14]} {udp_top_inst/udp_core_inst/rx_udp_source_port[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 6 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_dscp[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_dscp[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_dscp[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_dscp[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_dscp[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_dscp[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 16 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_header_checksum[0]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[1]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[2]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[3]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[4]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[5]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[6]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[7]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[8]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[9]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[10]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[11]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[12]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[13]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[14]} {udp_top_inst/udp_core_inst/rx_ip_header_checksum[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 16 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_eth_type[0]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[1]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[2]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[3]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[4]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[5]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[6]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[7]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[8]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[9]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[10]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[11]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[12]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[13]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[14]} {udp_top_inst/udp_core_inst/rx_udp_eth_type[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 16 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_length[0]} {udp_top_inst/udp_core_inst/rx_ip_length[1]} {udp_top_inst/udp_core_inst/rx_ip_length[2]} {udp_top_inst/udp_core_inst/rx_ip_length[3]} {udp_top_inst/udp_core_inst/rx_ip_length[4]} {udp_top_inst/udp_core_inst/rx_ip_length[5]} {udp_top_inst/udp_core_inst/rx_ip_length[6]} {udp_top_inst/udp_core_inst/rx_ip_length[7]} {udp_top_inst/udp_core_inst/rx_ip_length[8]} {udp_top_inst/udp_core_inst/rx_ip_length[9]} {udp_top_inst/udp_core_inst/rx_ip_length[10]} {udp_top_inst/udp_core_inst/rx_ip_length[11]} {udp_top_inst/udp_core_inst/rx_ip_length[12]} {udp_top_inst/udp_core_inst/rx_ip_length[13]} {udp_top_inst/udp_core_inst/rx_ip_length[14]} {udp_top_inst/udp_core_inst/rx_ip_length[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 16 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_checksum[0]} {udp_top_inst/udp_core_inst/rx_udp_checksum[1]} {udp_top_inst/udp_core_inst/rx_udp_checksum[2]} {udp_top_inst/udp_core_inst/rx_udp_checksum[3]} {udp_top_inst/udp_core_inst/rx_udp_checksum[4]} {udp_top_inst/udp_core_inst/rx_udp_checksum[5]} {udp_top_inst/udp_core_inst/rx_udp_checksum[6]} {udp_top_inst/udp_core_inst/rx_udp_checksum[7]} {udp_top_inst/udp_core_inst/rx_udp_checksum[8]} {udp_top_inst/udp_core_inst/rx_udp_checksum[9]} {udp_top_inst/udp_core_inst/rx_udp_checksum[10]} {udp_top_inst/udp_core_inst/rx_udp_checksum[11]} {udp_top_inst/udp_core_inst/rx_udp_checksum[12]} {udp_top_inst/udp_core_inst/rx_udp_checksum[13]} {udp_top_inst/udp_core_inst/rx_udp_checksum[14]} {udp_top_inst/udp_core_inst/rx_udp_checksum[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 16 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_identification[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[7]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[8]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[9]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[10]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[11]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[12]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[13]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[14]} {udp_top_inst/udp_core_inst/rx_udp_ip_identification[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 48 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[0]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[1]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[2]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[3]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[4]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[5]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[6]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[7]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[8]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[9]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[10]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[11]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[12]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[13]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[14]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[15]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[16]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[17]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[18]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[19]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[20]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[21]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[22]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[23]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[24]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[25]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[26]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[27]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[28]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[29]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[30]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[31]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[32]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[33]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[34]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[35]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[36]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[37]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[38]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[39]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[40]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[41]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[42]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[43]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[44]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[45]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[46]} {udp_top_inst/udp_core_inst/rx_udp_eth_src_mac[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 8 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[1]} {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[2]} {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[3]} {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[4]} {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[5]} {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[6]} {udp_top_inst/udp_core_inst/rx_udp_ip_ttl[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 2 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list {udp_top_inst/udp_core_inst/rx_udp_ip_ecn[0]} {udp_top_inst/udp_core_inst/rx_udp_ip_ecn[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 8 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list {udp_top_inst/udp_core_inst/rx_ip_protocol[0]} {udp_top_inst/udp_core_inst/rx_ip_protocol[1]} {udp_top_inst/udp_core_inst/rx_ip_protocol[2]} {udp_top_inst/udp_core_inst/rx_ip_protocol[3]} {udp_top_inst/udp_core_inst/rx_ip_protocol[4]} {udp_top_inst/udp_core_inst/rx_ip_protocol[5]} {udp_top_inst/udp_core_inst/rx_ip_protocol[6]} {udp_top_inst/udp_core_inst/rx_ip_protocol[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 32 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_data_buffer[0]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[1]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[2]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[3]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[4]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[5]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[6]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[7]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[8]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[9]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[10]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[11]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[12]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[13]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[14]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[15]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[16]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[17]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[18]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[19]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[20]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[21]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[22]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[23]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[24]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[25]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[26]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[27]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[28]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[29]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[30]} {udp_top_inst/udp_rx_path_inst/rx_data_buffer[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 8 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[0]} {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[1]} {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[2]} {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[3]} {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[4]} {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[5]} {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[6]} {udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 16 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[0]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[1]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[2]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[3]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[4]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[5]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[6]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[7]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[8]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[9]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[10]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[11]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[12]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[13]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[14]} {udp_top_inst/udp_rx_path_inst/rx_udp_dest_port[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 4 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_byte_index[0]} {udp_top_inst/udp_rx_path_inst/rx_byte_index[1]} {udp_top_inst/udp_rx_path_inst/rx_byte_index[2]} {udp_top_inst/udp_rx_path_inst/rx_byte_index[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 32 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[0]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[1]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[2]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[3]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[4]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[5]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[6]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[7]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[8]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[9]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[10]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[11]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[12]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[13]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[14]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[15]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[16]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[17]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[18]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[19]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[20]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[21]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[22]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[23]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[24]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[25]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[26]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[27]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[28]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[29]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[30]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_source_ip[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 32 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[0]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[1]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[2]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[3]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[4]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[5]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[6]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[7]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[8]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[9]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[10]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[11]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[12]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[13]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[14]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[15]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[16]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[17]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[18]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[19]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[20]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[21]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[22]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[23]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[24]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[25]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[26]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[27]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[28]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[29]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[30]} {udp_top_inst/udp_rx_path_inst/rx_udp_ip_dest_ip[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 16 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[0]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[1]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[2]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[3]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[4]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[5]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[6]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[7]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[8]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[9]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[10]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[11]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[12]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[13]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[14]} {udp_top_inst/udp_rx_path_inst/rx_udp_source_port[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 8 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[0]} {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[1]} {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[2]} {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[3]} {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[4]} {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[5]} {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[6]} {udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 32 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list {udp_top_inst/udp_rx_path_inst/dout_data[0]} {udp_top_inst/udp_rx_path_inst/dout_data[1]} {udp_top_inst/udp_rx_path_inst/dout_data[2]} {udp_top_inst/udp_rx_path_inst/dout_data[3]} {udp_top_inst/udp_rx_path_inst/dout_data[4]} {udp_top_inst/udp_rx_path_inst/dout_data[5]} {udp_top_inst/udp_rx_path_inst/dout_data[6]} {udp_top_inst/udp_rx_path_inst/dout_data[7]} {udp_top_inst/udp_rx_path_inst/dout_data[8]} {udp_top_inst/udp_rx_path_inst/dout_data[9]} {udp_top_inst/udp_rx_path_inst/dout_data[10]} {udp_top_inst/udp_rx_path_inst/dout_data[11]} {udp_top_inst/udp_rx_path_inst/dout_data[12]} {udp_top_inst/udp_rx_path_inst/dout_data[13]} {udp_top_inst/udp_rx_path_inst/dout_data[14]} {udp_top_inst/udp_rx_path_inst/dout_data[15]} {udp_top_inst/udp_rx_path_inst/dout_data[16]} {udp_top_inst/udp_rx_path_inst/dout_data[17]} {udp_top_inst/udp_rx_path_inst/dout_data[18]} {udp_top_inst/udp_rx_path_inst/dout_data[19]} {udp_top_inst/udp_rx_path_inst/dout_data[20]} {udp_top_inst/udp_rx_path_inst/dout_data[21]} {udp_top_inst/udp_rx_path_inst/dout_data[22]} {udp_top_inst/udp_rx_path_inst/dout_data[23]} {udp_top_inst/udp_rx_path_inst/dout_data[24]} {udp_top_inst/udp_rx_path_inst/dout_data[25]} {udp_top_inst/udp_rx_path_inst/dout_data[26]} {udp_top_inst/udp_rx_path_inst/dout_data[27]} {udp_top_inst/udp_rx_path_inst/dout_data[28]} {udp_top_inst/udp_rx_path_inst/dout_data[29]} {udp_top_inst/udp_rx_path_inst/dout_data[30]} {udp_top_inst/udp_rx_path_inst/dout_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 8 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[0]} {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[1]} {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[2]} {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[3]} {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[4]} {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[5]} {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[6]} {udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 2 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list {udp_top_inst/udp_rx_path_inst/rx_app_state[0]} {udp_top_inst/udp_rx_path_inst/rx_app_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 1 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list udp_top_inst/udp_rx_path_inst/dout_last]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 1 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list udp_top_inst/udp_rx_path_inst/dout_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe56]
set_property port_width 1 [get_debug_ports u_ila_0/probe56]
connect_debug_port u_ila_0/probe56 [get_nets [list udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe57]
set_property port_width 1 [get_debug_ports u_ila_0/probe57]
connect_debug_port u_ila_0/probe57 [get_nets [list udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe58]
set_property port_width 1 [get_debug_ports u_ila_0/probe58]
connect_debug_port u_ila_0/probe58 [get_nets [list udp_top_inst/udp_rx_path_inst/m_app_rx_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe59]
set_property port_width 1 [get_debug_ports u_ila_0/probe59]
connect_debug_port u_ila_0/probe59 [get_nets [list udp_top_inst/udp_rx_path_inst/packet_match]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe60]
set_property port_width 1 [get_debug_ports u_ila_0/probe60]
connect_debug_port u_ila_0/probe60 [get_nets [list udp_top_inst/udp_core_inst/rx_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe61]
set_property port_width 1 [get_debug_ports u_ila_0/probe61]
connect_debug_port u_ila_0/probe61 [get_nets [list udp_top_inst/udp_core_inst/rx_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe62]
set_property port_width 1 [get_debug_ports u_ila_0/probe62]
connect_debug_port u_ila_0/probe62 [get_nets [list udp_top_inst/udp_core_inst/rx_axis_tuser]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe63]
set_property port_width 1 [get_debug_ports u_ila_0/probe63]
connect_debug_port u_ila_0/probe63 [get_nets [list udp_top_inst/udp_core_inst/rx_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe64]
set_property port_width 1 [get_debug_ports u_ila_0/probe64]
connect_debug_port u_ila_0/probe64 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_drop_packet_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe65]
set_property port_width 1 [get_debug_ports u_ila_0/probe65]
connect_debug_port u_ila_0/probe65 [get_nets [list udp_top_inst/udp_core_inst/rx_eth_hdr_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe66]
set_property port_width 1 [get_debug_ports u_ila_0/probe66]
connect_debug_port u_ila_0/probe66 [get_nets [list udp_top_inst/udp_core_inst/rx_eth_hdr_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe67]
set_property port_width 1 [get_debug_ports u_ila_0/probe67]
connect_debug_port u_ila_0/probe67 [get_nets [list udp_top_inst/udp_core_inst/rx_eth_payload_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe68]
set_property port_width 1 [get_debug_ports u_ila_0/probe68]
connect_debug_port u_ila_0/probe68 [get_nets [list udp_top_inst/udp_core_inst/rx_eth_payload_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe69]
set_property port_width 1 [get_debug_ports u_ila_0/probe69]
connect_debug_port u_ila_0/probe69 [get_nets [list udp_top_inst/udp_core_inst/rx_eth_payload_axis_tuser]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe70]
set_property port_width 1 [get_debug_ports u_ila_0/probe70]
connect_debug_port u_ila_0/probe70 [get_nets [list udp_top_inst/udp_core_inst/rx_eth_payload_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe71]
set_property port_width 1 [get_debug_ports u_ila_0/probe71]
connect_debug_port u_ila_0/probe71 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe72]
set_property port_width 1 [get_debug_ports u_ila_0/probe72]
connect_debug_port u_ila_0/probe72 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe73]
set_property port_width 1 [get_debug_ports u_ila_0/probe73]
connect_debug_port u_ila_0/probe73 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tuser]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe74]
set_property port_width 1 [get_debug_ports u_ila_0/probe74]
connect_debug_port u_ila_0/probe74 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_fifo_in_payload_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe75]
set_property port_width 1 [get_debug_ports u_ila_0/probe75]
connect_debug_port u_ila_0/probe75 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe76]
set_property port_width 1 [get_debug_ports u_ila_0/probe76]
connect_debug_port u_ila_0/probe76 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe77]
set_property port_width 1 [get_debug_ports u_ila_0/probe77]
connect_debug_port u_ila_0/probe77 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_fifo_out_payload_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe78]
set_property port_width 1 [get_debug_ports u_ila_0/probe78]
connect_debug_port u_ila_0/probe78 [get_nets [list udp_top_inst/udp_core_inst/rx_ip_hdr_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe79]
set_property port_width 1 [get_debug_ports u_ila_0/probe79]
connect_debug_port u_ila_0/probe79 [get_nets [list udp_top_inst/udp_core_inst/rx_ip_hdr_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe80]
set_property port_width 1 [get_debug_ports u_ila_0/probe80]
connect_debug_port u_ila_0/probe80 [get_nets [list udp_top_inst/udp_core_inst/rx_ip_payload_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe81]
set_property port_width 1 [get_debug_ports u_ila_0/probe81]
connect_debug_port u_ila_0/probe81 [get_nets [list udp_top_inst/udp_core_inst/rx_ip_payload_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe82]
set_property port_width 1 [get_debug_ports u_ila_0/probe82]
connect_debug_port u_ila_0/probe82 [get_nets [list udp_top_inst/udp_core_inst/rx_ip_payload_axis_tuser]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe83]
set_property port_width 1 [get_debug_ports u_ila_0/probe83]
connect_debug_port u_ila_0/probe83 [get_nets [list udp_top_inst/udp_core_inst/rx_ip_payload_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe84]
set_property port_width 1 [get_debug_ports u_ila_0/probe84]
connect_debug_port u_ila_0/probe84 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_output_last]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe85]
set_property port_width 1 [get_debug_ports u_ila_0/probe85]
connect_debug_port u_ila_0/probe85 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_output_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe86]
set_property port_width 1 [get_debug_ports u_ila_0/probe86]
connect_debug_port u_ila_0/probe86 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_packet_active_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe87]
set_property port_width 1 [get_debug_ports u_ila_0/probe87]
connect_debug_port u_ila_0/probe87 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_udp_hdr_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe88]
set_property port_width 1 [get_debug_ports u_ila_0/probe88]
connect_debug_port u_ila_0/probe88 [get_nets [list udp_top_inst/udp_core_inst/rx_udp_hdr_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe89]
set_property port_width 1 [get_debug_ports u_ila_0/probe89]
connect_debug_port u_ila_0/probe89 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_udp_hdr_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe90]
set_property port_width 1 [get_debug_ports u_ila_0/probe90]
connect_debug_port u_ila_0/probe90 [get_nets [list udp_top_inst/udp_core_inst/rx_udp_hdr_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe91]
set_property port_width 1 [get_debug_ports u_ila_0/probe91]
connect_debug_port u_ila_0/probe91 [get_nets [list udp_top_inst/udp_core_inst/rx_udp_payload_axis_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe92]
set_property port_width 1 [get_debug_ports u_ila_0/probe92]
connect_debug_port u_ila_0/probe92 [get_nets [list udp_top_inst/udp_core_inst/rx_udp_payload_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe93]
set_property port_width 1 [get_debug_ports u_ila_0/probe93]
connect_debug_port u_ila_0/probe93 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_udp_payload_axis_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe94]
set_property port_width 1 [get_debug_ports u_ila_0/probe94]
connect_debug_port u_ila_0/probe94 [get_nets [list udp_top_inst/udp_core_inst/rx_udp_payload_axis_tuser]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe95]
set_property port_width 1 [get_debug_ports u_ila_0/probe95]
connect_debug_port u_ila_0/probe95 [get_nets [list udp_top_inst/udp_rx_path_inst/rx_udp_payload_axis_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe96]
set_property port_width 1 [get_debug_ports u_ila_0/probe96]
connect_debug_port u_ila_0/probe96 [get_nets [list udp_top_inst/udp_core_inst/rx_udp_payload_axis_tvalid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_int]

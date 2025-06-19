onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tb
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/sys_clk
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/sys_rst
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/din_data
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/din_valid
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/din_last
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/din_ready
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/clk
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/rst
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_hdr_valid
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_hdr_ready
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_ip_dscp
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_ip_ecn
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_ip_dest_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_length
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_payload_axis_tdata
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_payload_axis_tvalid
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_payload_axis_tready
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_payload_axis_tlast
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/tx_udp_payload_axis_tuser
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/local_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/dest_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/local_port
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/dest_port
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/cnt_1s
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/cnt
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/din_data_func
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/din_valid_func
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/din_last_func
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/apply_backpressure
add wave -noupdate -group tb -radix unsigned /tb_udp_tx_path/byte_count
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/sys_clk
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/din_data
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/din_valid
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/din_last
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_app_state
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_data_counter
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_bytes_to_send
add wave -noupdate /tb_udp_tx_path/dut/byte_count
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_data_buffer
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tdata
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tvalid
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tready
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tlast
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tvalid
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tdata
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tready
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tlast
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tuser
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_data_counter
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_byte_index
add wave -noupdate -radix unsigned /tb_udp_tx_path/dut/tx_bytes_to_send
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/sys_rst
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/din_ready
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/clk
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/rst
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_hdr_valid
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_hdr_ready
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_ip_dscp
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_ip_ecn
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_ip_ttl
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_ip_source_ip
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_ip_dest_ip
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_source_port
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_dest_port
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_length
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_checksum
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tvalid
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tdata
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tready
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tlast
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_udp_payload_axis_tuser
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/local_ip
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/dest_ip
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/local_port
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/dest_port
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tdata
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tvalid
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tready
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_axis_tlast
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_start
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_payload_len
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_payload_len_reg
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_fifo_out_payload_axis_tdata
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_fifo_out_payload_axis_tvalid
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_fifo_out_payload_axis_tready
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_fifo_out_payload_axis_tlast
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_fifo_out_payload_axis_tuser
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_byte_cnt
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_data_collecting
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_data_complete
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_app_state
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_data_counter
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_bytes_to_send
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_data_buffer
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_byte_index
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_start_sync1
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_start_sync2
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/s_app_tx_start_sync3
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_start_pulse
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_state_reg
add wave -noupdate -expand -group udp_tx_path -radix unsigned /tb_udp_tx_path/dut/tx_payload_len_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 440
configure wave -valuecolwidth 64
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3455 ns} {5010 ns}

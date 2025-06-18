onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tb
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/sys_clk
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/sys_rst
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/dout_data
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/dout_valid
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/dout_last
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/dout_ready
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/clk
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rst
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_hdr_valid
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_eth_dest_mac
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_eth_src_mac
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_eth_type
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_version
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_ihl
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_dscp
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_ecn
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_length
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_identification
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_flags
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_fragment_offset
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_ttl
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_protocol
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_header_checksum
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_source_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_ip_dest_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_source_port
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_dest_port
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_length
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_checksum
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_payload_axis_tdata
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_payload_axis_tvalid
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_payload_axis_tready
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_payload_axis_tlast
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_payload_axis_tuser
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_udp_hdr_ready
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/m_app_rx_src_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/m_app_rx_src_port
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/m_app_rx_valid
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/local_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/dest_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/local_port
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/dest_port
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/error_count
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/packet_received_count
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/rx_packet_done
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/apply_backpressure
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/expected_payload_len
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/expected_src_ip
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/expected_src_port
add wave -noupdate -group tb -radix unsigned /tb_udp_rx_path/byte_write_ptr
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/sys_clk
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/sys_rst
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/dout_data
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/dout_valid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/dout_last
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/dout_ready
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/clk
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rst
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_hdr_ready
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_hdr_valid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_eth_dest_mac
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_eth_src_mac
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_eth_type
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_version
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_ihl
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_dscp
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_ecn
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_length
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_identification
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_flags
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_fragment_offset
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_ttl
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_protocol
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_header_checksum
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_source_ip
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_ip_dest_ip
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_source_port
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_dest_port
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_length
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_checksum
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_payload_axis_tdata
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_payload_axis_tvalid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_payload_axis_tready
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_payload_axis_tlast
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_udp_payload_axis_tuser
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/m_app_rx_src_ip
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/m_app_rx_src_port
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/m_app_rx_valid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/local_ip
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/dest_ip
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/local_port
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/dest_port
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/m_app_rx_axis_tdata
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/m_app_rx_axis_tvalid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/m_app_rx_axis_tready
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/m_app_rx_axis_tlast
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_in_payload_axis_tdata
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_in_payload_axis_tvalid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_in_payload_axis_tlast
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_in_payload_axis_tuser
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_out_payload_axis_tdata
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_out_payload_axis_tvalid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_out_payload_axis_tready
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_fifo_out_payload_axis_tlast
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_meta_fifo_in_tdata
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_meta_fifo_in_tvalid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_meta_fifo_out_tdata
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_meta_fifo_out_tvalid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_drop_packet_reg
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_data_buffer
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_byte_index
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_app_state
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_meta_fifo_out_tready
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_output_valid
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/rx_output_last
add wave -noupdate -group udp_rx_path -radix unsigned /tb_udp_rx_path/dut/bytes_per_word
add wave -noupdate -group udp_rx_path -color {Medium Orchid} /tb_udp_rx_path/rx_udp_hdr_valid
add wave -noupdate -group udp_rx_path -color {Medium Orchid} -radix unsigned /tb_udp_rx_path/dut/rx_packet_active_reg
add wave -noupdate -group udp_rx_path -color {Medium Orchid} -radix unsigned /tb_udp_rx_path/dut/packet_match
add wave -noupdate -group udp_rx_path -color {Medium Orchid} -radix unsigned /tb_udp_rx_path/dut/rx_meta_fifo_in_tready
add wave -noupdate -group udp_rx_path -color {Medium Orchid} -radix unsigned /tb_udp_rx_path/dut/rx_fifo_in_payload_axis_tready
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_clk
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_rst
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tdata
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tkeep
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tvalid
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tready
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tlast
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tid
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tdest
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis_tuser
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_clk
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_rst
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tdata
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tkeep
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tvalid
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tready
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tlast
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tid
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tdest
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tuser
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_pause_req
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_pause_ack
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_pause_req
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_pause_ack
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_status_depth
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_status_depth_commit
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_status_overflow
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_status_bad_frame
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_status_good_frame
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_status_depth
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_status_depth_commit
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_status_overflow
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_status_bad_frame
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_status_good_frame
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_commit_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_gray_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_sync_commit_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/rd_ptr_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/rd_ptr_gray_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_conv_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/rd_ptr_conv_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_temp
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/rd_ptr_temp
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_gray_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_gray_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_commit_sync_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/rd_ptr_gray_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/rd_ptr_gray_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_update_valid_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_update_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_update_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_update_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_update_sync3_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_update_ack_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/wr_ptr_update_ack_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_rst_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_rst_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_rst_sync3_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_rst_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_rst_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_rst_sync3_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/mem_read_data_valid_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tvalid_pipe_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/full
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/empty
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/full_wr
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/write
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/read
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/store_output
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/drop_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/mark_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/send_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/overflow_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/bad_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/good_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_drop_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_terminate_frame_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_depth_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_depth_commit_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_depth_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_depth_commit_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/overflow_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/overflow_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/overflow_sync3_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/overflow_sync4_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/bad_frame_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/bad_frame_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/bad_frame_sync3_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/bad_frame_sync4_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/good_frame_sync1_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/good_frame_sync2_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/good_frame_sync3_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/good_frame_sync4_reg
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/s_axis
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tready_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tvalid_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tdata_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tkeep_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tlast_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tid_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tdest_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tuser_pipe
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tready_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tvalid_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tdata_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tkeep_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tlast_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tid_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tdest_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/m_axis_tuser_out
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/pipe_ready
add wave -noupdate -expand -group meta /tb_udp_rx_path/dut/rx_payload_fifo/j
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 453
configure wave -valuecolwidth 100
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
WaveRestoreZoom {8 ns} {129 ns}

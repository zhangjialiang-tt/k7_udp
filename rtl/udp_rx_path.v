/*

Copyright (c) 2023 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall `timescale 1ns / 1ps `default_nettype none

/*
 * UDP Receive Path
 */
module udp_rx_path #(
    parameter DATA_W = 64  // 应用层数据位宽
) (
    // System/Application Clock Domain
    input wire sys_clk,
    input wire sys_rst,

    // Application Interface (sys_clk domain)
    (*mark_debug = "true"*)output wire [DATA_W-1:0] dout_data,
    (*mark_debug = "true"*)output wire              dout_valid,
    (*mark_debug = "true"*)output wire              dout_last,
    input  wire              dout_ready,

    // Core Clock Domain
    input wire clk,
    input wire rst,

    // UDP Core Interface (clk domain)
    output wire        rx_udp_hdr_ready,
    input  wire        rx_udp_hdr_valid,
    input  wire [47:0] rx_udp_eth_dest_mac,
    input  wire [47:0] rx_udp_eth_src_mac,
    input  wire [15:0] rx_udp_eth_type,
    input  wire [ 3:0] rx_udp_ip_version,
    input  wire [ 3:0] rx_udp_ip_ihl,
    input  wire [ 5:0] rx_udp_ip_dscp,
    input  wire [ 1:0] rx_udp_ip_ecn,
    input  wire [15:0] rx_udp_ip_length,
    input  wire [15:0] rx_udp_ip_identification,
    input  wire [ 2:0] rx_udp_ip_flags,
    input  wire [12:0] rx_udp_ip_fragment_offset,
    input  wire [ 7:0] rx_udp_ip_ttl,
    input  wire [ 7:0] rx_udp_ip_protocol,
    input  wire [15:0] rx_udp_ip_header_checksum,
    input  wire [31:0] rx_udp_ip_source_ip,
    input  wire [31:0] rx_udp_ip_dest_ip,
    input  wire [15:0] rx_udp_source_port,
    input  wire [15:0] rx_udp_dest_port,
    input  wire [15:0] rx_udp_length,
    input  wire [15:0] rx_udp_checksum,
    input  wire [ 7:0] rx_udp_payload_axis_tdata,
    input  wire        rx_udp_payload_axis_tvalid,
    output wire        rx_udp_payload_axis_tready,
    input  wire        rx_udp_payload_axis_tlast,
    input  wire        rx_udp_payload_axis_tuser,

    // Metadata output (sys_clk domain)
    output wire [31:0] m_app_rx_src_ip,
    output wire [15:0] m_app_rx_src_port,
    output wire        m_app_rx_valid,

    // Configuration
    input wire [31:0] local_ip,
    input wire [31:0] dest_ip,
    input wire [15:0] local_port,
    input wire [15:0] dest_port
);

    // Internal AXI stream signals for RX path
    wire [ 7:0] m_app_rx_axis_tdata;
    wire        m_app_rx_axis_tvalid;
    wire        m_app_rx_axis_tready;
    wire        m_app_rx_axis_tlast;

    // RX path FIFOs (Core -> App)
    wire [ 7:0] rx_fifo_in_payload_axis_tdata;
    wire        rx_fifo_in_payload_axis_tvalid;
    wire        rx_fifo_in_payload_axis_tready;
    wire        rx_fifo_in_payload_axis_tlast;
    wire        rx_fifo_in_payload_axis_tuser;
    wire [ 7:0] rx_fifo_out_payload_axis_tdata;
    wire        rx_fifo_out_payload_axis_tvalid;
    wire        rx_fifo_out_payload_axis_tready;
    wire        rx_fifo_out_payload_axis_tlast;

    // Metadata FIFO signals
    wire [47:0] rx_meta_fifo_in_tdata;
    wire        rx_meta_fifo_in_tvalid;
    wire        rx_meta_fifo_in_tready;
    wire [47:0] rx_meta_fifo_out_tdata;
    wire        rx_meta_fifo_out_tvalid;
    wire        rx_meta_fifo_out_tready;

    // ----------------------------------------------------------------
    // Receive Path Control Logic
    // ----------------------------------------------------------------

    // Filter incoming packets by destination port, source IP and source port
    wire        packet_match = (rx_udp_dest_port == local_port) && (rx_udp_ip_source_ip == dest_ip) && (rx_udp_source_port == dest_port);
    reg         rx_drop_packet_reg = 1'b0;
    reg         rx_packet_active_reg = 1'b0;

    // Control logic in core clock domain (clk)
    always @(posedge clk) begin
        if (rst) begin
            rx_drop_packet_reg   <= 1'b0;
            rx_packet_active_reg <= 1'b0;
        end else begin
            if (rx_udp_hdr_valid && !rx_packet_active_reg) begin
                // New packet header arrived
                if (packet_match && rx_meta_fifo_in_tready && rx_fifo_in_payload_axis_tready) begin
                    // Packet matches and FIFOs are ready, accept the packet
                    rx_packet_active_reg <= 1'b1;
                    rx_drop_packet_reg   <= 1'b0;
                end else begin
                    // Drop the packet (does not match or FIFO full)
                    rx_packet_active_reg <= 1'b1;
                    rx_drop_packet_reg   <= 1'b1;
                end
            end else if (rx_packet_active_reg && rx_udp_payload_axis_tvalid && rx_udp_payload_axis_tready && rx_udp_payload_axis_tlast) begin
                // End of packet
                rx_packet_active_reg <= 1'b0;
                rx_drop_packet_reg   <= 1'b0;
            end
        end
    end

    assign rx_udp_hdr_ready = rx_udp_hdr_valid && !rx_packet_active_reg && packet_match && rx_meta_fifo_in_tready && rx_fifo_in_payload_axis_tready;

    // Connect UDP payload to Rx payload FIFO
    assign rx_fifo_in_payload_axis_tdata = rx_udp_payload_axis_tdata;
    assign rx_fifo_in_payload_axis_tvalid = rx_udp_payload_axis_tvalid && rx_packet_active_reg && !rx_drop_packet_reg;
    assign rx_udp_payload_axis_tready = (!rx_packet_active_reg || rx_drop_packet_reg) ? 1'b1 : rx_fifo_in_payload_axis_tready;
    assign rx_fifo_in_payload_axis_tlast = rx_udp_payload_axis_tlast;
    assign rx_fifo_in_payload_axis_tuser = rx_udp_payload_axis_tuser;

    // Connect metadata to Rx metadata FIFO
    assign rx_meta_fifo_in_tdata = {rx_udp_ip_source_ip, rx_udp_source_port};
    assign rx_meta_fifo_in_tvalid = rx_udp_hdr_ready;

    // Connect Rx FIFOs outputs to application interface
    assign m_app_rx_axis_tdata = rx_fifo_out_payload_axis_tdata;
    assign m_app_rx_axis_tvalid = rx_fifo_out_payload_axis_tvalid;
    assign rx_fifo_out_payload_axis_tready = m_app_rx_axis_tready;
    assign m_app_rx_axis_tlast = rx_fifo_out_payload_axis_tlast;

    // Metadata is valid when payload is valid. Read metadata at the end of the packet.
    assign {m_app_rx_src_ip, m_app_rx_src_port} = rx_meta_fifo_out_tdata;
    assign m_app_rx_valid = rx_meta_fifo_out_tvalid;
    assign rx_meta_fifo_out_tready = m_app_rx_axis_tready && m_app_rx_axis_tvalid && m_app_rx_axis_tlast;

    // ----------------------------------------------------------------
    // RX 路径: internal AXI-Stream -> dout_*
    // ----------------------------------------------------------------

    reg [DATA_W-1:0] rx_data_buffer;
    reg [       3:0] rx_byte_index;

    // dout接口控制
    assign dout_data = rx_data_buffer;

    // 接收状态机
    localparam RX_APP_IDLE = 2'd0, RX_APP_COLLECT = 2'd1, RX_APP_OUTPUT = 2'd2;

    reg [1:0] rx_app_state;
    reg       rx_output_valid;
    reg       rx_output_last;

    assign dout_valid = rx_output_valid;
    assign dout_last = rx_output_last;
    assign m_app_rx_axis_tready = (rx_app_state == RX_APP_COLLECT);

    // 计算总字节数 - 这依赖于DATA_W的位宽
    wire [15:0] bytes_per_word = DATA_W / 8;

    always @(posedge sys_clk) begin
        if (sys_rst) begin
            rx_app_state <= RX_APP_IDLE;
            rx_byte_index <= 4'd0;
            rx_output_valid <= 1'b0;
            rx_output_last <= 1'b0;
        end else begin
            // 默认清除输出有效标志
            rx_output_valid <= 1'b0;

            case (rx_app_state)
                RX_APP_IDLE: begin
                    // 检测有新数据到达
                    if (m_app_rx_axis_tvalid) begin
                        rx_app_state  <= RX_APP_COLLECT;
                        rx_byte_index <= 4'd0;
                    end
                end

                RX_APP_COLLECT: begin
                    if (m_app_rx_axis_tvalid && m_app_rx_axis_tready) begin
                        // 收集字节数据
                        rx_data_buffer[8*rx_byte_index+:8] <= m_app_rx_axis_tdata;

                        // 移动到下一个字节
                        if (rx_byte_index == bytes_per_word - 1 || m_app_rx_axis_tlast) begin
                            rx_byte_index <= 4'd0;
                            rx_output_valid <= 1'b1;
                            rx_output_last <= m_app_rx_axis_tlast;
                            rx_app_state <= RX_APP_OUTPUT;
                        end else begin
                            rx_byte_index <= rx_byte_index + 1;
                        end
                    end
                end

                RX_APP_OUTPUT: begin
                    // 等待应用层接收完成
                    if (dout_ready) begin
                        if (rx_output_last) begin
                            rx_app_state <= RX_APP_IDLE;
                        end else begin
                            rx_app_state <= RX_APP_COLLECT;
                        end
                        rx_output_valid <= 1'b0;
                    end else begin
                        // 保持输出有效直到被接收
                        rx_output_valid <= 1'b1;
                    end
                end
            endcase
        end
    end

    // ----------------------------------------------------------------
    // FIFOs
    // ----------------------------------------------------------------

    // RX Payload FIFO: Core (clk) -> App (sys_clk)
    axis_async_fifo #(
        .DEPTH(8192),
        .DATA_WIDTH(8),
        .KEEP_ENABLE(0),
        .LAST_ENABLE(1),
        .ID_ENABLE(0),
        .DEST_ENABLE(0),
        .USER_ENABLE(1),
        .FRAME_FIFO(1)
    ) rx_payload_fifo (
        .s_clk                (clk),
        .s_rst                (rst),
        .s_axis_tdata         (rx_fifo_in_payload_axis_tdata),
        .s_axis_tkeep         (1'b1),
        .s_axis_tvalid        (rx_fifo_in_payload_axis_tvalid),
        .s_axis_tready        (rx_fifo_in_payload_axis_tready),
        .s_axis_tlast         (rx_fifo_in_payload_axis_tlast),
        .s_axis_tid           (0),
        .s_axis_tdest         (0),
        .s_axis_tuser         (rx_fifo_in_payload_axis_tuser),
        .m_clk                (sys_clk),
        .m_rst                (sys_rst),
        .m_axis_tdata         (rx_fifo_out_payload_axis_tdata),
        .m_axis_tkeep         (),
        .m_axis_tvalid        (rx_fifo_out_payload_axis_tvalid),
        .m_axis_tready        (rx_fifo_out_payload_axis_tready),
        .m_axis_tlast         (rx_fifo_out_payload_axis_tlast),
        .m_axis_tid           (),
        .m_axis_tdest         (),
        .m_axis_tuser         (),
        .s_status_depth       (),
        .s_status_depth_commit(),
        .s_status_overflow    (),
        .s_status_bad_frame   (),
        .s_status_good_frame  (),
        .m_status_depth       (),
        .m_status_depth_commit(),
        .m_status_overflow    (),
        .m_status_bad_frame   (),
        .m_status_good_frame  ()
    );

    // RX Metadata FIFO: Core (clk) -> App (sys_clk)
    axis_async_fifo #(
        .DEPTH(16),
        .DATA_WIDTH(48),  // 32-bit IP + 16-bit port
        .KEEP_ENABLE(0),
        .LAST_ENABLE(0),
        .ID_ENABLE(0),
        .DEST_ENABLE(0),
        .USER_ENABLE(0),
        .FRAME_FIFO(0)
    ) rx_metadata_fifo (
        .s_clk                (clk),
        .s_rst                (rst),
        .s_axis_tdata         (rx_meta_fifo_in_tdata),
        .s_axis_tkeep         (1'b1),
        .s_axis_tvalid        (rx_meta_fifo_in_tvalid),
        .s_axis_tready        (rx_meta_fifo_in_tready),
        .s_axis_tlast         (1'b1),
        .s_axis_tid           (0),
        .s_axis_tdest         (0),
        .s_axis_tuser         (0),
        .m_clk                (sys_clk),
        .m_rst                (sys_rst),
        .m_axis_tdata         (rx_meta_fifo_out_tdata),
        .m_axis_tkeep         (),
        .m_axis_tvalid        (rx_meta_fifo_out_tvalid),
        .m_axis_tready        (rx_meta_fifo_out_tready),
        .m_axis_tlast         (),
        .m_axis_tid           (),
        .m_axis_tdest         (),
        .m_axis_tuser         (),
        .s_status_depth       (),
        .s_status_depth_commit(),
        .s_status_overflow    (),
        .s_status_bad_frame   (),
        .s_status_good_frame  (),
        .m_status_depth       (),
        .m_status_depth_commit(),
        .m_status_overflow    (),
        .m_status_bad_frame   (),
        .m_status_good_frame  ()
    );

endmodule

`resetall

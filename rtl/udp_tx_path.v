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
 * UDP Transmit Path
 */
module udp_tx_path #(
    parameter DATA_W = 64  // 应用层数据位宽
) (
    // System/Application Clock Domain
                             input  wire              sys_clk,
                             input  wire              sys_rst,
    // Application Interface (sys_clk domain)
    (*mark_debug = "false"*) input  wire [DATA_W-1:0] din_data,
    (*mark_debug = "false"*) input  wire              din_valid,
    (*mark_debug = "false"*) input  wire              din_last,
    (*mark_debug = "false"*) output wire              din_ready,
    // Core Clock Domain
                            input  wire              clk,
                            input  wire              rst,
    // UDP Core Interface (clk domain)
    (*mark_debug = "false"*) output wire              tx_udp_hdr_valid,
    (*mark_debug = "false"*) input  wire              tx_udp_hdr_ready,
                            output wire [       5:0] tx_udp_ip_dscp,
                            output wire [       1:0] tx_udp_ip_ecn,
                            output wire [       7:0] tx_udp_ip_ttl,
                            output wire [      31:0] tx_udp_ip_source_ip,
                            output wire [      31:0] tx_udp_ip_dest_ip,
                            output wire [      15:0] tx_udp_source_port,
                            output wire [      15:0] tx_udp_dest_port,
                            output wire [      15:0] tx_udp_length,
                            output wire [      15:0] tx_udp_checksum,
    (*mark_debug = "false"*) output wire [       7:0] tx_udp_payload_axis_tdata,
    (*mark_debug = "false"*) output wire              tx_udp_payload_axis_tvalid,
    (*mark_debug = "false"*) input  wire              tx_udp_payload_axis_tready,
    (*mark_debug = "false"*) output wire              tx_udp_payload_axis_tlast,
    (*mark_debug = "false"*) output wire              tx_udp_payload_axis_tuser,

    // Configuration
    input wire [31:0] local_ip,
    input wire [31:0] dest_ip,
    input wire [15:0] local_port,
    input wire [15:0] dest_port
);

    // 将宽数据拆分为字节流的状态机
    localparam TX_APP_IDLE = 3'd0;
    localparam TX_APP_COUNT = 3'd1;
    localparam TX_APP_DATA = 3'd2;
    localparam TX_APP_FINISH = 3'd3;

    // 计算总字节数 - 这依赖于DATA_W的位宽
    // (*mark_debug = "false"*)wire [15:0] bytes_per_word = DATA_W / 8;
    localparam BYTE_PER_WORD = DATA_W / 8;
    // Internal AXI stream signals for TX path
    (*mark_debug = "false"*)wire [               7:0] s_app_tx_axis_tdata;
    (*mark_debug = "false"*)wire                      s_app_tx_axis_tvalid;
    (*mark_debug = "false"*)wire                      s_app_tx_axis_tready;
    (*mark_debug = "false"*)wire                      s_app_tx_axis_tlast;
    (*mark_debug = "false"*)wire                      s_app_tx_start;
    (*mark_debug = "false"*)wire                      s_app_tx_start_expand;
    (*mark_debug = "false"*)wire                      s_app_tx_start_pulse;
    (*mark_debug = "false"*)reg  [              15:0] s_app_tx_payload_len;
    (*mark_debug = "false"*)wire [              15:0] s_app_tx_payload_len_reg;

    // TX path FIFO (App -> Core)
    (*mark_debug = "false"*)wire [               7:0] tx_fifo_out_payload_axis_tdata;
    (*mark_debug = "false"*)wire                      tx_fifo_out_payload_axis_tvalid;
    (*mark_debug = "false"*)wire                      tx_fifo_out_payload_axis_tready;
    (*mark_debug = "false"*)wire                      tx_fifo_out_payload_axis_tlast;
    (*mark_debug = "false"*)wire                      tx_fifo_out_payload_axis_tuser;

    // ----------------------------------------------------------------
    // TX 路径: din_* -> internal AXI-Stream
    // ----------------------------------------------------------------
    (*mark_debug = "false"*)reg  [               2:0] tx_app_state;
    (*mark_debug = "false"*)reg  [              15:0] tx_data_counter;  // 最多支持64K个字节
    (*mark_debug = "false"*)reg  [              15:0] tx_bytes_to_send;  // 总共要发送的字节数
    (*mark_debug = "false"*)reg  [        DATA_W-1:0] tx_data_buffer;
    (*mark_debug = "false"*)reg  [               3:0] tx_byte_index;  // 最多支持128位数据宽度
    (*mark_debug = "false"*)reg  [$clog2(DATA_W/8):0] byte_count;
    //**********************************************************************************************
    //应用层->fifo
    //时钟域:sys_clk
    //**********************************************************************************************
    // 应用层状态机（sys_clk域）
    always @(posedge sys_clk) begin
        if (sys_rst) begin
            tx_app_state <= TX_APP_IDLE;
            tx_data_counter <= 16'd0;
            tx_bytes_to_send <= 16'd0;
            tx_byte_index <= 4'd0;
            s_app_tx_payload_len <= 16'd0;
            byte_count <= BYTE_PER_WORD;
        end else begin
            case (tx_app_state)
                TX_APP_IDLE: begin
                    if (din_valid) byte_count <= 0;
                    else if (byte_count == BYTE_PER_WORD) byte_count <= byte_count;
                    else byte_count <= byte_count + 1;

                    if (din_valid) begin
                        tx_data_buffer <= din_data;
                        tx_app_state <= TX_APP_COUNT;
                        tx_bytes_to_send <= BYTE_PER_WORD;
                        tx_data_counter <= BYTE_PER_WORD;
                        tx_byte_index <= 4'd0;
                        if (din_last) begin
                            // 只有一个字，直接计算长度
                            tx_app_state <= TX_APP_DATA;
                        end
                    end
                end
                TX_APP_COUNT: begin
                    // 收集更多数据，等待din_last
                    // 将DATA_W的数据拆分为BYTE_PER_WORD个字节
                    if (din_valid) byte_count <= 0;
                    else if (byte_count == BYTE_PER_WORD) byte_count <= byte_count;
                    else byte_count <= byte_count + 1;

                    if (din_valid) begin
                        tx_data_buffer  <= din_data;
                        tx_data_counter <= tx_data_counter + BYTE_PER_WORD;
                        if (din_last) begin
                            tx_bytes_to_send <= tx_data_counter + BYTE_PER_WORD;
                            tx_data_counter <= 16'd0;
                            tx_byte_index <= 4'd0;
                            tx_app_state <= TX_APP_DATA;
                        end
                    end
                end
                TX_APP_DATA: begin
                    if (din_valid) byte_count <= 0;
                    else if (byte_count == BYTE_PER_WORD) byte_count <= byte_count;
                    else byte_count <= byte_count + 1;

                    if (s_app_tx_axis_tlast) begin
                        tx_app_state <= TX_APP_FINISH;
                        s_app_tx_payload_len <= tx_bytes_to_send;
                    end
                end
                TX_APP_FINISH: begin
                    // 发送完成，等待下一次传输
                    tx_app_state <= TX_APP_IDLE;
                end
            endcase
        end
    end
    // din接口控制
    assign din_ready            = (tx_app_state == TX_APP_IDLE);

    // 内部AXI-Stream接口控制
    assign s_app_tx_axis_tvalid = byte_count < BYTE_PER_WORD;
    // assign s_app_tx_axis_tdata  = tx_data_buffer[8*byte_count+:8];
    assign s_app_tx_axis_tdata  = tx_data_buffer[8*(BYTE_PER_WORD-byte_count)-1-:8];
    assign s_app_tx_axis_tlast  = (tx_app_state == TX_APP_DATA) && (byte_count == BYTE_PER_WORD - 1);
    assign s_app_tx_start       = (tx_app_state == TX_APP_FINISH);

    bit_expand #(
        .EXPAND_LEN(5)
    ) bit_expand_inst (
        .i_Sys_clk(sys_clk),
        .i_Rst_n  (~sys_rst),
        .i_Din    (s_app_tx_start),
        .o_Dout   (s_app_tx_start_expand)
    );

    //**********************************************************************************************
    // TX 控制同步与状态机 (core clk domain)
    //**********************************************************************************************

    // TX control FSM (clk domain)
    localparam TX_IDLE = 2'd0;
    localparam TX_SEND_HEADER = 2'd1;
    localparam TX_SEND_PAYLOAD = 2'd2;
    localparam TX_SEND_NOP = 2'd3;
    (*mark_debug = "false"*)reg  [ 1:0] tx_state_reg = TX_IDLE;
    (*mark_debug = "false"*)reg  [15:0] tx_payload_len_reg;
    // TX 控制同步 (sys_clk -> clk)
    (*mark_debug = "false"*)reg  [15:0] s_app_tx_payload_len_sync1 = 0;
    (*mark_debug = "false"*)reg  [15:0] s_app_tx_payload_len_sync2 = 0;
    (*mark_debug = "false"*)reg  [15:0] s_app_tx_payload_len_sync3 = 0;
    (*mark_debug = "false"*)wire        tx_start_pulse;

    // 同步负载长度
    //! 跨时钟域处理 sysclock->phyclock
    capture_edge #(
        .EDGE("falling")
    ) interrupt_capture_edge (
        .i_Sys_clk  (clk),
        .i_Rst_n    (~rst),
        .i_Din_valid(s_app_tx_start_expand),
        .o_Dout_edge(s_app_tx_start_pulse)
    );
    always @(posedge clk) begin
        if (rst) begin
            s_app_tx_payload_len_sync1 <= 16'd0;
            s_app_tx_payload_len_sync2 <= 16'd0;
            s_app_tx_payload_len_sync3 <= 16'd0;
        // end else if (s_app_tx_start_pulse) begin
        end else begin
            s_app_tx_payload_len_sync1 <= s_app_tx_payload_len;
            s_app_tx_payload_len_sync2 <= s_app_tx_payload_len_sync1;
            s_app_tx_payload_len_sync3 <= s_app_tx_payload_len_sync2;
        end
    end
    assign tx_start_pulse = s_app_tx_start_pulse;
    assign s_app_tx_payload_len_reg = s_app_tx_payload_len_sync3;


    always @(posedge clk) begin
        if (rst) begin
            tx_state_reg <= TX_IDLE;
        end else begin
            case (tx_state_reg)
                TX_IDLE: begin
                    if (tx_start_pulse) begin
                        tx_payload_len_reg <= s_app_tx_payload_len_reg;
                        tx_state_reg <= TX_SEND_HEADER;
                    end
                end
                TX_SEND_HEADER: begin
                    if (tx_udp_hdr_valid && tx_udp_hdr_ready) begin
                        tx_state_reg <= TX_SEND_PAYLOAD;
                    end
                end
                TX_SEND_PAYLOAD: begin
                    if (tx_udp_payload_axis_tvalid && tx_udp_payload_axis_tready && tx_udp_payload_axis_tlast) begin
                        tx_state_reg <= TX_SEND_NOP;
                    end
                end
                TX_SEND_NOP: begin
                    tx_state_reg <= TX_IDLE;
                end
            endcase
        end
    end

    // UDP TX Header
    assign tx_udp_hdr_valid = (tx_state_reg == TX_SEND_HEADER);
    assign tx_udp_ip_dscp = 0;
    assign tx_udp_ip_ecn = 0;
    assign tx_udp_ip_ttl = 64;
    assign tx_udp_ip_source_ip = local_ip;
    assign tx_udp_ip_dest_ip = dest_ip;
    assign tx_udp_source_port = local_port;
    assign tx_udp_dest_port = dest_port;
    assign tx_udp_length = tx_payload_len_reg + 8;  // UDP length = payload length + UDP header length
    assign tx_udp_checksum = 0;  // udp_complete will calculate it

    // UDP Payload
    assign tx_udp_payload_axis_tdata = tx_fifo_out_payload_axis_tdata;
    assign tx_udp_payload_axis_tvalid = (tx_state_reg == TX_SEND_PAYLOAD) && tx_fifo_out_payload_axis_tvalid;
    assign tx_fifo_out_payload_axis_tready = tx_udp_payload_axis_tready && (tx_state_reg == TX_SEND_PAYLOAD);
    assign tx_udp_payload_axis_tlast = tx_fifo_out_payload_axis_tlast;
    assign tx_udp_payload_axis_tuser = tx_fifo_out_payload_axis_tuser;

    // ----------------------------------------------------------------
    // TX Payload FIFO: App (sys_clk) -> Core (clk)
    // ----------------------------------------------------------------
    axis_async_fifo #(
        .DEPTH(8192),
        .DATA_WIDTH(8),
        .KEEP_ENABLE(0),
        .LAST_ENABLE(1),
        .ID_ENABLE(0),
        .DEST_ENABLE(0),
        .USER_ENABLE(1),
        .FRAME_FIFO(1)
    ) tx_payload_fifo (
        .s_clk                (sys_clk),
        .s_rst                (sys_rst),
        .s_axis_tdata         (s_app_tx_axis_tdata),
        .s_axis_tkeep         (1'b1),
        .s_axis_tvalid        (s_app_tx_axis_tvalid),
        .s_axis_tready        (s_app_tx_axis_tready),
        .s_axis_tlast         (s_app_tx_axis_tlast),
        .s_axis_tid           (0),
        .s_axis_tdest         (0),
        .s_axis_tuser         (0),
        .m_clk                (clk),
        .m_rst                (rst),
        .m_axis_tdata         (tx_fifo_out_payload_axis_tdata),
        .m_axis_tkeep         (),
        .m_axis_tvalid        (tx_fifo_out_payload_axis_tvalid),
        .m_axis_tready        (tx_fifo_out_payload_axis_tready),
        .m_axis_tlast         (tx_fifo_out_payload_axis_tlast),
        .m_axis_tid           (),
        .m_axis_tdest         (),
        .m_axis_tuser         (tx_fifo_out_payload_axis_tuser),
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

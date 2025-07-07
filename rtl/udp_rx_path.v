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
                            input  wire              sys_clk,
                            input  wire              sys_rst,
    // Application Interface (sys_clk domain)
    (*mark_debug = "false"*) output wire [DATA_W-1:0] dout_data,
    (*mark_debug = "false"*) output wire              dout_valid,
    (*mark_debug = "false"*) output wire              dout_last,
                            input  wire              dout_ready,
    // Core Clock Domain
                            input  wire              clk,
                            input  wire              rst,
    // UDP Core Interface (clk domain)
    (*mark_debug = "false"*) output wire              rx_udp_hdr_ready,
    (*mark_debug = "false"*) input  wire              rx_udp_hdr_valid,
    (*mark_debug = "false"*) input  wire [      31:0] rx_udp_ip_source_ip,
    (*mark_debug = "false"*) input  wire [      31:0] rx_udp_ip_dest_ip,
    (*mark_debug = "false"*) input  wire [      15:0] rx_udp_source_port,
    (*mark_debug = "false"*) input  wire [      15:0] rx_udp_dest_port,
    (*mark_debug = "false"*) input  wire [       7:0] rx_udp_payload_axis_tdata,
    (*mark_debug = "false"*) input  wire              rx_udp_payload_axis_tvalid,
    (*mark_debug = "false"*) output wire              rx_udp_payload_axis_tready,
    (*mark_debug = "false"*) input  wire              rx_udp_payload_axis_tlast,
    (*mark_debug = "false"*) input  wire              rx_udp_payload_axis_tuser,
    // Metadata output (sys_clk domain)
    // (*mark_debug = "false"*) output wire [      31:0] m_app_rx_src_ip,
    // (*mark_debug = "false"*) output wire [      15:0] m_app_rx_src_port,
    // (*mark_debug = "false"*) output wire              m_app_rx_valid,
    // Configuration
    (*mark_debug = "false"*) input  wire [      31:0] local_ip,
    (*mark_debug = "false"*) input  wire [      31:0] dest_ip,
    (*mark_debug = "false"*) input  wire [      15:0] local_port,
    (*mark_debug = "false"*) input  wire [      15:0] dest_port
);
    // Application-side state machine
    localparam RX_APP_IDLE = 2'd0;
    localparam RX_APP_PREP = 2'd1;
    localparam RX_APP_COLLECT = 2'd2;
    localparam RX_APP_OUTPUT = 2'd3;
    localparam BYTES_PER_WORD = DATA_W / 8;

    // Internal AXI stream signals for RX path
    (*mark_debug = "false"*)wire [       7:0] m_app_rx_axis_tdata;
    (*mark_debug = "false"*)wire              m_app_rx_axis_tvalid;
    (*mark_debug = "false"*)wire              m_app_rx_axis_tready;
    (*mark_debug = "false"*)wire              m_app_rx_axis_tlast;

    // RX path FIFOs (Core -> App)
    (*mark_debug = "false"*)wire [       7:0] rx_fifo_in_payload_axis_tdata;
    (*mark_debug = "false"*)wire              rx_fifo_in_payload_axis_tvalid;
    (*mark_debug = "false"*)wire              rx_fifo_in_payload_axis_tready;
    (*mark_debug = "false"*)wire              rx_fifo_in_payload_axis_tlast;
    (*mark_debug = "false"*)wire              rx_fifo_in_payload_axis_tuser;
    (*mark_debug = "false"*)wire [       7:0] rx_fifo_out_payload_axis_tdata;
    (*mark_debug = "false"*)wire              rx_fifo_out_payload_axis_tvalid;
    (*mark_debug = "false"*)wire              rx_fifo_out_payload_axis_tready;
    (*mark_debug = "false"*)wire              rx_fifo_out_payload_axis_tlast;

    (*mark_debug = "false"*)wire              packet_match;
    (*mark_debug = "false"*)reg               rx_drop_packet_reg;
    (*mark_debug = "false"*)reg               rx_packet_active_reg;
    (*mark_debug = "false"*)reg  [DATA_W-1:0] rx_data_buffer;
    (*mark_debug = "false"*)reg  [       3:0] rx_byte_index;
    (*mark_debug = "false"*)reg  [       1:0] rx_app_state;
    (*mark_debug = "false"*)reg               rx_output_valid;
    (*mark_debug = "false"*)reg               rx_output_last;

    // ----------------------------------------------------------------
    // Receive Path Control Logic (clk domain)
    // ----------------------------------------------------------------
    // FIX: Added check for local IP address to correctly filter packets.
    // Filter incoming packets by destination IP/port and source IP/port.
    assign packet_match = (rx_udp_ip_dest_ip == local_ip) && (rx_udp_dest_port == local_port) && (rx_udp_ip_source_ip == dest_ip) && (rx_udp_source_port == dest_port);

    // Control logic in core clock domain (clk)
    always @(posedge clk) begin
        if (rst) begin
            rx_drop_packet_reg   <= 1'b0;
            rx_packet_active_reg <= 1'b0;
        end else begin
            // A new header has arrived (handshake between core and this module)
            if (rx_udp_hdr_valid && rx_udp_hdr_ready) begin
                // Check if packet should be accepted or dropped
                if (packet_match && rx_fifo_in_payload_axis_tready) begin
                    // Packet matches and FIFO is ready, accept the packet
                    rx_packet_active_reg <= 1'b1;
                    rx_drop_packet_reg   <= 1'b0;
                end else begin
                    // Drop the packet (mismatch, or FIFO not ready)
                    rx_packet_active_reg <= 1'b1;
                    rx_drop_packet_reg   <= 1'b1;
                end
                // A packet is being processed, check for end of packet
            end else if (rx_packet_active_reg && rx_udp_payload_axis_tvalid && rx_udp_payload_axis_tready && rx_udp_payload_axis_tlast) begin
                // End of packet transaction
                rx_packet_active_reg <= 1'b0;
                rx_drop_packet_reg   <= 1'b0;
            end
        end
    end

    // FIX: Corrected hdr_ready logic to prevent deadlocks.
    // We are ready for a new header if we are not currently processing a packet.
    assign rx_udp_hdr_ready = !rx_packet_active_reg;

    // Connect UDP payload to Rx payload FIFO
    assign rx_fifo_in_payload_axis_tdata = rx_udp_payload_axis_tdata;
    assign rx_fifo_in_payload_axis_tvalid = rx_udp_payload_axis_tvalid && rx_packet_active_reg && !rx_drop_packet_reg;
    assign rx_fifo_in_payload_axis_tlast = rx_udp_payload_axis_tlast;
    assign rx_fifo_in_payload_axis_tuser = rx_udp_payload_axis_tuser;

    // FIX: Rewrote tready logic for clarity.
    // Be ready for payload if we are dropping the packet, or if we are accepting and the FIFO is ready.
    assign rx_udp_payload_axis_tready = (rx_packet_active_reg && !rx_drop_packet_reg) ? rx_fifo_in_payload_axis_tready : 1'b1;


    // Connect Rx FIFOs outputs to application interface logic
    assign m_app_rx_axis_tdata = rx_fifo_out_payload_axis_tdata;
    assign m_app_rx_axis_tvalid = rx_fifo_out_payload_axis_tvalid;
    assign m_app_rx_axis_tlast = rx_fifo_out_payload_axis_tlast;
    assign rx_fifo_out_payload_axis_tready = m_app_rx_axis_tready;

    // ----------------------------------------------------------------
    // RX Path: internal AXI-Stream -> dout_* (sys_clk domain)
    // ----------------------------------------------------------------
    assign dout_data = rx_data_buffer;
    assign dout_valid = rx_output_valid;
    assign dout_last = rx_output_last;
    // Pull data from the async FIFO only when in the COLLECT state.
    assign m_app_rx_axis_tready = (rx_app_state == RX_APP_COLLECT);

    // Application-side state machine
    always @(posedge sys_clk) begin
        if (sys_rst) begin
            rx_app_state    <= RX_APP_IDLE;
            rx_byte_index   <= 4'd0;
            rx_output_valid <= 1'b0;
            rx_output_last  <= 1'b0;
            rx_data_buffer  <= {DATA_W{1'b0}};
        end else begin
            case (rx_app_state)
                RX_APP_IDLE: begin
                    rx_output_last <= 0;
                    // Wait for data to arrive in FIFO
                    if (m_app_rx_axis_tvalid) begin
                        rx_app_state <= RX_APP_PREP;
                    end
                end

                RX_APP_PREP: begin
                    // Prepare for a new word: clear buffer and index
                    rx_data_buffer <= {DATA_W{1'b0}};
                    rx_byte_index  <= 4'd0;
                    rx_app_state   <= RX_APP_COLLECT;
                end

                RX_APP_COLLECT: begin
                    // Ready to accept bytes from FIFO
                    if (m_app_rx_axis_tvalid && m_app_rx_axis_tready) begin
                        // Collect one byte of data
                        rx_data_buffer[8*rx_byte_index+:8] <= m_app_rx_axis_tdata;

                        // If word is full or packet ends, move to output
                        if (rx_byte_index == BYTES_PER_WORD - 1 || m_app_rx_axis_tlast) begin
                            rx_output_valid <= 1'b1;
                            rx_output_last  <= m_app_rx_axis_tlast;
                            rx_app_state    <= RX_APP_OUTPUT;
                        end else begin
                            // Move to the next byte
                            rx_byte_index <= rx_byte_index + 1;
                        end
                    end
                end

                RX_APP_OUTPUT: begin
                    // Data is valid, wait for application to accept it
                    if (dout_ready) begin
                        // Application has taken the data, de-assert valid
                        rx_output_valid <= 1'b0;
                        if (rx_output_last) begin
                            rx_output_last <= 1'b0;
                            // End of packet, go back to idle
                            rx_app_state <= RX_APP_IDLE;
                        end else begin
                            // More data for this packet, prepare for next word
                            rx_app_state <= RX_APP_PREP;
                        end
                    end else begin
                        // Application not ready, hold data and valid signal
                        rx_output_valid <= 1'b1;
                        // rx_output_last is a register and will hold its value
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

endmodule

`resetall

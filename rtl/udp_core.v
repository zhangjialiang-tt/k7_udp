/*

Copyright (c) 2014-2023 Alex Forencich

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
 * UDP Core module - encapsulates Ethernet MAC, Ethernet framing, IP and UDP
 */
module udp_core #(
    parameter TARGET = "GENERIC"
) (
    // Core Clock Domain
    input wire clk,
    input wire clk90,
    input wire rst,

    // Ethernet: 1000BASE-T RGMII
    input  wire       phy_rx_clk,
    input  wire [3:0] phy_rxd,
    input  wire       phy_rx_ctl,
    output wire       phy_tx_clk,
    output wire [3:0] phy_txd,
    output wire       phy_tx_ctl,
    output wire       phy_reset_n,

    // UDP RX Interface (from network to application, clk domain)
    (*mark_debug = "false"*)output wire        rx_udp_hdr_valid,
    (*mark_debug = "false"*)input  wire        rx_udp_hdr_ready,
    (*mark_debug = "false"*)output wire [47:0] rx_udp_eth_dest_mac,
    (*mark_debug = "false"*)output wire [47:0] rx_udp_eth_src_mac,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_eth_type,
    (*mark_debug = "false"*)output wire [ 3:0] rx_udp_ip_version,
    (*mark_debug = "false"*)output wire [ 3:0] rx_udp_ip_ihl,
    (*mark_debug = "false"*)output wire [ 5:0] rx_udp_ip_dscp,
    (*mark_debug = "false"*)output wire [ 1:0] rx_udp_ip_ecn,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_ip_length,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_ip_identification,
    (*mark_debug = "false"*)output wire [ 2:0] rx_udp_ip_flags,
    (*mark_debug = "false"*)output wire [12:0] rx_udp_ip_fragment_offset,
    (*mark_debug = "false"*)output wire [ 7:0] rx_udp_ip_ttl,
    (*mark_debug = "false"*)output wire [ 7:0] rx_udp_ip_protocol,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_ip_header_checksum,
    (*mark_debug = "false"*)output wire [31:0] rx_udp_ip_source_ip,
    (*mark_debug = "false"*)output wire [31:0] rx_udp_ip_dest_ip,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_source_port,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_dest_port,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_length,
    (*mark_debug = "false"*)output wire [15:0] rx_udp_checksum,
    (*mark_debug = "false"*)output wire [ 7:0] rx_udp_payload_axis_tdata,
    (*mark_debug = "false"*)output wire        rx_udp_payload_axis_tvalid,
    (*mark_debug = "false"*)input  wire        rx_udp_payload_axis_tready,
    (*mark_debug = "false"*)output wire        rx_udp_payload_axis_tlast,
    (*mark_debug = "false"*)output wire        rx_udp_payload_axis_tuser,

    // UDP TX Interface (from application to network, clk domain)
    input  wire        tx_udp_hdr_valid,
    output wire        tx_udp_hdr_ready,
    input  wire [ 5:0] tx_udp_ip_dscp,
    input  wire [ 1:0] tx_udp_ip_ecn,
    input  wire [ 7:0] tx_udp_ip_ttl,
    input  wire [31:0] tx_udp_ip_source_ip,
    input  wire [31:0] tx_udp_ip_dest_ip,
    input  wire [15:0] tx_udp_source_port,
    input  wire [15:0] tx_udp_dest_port,
    input  wire [15:0] tx_udp_length,
    input  wire [15:0] tx_udp_checksum,
    input  wire [ 7:0] tx_udp_payload_axis_tdata,
    input  wire        tx_udp_payload_axis_tvalid,
    output wire        tx_udp_payload_axis_tready,
    input  wire        tx_udp_payload_axis_tlast,
    input  wire        tx_udp_payload_axis_tuser,

    // Configuration
    input wire [47:0] local_mac,
    input wire [31:0] local_ip,
    input wire [31:0] gateway_ip,
    input wire [31:0] subnet_mask
);

    // AXI between MAC and Ethernet modules
    (*mark_debug = "false"*)wire [ 7:0] rx_axis_tdata;
    (*mark_debug = "false"*)wire        rx_axis_tvalid;
    (*mark_debug = "false"*)wire        rx_axis_tready;
    (*mark_debug = "false"*)wire        rx_axis_tlast;
    (*mark_debug = "false"*)wire        rx_axis_tuser;

    wire [ 7:0] tx_axis_tdata;
    wire        tx_axis_tvalid;
    wire        tx_axis_tready;
    wire        tx_axis_tlast;
    wire        tx_axis_tuser;

    // Ethernet frame between Ethernet modules and UDP stack
    (*mark_debug = "false"*)wire        rx_eth_hdr_ready;
    (*mark_debug = "false"*)wire        rx_eth_hdr_valid;
    (*mark_debug = "false"*)wire [47:0] rx_eth_dest_mac;
    (*mark_debug = "false"*)wire [47:0] rx_eth_src_mac;
    (*mark_debug = "false"*)wire [15:0] rx_eth_type;
    (*mark_debug = "false"*)wire [ 7:0] rx_eth_payload_axis_tdata;
    (*mark_debug = "false"*)wire        rx_eth_payload_axis_tvalid;
    (*mark_debug = "false"*)wire        rx_eth_payload_axis_tready;
    (*mark_debug = "false"*)wire        rx_eth_payload_axis_tlast;
    (*mark_debug = "false"*)wire        rx_eth_payload_axis_tuser;

    wire        tx_eth_hdr_ready;
    wire        tx_eth_hdr_valid;
    wire [47:0] tx_eth_dest_mac;
    wire [47:0] tx_eth_src_mac;
    wire [15:0] tx_eth_type;
    wire [ 7:0] tx_eth_payload_axis_tdata;
    wire        tx_eth_payload_axis_tvalid;
    wire        tx_eth_payload_axis_tready;
    wire        tx_eth_payload_axis_tlast;
    wire        tx_eth_payload_axis_tuser;

    // IP frame connections
    (*mark_debug = "false"*)wire        rx_ip_hdr_valid;
    (*mark_debug = "false"*)wire        rx_ip_hdr_ready;
    (*mark_debug = "false"*)wire [47:0] rx_ip_eth_dest_mac;
    (*mark_debug = "false"*)wire [47:0] rx_ip_eth_src_mac;
    (*mark_debug = "false"*)wire [15:0] rx_ip_eth_type;
    (*mark_debug = "false"*)wire [ 3:0] rx_ip_version;
    (*mark_debug = "false"*)wire [ 3:0] rx_ip_ihl;
    (*mark_debug = "false"*)wire [ 5:0] rx_ip_dscp;
    (*mark_debug = "false"*)wire [ 1:0] rx_ip_ecn;
    (*mark_debug = "false"*)wire [15:0] rx_ip_length;
    (*mark_debug = "false"*)wire [15:0] rx_ip_identification;
    (*mark_debug = "false"*)wire [ 2:0] rx_ip_flags;
    (*mark_debug = "false"*)wire [12:0] rx_ip_fragment_offset;
    (*mark_debug = "false"*)wire [ 7:0] rx_ip_ttl;
    (*mark_debug = "false"*)wire [ 7:0] rx_ip_protocol;
    (*mark_debug = "false"*)wire [15:0] rx_ip_header_checksum;
    (*mark_debug = "false"*)wire [31:0] rx_ip_source_ip;
    (*mark_debug = "false"*)wire [31:0] rx_ip_dest_ip;
    (*mark_debug = "false"*)wire [ 7:0] rx_ip_payload_axis_tdata;
    (*mark_debug = "false"*)wire        rx_ip_payload_axis_tvalid;
    (*mark_debug = "false"*)wire        rx_ip_payload_axis_tready;
    (*mark_debug = "false"*)wire        rx_ip_payload_axis_tlast;
    (*mark_debug = "false"*)wire        rx_ip_payload_axis_tuser;

    wire        tx_ip_hdr_valid;
    wire        tx_ip_hdr_ready;
    wire [ 5:0] tx_ip_dscp;
    wire [ 1:0] tx_ip_ecn;
    wire [15:0] tx_ip_length;
    wire [ 7:0] tx_ip_ttl;
    wire [ 7:0] tx_ip_protocol;
    wire [31:0] tx_ip_source_ip;
    wire [31:0] tx_ip_dest_ip;
    wire [ 7:0] tx_ip_payload_axis_tdata;
    wire        tx_ip_payload_axis_tvalid;
    wire        tx_ip_payload_axis_tready;
    wire        tx_ip_payload_axis_tlast;
    wire        tx_ip_payload_axis_tuser;

    // IP ports not used
    assign rx_ip_hdr_ready = 1;
    assign rx_ip_payload_axis_tready = 1;

    assign tx_ip_hdr_valid = 0;
    assign tx_ip_dscp = 0;
    assign tx_ip_ecn = 0;
    assign tx_ip_length = 0;
    assign tx_ip_ttl = 0;
    assign tx_ip_protocol = 0;
    assign tx_ip_source_ip = 0;
    assign tx_ip_dest_ip = 0;
    assign tx_ip_payload_axis_tdata = 0;
    assign tx_ip_payload_axis_tvalid = 0;
    assign tx_ip_payload_axis_tlast = 0;
    assign tx_ip_payload_axis_tuser = 0;

    assign phy_reset_n = !rst;

    eth_mac_1g_rgmii_fifo #(
        .TARGET(TARGET),
        .IODDR_STYLE("IODDR"),
        .CLOCK_INPUT_STYLE("BUFR"),
        .USE_CLK90("TRUE"),
        .ENABLE_PADDING(1),
        .MIN_FRAME_LENGTH(64),
        .TX_FIFO_DEPTH(4096),
        .TX_FRAME_FIFO(1),
        .RX_FIFO_DEPTH(4096),
        .RX_FRAME_FIFO(1)
    ) eth_mac_inst (
        .gtx_clk  (clk),
        .gtx_clk90(clk90),
        .gtx_rst  (rst),
        .logic_clk(clk),
        .logic_rst(rst),

        .tx_axis_tdata (tx_axis_tdata),
        .tx_axis_tvalid(tx_axis_tvalid),
        .tx_axis_tready(tx_axis_tready),
        .tx_axis_tlast (tx_axis_tlast),
        .tx_axis_tuser (tx_axis_tuser),

        .rx_axis_tdata (rx_axis_tdata),
        .rx_axis_tvalid(rx_axis_tvalid),
        .rx_axis_tready(rx_axis_tready),
        .rx_axis_tlast (rx_axis_tlast),
        .rx_axis_tuser (rx_axis_tuser),

        .rgmii_rx_clk(phy_rx_clk),
        .rgmii_rxd   (phy_rxd),
        .rgmii_rx_ctl(phy_rx_ctl),
        .rgmii_tx_clk(phy_tx_clk),
        .rgmii_txd   (phy_txd),
        .rgmii_tx_ctl(phy_tx_ctl),

        .tx_fifo_overflow  (),
        .tx_fifo_bad_frame (),
        .tx_fifo_good_frame(),
        .rx_error_bad_frame(),
        .rx_error_bad_fcs  (),
        .rx_fifo_overflow  (),
        .rx_fifo_bad_frame (),
        .rx_fifo_good_frame(),
        .speed             (),

        .cfg_ifg      (8'd12),
        .cfg_tx_enable(1'b1),
        .cfg_rx_enable(1'b1)
    );


    eth_axis_rx eth_axis_rx_inst (
        .clk                           (clk),
        .rst                           (rst),
        // AXI input
        .s_axis_tdata                  (rx_axis_tdata),
        .s_axis_tvalid                 (rx_axis_tvalid),
        .s_axis_tready                 (rx_axis_tready),
        .s_axis_tlast                  (rx_axis_tlast),
        .s_axis_tuser                  (rx_axis_tuser),
        // Ethernet frame output
        .m_eth_hdr_valid               (rx_eth_hdr_valid),
        .m_eth_hdr_ready               (rx_eth_hdr_ready),
        .m_eth_dest_mac                (rx_eth_dest_mac),
        .m_eth_src_mac                 (rx_eth_src_mac),
        .m_eth_type                    (rx_eth_type),
        .m_eth_payload_axis_tdata      (rx_eth_payload_axis_tdata),
        .m_eth_payload_axis_tvalid     (rx_eth_payload_axis_tvalid),
        .m_eth_payload_axis_tready     (rx_eth_payload_axis_tready),
        .m_eth_payload_axis_tlast      (rx_eth_payload_axis_tlast),
        .m_eth_payload_axis_tuser      (rx_eth_payload_axis_tuser),
        // Status signals
        .busy                          (),
        .error_header_early_termination()
    );

    eth_axis_tx eth_axis_tx_inst (
        .clk                      (clk),
        .rst                      (rst),
        // Ethernet frame input
        .s_eth_hdr_valid          (tx_eth_hdr_valid),
        .s_eth_hdr_ready          (tx_eth_hdr_ready),
        .s_eth_dest_mac           (tx_eth_dest_mac),
        .s_eth_src_mac            (tx_eth_src_mac),
        .s_eth_type               (tx_eth_type),
        .s_eth_payload_axis_tdata (tx_eth_payload_axis_tdata),
        .s_eth_payload_axis_tvalid(tx_eth_payload_axis_tvalid),
        .s_eth_payload_axis_tready(tx_eth_payload_axis_tready),
        .s_eth_payload_axis_tlast (tx_eth_payload_axis_tlast),
        .s_eth_payload_axis_tuser (tx_eth_payload_axis_tuser),
        // AXI output
        .m_axis_tdata             (tx_axis_tdata),
        .m_axis_tvalid            (tx_axis_tvalid),
        .m_axis_tready            (tx_axis_tready),
        .m_axis_tlast             (tx_axis_tlast),
        .m_axis_tuser             (tx_axis_tuser),
        // Status signals
        .busy                     ()
    );

    udp_complete udp_complete_inst (
        .clk                                   (clk),
        .rst                                   (rst),
        // Ethernet frame input
        .s_eth_hdr_valid                       (rx_eth_hdr_valid),
        .s_eth_hdr_ready                       (rx_eth_hdr_ready),
        .s_eth_dest_mac                        (rx_eth_dest_mac),
        .s_eth_src_mac                         (rx_eth_src_mac),
        .s_eth_type                            (rx_eth_type),
        .s_eth_payload_axis_tdata              (rx_eth_payload_axis_tdata),
        .s_eth_payload_axis_tvalid             (rx_eth_payload_axis_tvalid),
        .s_eth_payload_axis_tready             (rx_eth_payload_axis_tready),
        .s_eth_payload_axis_tlast              (rx_eth_payload_axis_tlast),
        .s_eth_payload_axis_tuser              (rx_eth_payload_axis_tuser),
        // Ethernet frame output
        .m_eth_hdr_valid                       (tx_eth_hdr_valid),
        .m_eth_hdr_ready                       (tx_eth_hdr_ready),
        .m_eth_dest_mac                        (tx_eth_dest_mac),
        .m_eth_src_mac                         (tx_eth_src_mac),
        .m_eth_type                            (tx_eth_type),
        .m_eth_payload_axis_tdata              (tx_eth_payload_axis_tdata),
        .m_eth_payload_axis_tvalid             (tx_eth_payload_axis_tvalid),
        .m_eth_payload_axis_tready             (tx_eth_payload_axis_tready),
        .m_eth_payload_axis_tlast              (tx_eth_payload_axis_tlast),
        .m_eth_payload_axis_tuser              (tx_eth_payload_axis_tuser),
        // IP frame input
        .s_ip_hdr_valid                        (tx_ip_hdr_valid),
        .s_ip_hdr_ready                        (tx_ip_hdr_ready),
        .s_ip_dscp                             (tx_ip_dscp),
        .s_ip_ecn                              (tx_ip_ecn),
        .s_ip_length                           (tx_ip_length),
        .s_ip_ttl                              (tx_ip_ttl),
        .s_ip_protocol                         (tx_ip_protocol),
        .s_ip_source_ip                        (tx_ip_source_ip),
        .s_ip_dest_ip                          (tx_ip_dest_ip),
        .s_ip_payload_axis_tdata               (tx_ip_payload_axis_tdata),
        .s_ip_payload_axis_tvalid              (tx_ip_payload_axis_tvalid),
        .s_ip_payload_axis_tready              (tx_ip_payload_axis_tready),
        .s_ip_payload_axis_tlast               (tx_ip_payload_axis_tlast),
        .s_ip_payload_axis_tuser               (tx_ip_payload_axis_tuser),
        // IP frame output
        .m_ip_hdr_valid                        (rx_ip_hdr_valid),
        .m_ip_hdr_ready                        (rx_ip_hdr_ready),
        .m_ip_eth_dest_mac                     (rx_ip_eth_dest_mac),
        .m_ip_eth_src_mac                      (rx_ip_eth_src_mac),
        .m_ip_eth_type                         (rx_ip_eth_type),
        .m_ip_version                          (rx_ip_version),
        .m_ip_ihl                              (rx_ip_ihl),
        .m_ip_dscp                             (rx_ip_dscp),
        .m_ip_ecn                              (rx_ip_ecn),
        .m_ip_length                           (rx_ip_length),
        .m_ip_identification                   (rx_ip_identification),
        .m_ip_flags                            (rx_ip_flags),
        .m_ip_fragment_offset                  (rx_ip_fragment_offset),
        .m_ip_ttl                              (rx_ip_ttl),
        .m_ip_protocol                         (rx_ip_protocol),
        .m_ip_header_checksum                  (rx_ip_header_checksum),
        .m_ip_source_ip                        (rx_ip_source_ip),
        .m_ip_dest_ip                          (rx_ip_dest_ip),
        .m_ip_payload_axis_tdata               (rx_ip_payload_axis_tdata),
        .m_ip_payload_axis_tvalid              (rx_ip_payload_axis_tvalid),
        .m_ip_payload_axis_tready              (rx_ip_payload_axis_tready),
        .m_ip_payload_axis_tlast               (rx_ip_payload_axis_tlast),
        .m_ip_payload_axis_tuser               (rx_ip_payload_axis_tuser),
        // UDP frame input
        .s_udp_hdr_valid                       (tx_udp_hdr_valid),
        .s_udp_hdr_ready                       (tx_udp_hdr_ready),
        .s_udp_ip_dscp                         (tx_udp_ip_dscp),
        .s_udp_ip_ecn                          (tx_udp_ip_ecn),
        .s_udp_ip_ttl                          (tx_udp_ip_ttl),
        .s_udp_ip_source_ip                    (tx_udp_ip_source_ip),
        .s_udp_ip_dest_ip                      (tx_udp_ip_dest_ip),
        .s_udp_source_port                     (tx_udp_source_port),
        .s_udp_dest_port                       (tx_udp_dest_port),
        .s_udp_length                          (tx_udp_length),
        .s_udp_checksum                        (tx_udp_checksum),
        .s_udp_payload_axis_tdata              (tx_udp_payload_axis_tdata),
        .s_udp_payload_axis_tvalid             (tx_udp_payload_axis_tvalid),
        .s_udp_payload_axis_tready             (tx_udp_payload_axis_tready),
        .s_udp_payload_axis_tlast              (tx_udp_payload_axis_tlast),
        .s_udp_payload_axis_tuser              (tx_udp_payload_axis_tuser),
        // UDP frame output
        .m_udp_hdr_valid                       (rx_udp_hdr_valid),
        .m_udp_hdr_ready                       (rx_udp_hdr_ready),
        .m_udp_eth_dest_mac                    (rx_udp_eth_dest_mac),
        .m_udp_eth_src_mac                     (rx_udp_eth_src_mac),
        .m_udp_eth_type                        (rx_udp_eth_type),
        .m_udp_ip_version                      (rx_udp_ip_version),
        .m_udp_ip_ihl                          (rx_udp_ip_ihl),
        .m_udp_ip_dscp                         (rx_udp_ip_dscp),
        .m_udp_ip_ecn                          (rx_udp_ip_ecn),
        .m_udp_ip_length                       (rx_udp_ip_length),
        .m_udp_ip_identification               (rx_udp_ip_identification),
        .m_udp_ip_flags                        (rx_udp_ip_flags),
        .m_udp_ip_fragment_offset              (rx_udp_ip_fragment_offset),
        .m_udp_ip_ttl                          (rx_udp_ip_ttl),
        .m_udp_ip_protocol                     (rx_udp_ip_protocol),
        .m_udp_ip_header_checksum              (rx_udp_ip_header_checksum),
        .m_udp_ip_source_ip                    (rx_udp_ip_source_ip),
        .m_udp_ip_dest_ip                      (rx_udp_ip_dest_ip),
        .m_udp_source_port                     (rx_udp_source_port),
        .m_udp_dest_port                       (rx_udp_dest_port),
        .m_udp_length                          (rx_udp_length),
        .m_udp_checksum                        (rx_udp_checksum),
        .m_udp_payload_axis_tdata              (rx_udp_payload_axis_tdata),
        .m_udp_payload_axis_tvalid             (rx_udp_payload_axis_tvalid),
        .m_udp_payload_axis_tready             (rx_udp_payload_axis_tready),
        .m_udp_payload_axis_tlast              (rx_udp_payload_axis_tlast),
        .m_udp_payload_axis_tuser              (rx_udp_payload_axis_tuser),
        // Status signals
        .ip_rx_busy                            (),
        .ip_tx_busy                            (),
        .udp_rx_busy                           (),
        .udp_tx_busy                           (),
        .ip_rx_error_header_early_termination  (),
        .ip_rx_error_payload_early_termination (),
        .ip_rx_error_invalid_header            (),
        .ip_rx_error_invalid_checksum          (),
        .ip_tx_error_payload_early_termination (),
        .ip_tx_error_arp_failed                (),
        .udp_rx_error_header_early_termination (),
        .udp_rx_error_payload_early_termination(),
        .udp_tx_error_payload_early_termination(),
        // Configuration
        .local_mac                             (local_mac),
        .local_ip                              (local_ip),
        .gateway_ip                            (gateway_ip),
        .subnet_mask                           (subnet_mask),
        .clear_arp_cache                       (0)
    );

endmodule

`resetall

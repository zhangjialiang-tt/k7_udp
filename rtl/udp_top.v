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
 * FPGA core logic
 */
module udp_top #(
    parameter TARGET     = "GENERIC",
    parameter LOCAL_IP   = {8'd192, 8'd168, 8'd1, 8'd128},  // 192.168.1.128
    parameter LOCAL_PORT = 16'd1234,                        // 监听端口
    parameter DEST_IP    = {8'd192, 8'd168, 8'd1, 8'd129},  // 192.168.1.129
    parameter DEST_PORT  = 16'd1234,                        // 目标端口号
    parameter DATA_W     = 64                               // 应用层数据位宽
) (
    // System/Application Clock Domain
    input wire sys_clk,
    input wire sys_rstn,

    // Simplified App Interface (sys_clk domain)
    input  wire [DATA_W-1:0] din_data,
    input  wire              din_valid,
    input  wire              din_last,
    output wire              din_ready,
    output wire [DATA_W-1:0] dout_data,
    output wire              dout_valid,
    output wire              dout_last,
    input  wire              dout_ready,

    // Core Clock Domain: 125MHz
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
    output wire       phy_reset_n
);

    wire        sys_rst = !sys_rstn;

    // Configuration
    wire [47:0] local_mac = 48'h02_00_00_00_00_00;
    wire [31:0] gateway_ip = {8'd192, 8'd168, 8'd1, 8'd1};
    wire [31:0] subnet_mask = {8'd255, 8'd255, 8'd255, 8'd0};

    // Metadata signals
    wire [31:0] m_app_rx_src_ip;
    wire [15:0] m_app_rx_src_port;
    wire        m_app_rx_valid;

    // UDP frame connections between core and path modules
    (*mark_debug = "false"*)wire        rx_udp_hdr_valid;
    (*mark_debug = "false"*)wire        rx_udp_hdr_ready;
    (*mark_debug = "false"*)wire [47:0] rx_udp_eth_dest_mac;
    (*mark_debug = "false"*)wire [47:0] rx_udp_eth_src_mac;
    (*mark_debug = "false"*)wire [15:0] rx_udp_eth_type;
    (*mark_debug = "false"*)wire [ 3:0] rx_udp_ip_version;
    (*mark_debug = "false"*)wire [ 3:0] rx_udp_ip_ihl;
    (*mark_debug = "false"*)wire [ 5:0] rx_udp_ip_dscp;
    (*mark_debug = "false"*)wire [ 1:0] rx_udp_ip_ecn;
    (*mark_debug = "false"*)wire [15:0] rx_udp_ip_length;
    (*mark_debug = "false"*)wire [15:0] rx_udp_ip_identification;
    (*mark_debug = "false"*)wire [ 2:0] rx_udp_ip_flags;
    (*mark_debug = "false"*)wire [12:0] rx_udp_ip_fragment_offset;
    (*mark_debug = "false"*)wire [ 7:0] rx_udp_ip_ttl;
    (*mark_debug = "false"*)wire [ 7:0] rx_udp_ip_protocol;
    (*mark_debug = "false"*)wire [15:0] rx_udp_ip_header_checksum;
    (*mark_debug = "false"*)wire [31:0] rx_udp_ip_source_ip;
    (*mark_debug = "false"*)wire [31:0] rx_udp_ip_dest_ip;
    (*mark_debug = "false"*)wire [15:0] rx_udp_source_port;
    (*mark_debug = "false"*)wire [15:0] rx_udp_dest_port;
    (*mark_debug = "false"*)wire [15:0] rx_udp_length;
    (*mark_debug = "false"*)wire [15:0] rx_udp_checksum;
    (*mark_debug = "false"*)wire [ 7:0] rx_udp_payload_axis_tdata;
    (*mark_debug = "false"*)wire        rx_udp_payload_axis_tvalid;
    (*mark_debug = "false"*)wire        rx_udp_payload_axis_tready;
    (*mark_debug = "false"*)wire        rx_udp_payload_axis_tlast;
    (*mark_debug = "false"*)wire        rx_udp_payload_axis_tuser;

    wire        tx_udp_hdr_valid;
    wire        tx_udp_hdr_ready;
    wire [ 5:0] tx_udp_ip_dscp;
    wire [ 1:0] tx_udp_ip_ecn;
    wire [ 7:0] tx_udp_ip_ttl;
    wire [31:0] tx_udp_ip_source_ip;
    wire [31:0] tx_udp_ip_dest_ip;
    wire [15:0] tx_udp_source_port;
    wire [15:0] tx_udp_dest_port;
    wire [15:0] tx_udp_length;
    wire [15:0] tx_udp_checksum;
    wire [ 7:0] tx_udp_payload_axis_tdata;
    wire        tx_udp_payload_axis_tvalid;
    wire        tx_udp_payload_axis_tready;
    wire        tx_udp_payload_axis_tlast;
    wire        tx_udp_payload_axis_tuser;

    // ----------------------------------------------------------------
    // UDP Core Instantiation
    // ----------------------------------------------------------------

    udp_core #(
        .TARGET(TARGET)
    ) udp_core_inst (
        // Core Clock Domain
        .clk                       (clk),
        .clk90                     (clk90),
        .rst                       (rst),
        // Ethernet: 1000BASE-T RGMII
        .phy_rx_clk                (phy_rx_clk),
        .phy_rxd                   (phy_rxd),
        .phy_rx_ctl                (phy_rx_ctl),
        .phy_tx_clk                (phy_tx_clk),
        .phy_txd                   (phy_txd),
        .phy_tx_ctl                (phy_tx_ctl),
        .phy_reset_n               (phy_reset_n),
        // UDP RX Interface (from network to application)
        .rx_udp_hdr_valid          (rx_udp_hdr_valid),
        .rx_udp_hdr_ready          (rx_udp_hdr_ready),
        .rx_udp_eth_dest_mac       (rx_udp_eth_dest_mac),
        .rx_udp_eth_src_mac        (rx_udp_eth_src_mac),
        .rx_udp_eth_type           (rx_udp_eth_type),
        .rx_udp_ip_version         (rx_udp_ip_version),
        .rx_udp_ip_ihl             (rx_udp_ip_ihl),
        .rx_udp_ip_dscp            (rx_udp_ip_dscp),
        .rx_udp_ip_ecn             (rx_udp_ip_ecn),
        .rx_udp_ip_length          (rx_udp_ip_length),
        .rx_udp_ip_identification  (rx_udp_ip_identification),
        .rx_udp_ip_flags           (rx_udp_ip_flags),
        .rx_udp_ip_fragment_offset (rx_udp_ip_fragment_offset),
        .rx_udp_ip_ttl             (rx_udp_ip_ttl),
        .rx_udp_ip_protocol        (rx_udp_ip_protocol),
        .rx_udp_ip_header_checksum (rx_udp_ip_header_checksum),
        .rx_udp_ip_source_ip       (rx_udp_ip_source_ip),
        .rx_udp_ip_dest_ip         (rx_udp_ip_dest_ip),
        .rx_udp_source_port        (rx_udp_source_port),
        .rx_udp_dest_port          (rx_udp_dest_port),
        .rx_udp_length             (rx_udp_length),
        .rx_udp_checksum           (rx_udp_checksum),
        .rx_udp_payload_axis_tdata (rx_udp_payload_axis_tdata),
        .rx_udp_payload_axis_tvalid(rx_udp_payload_axis_tvalid),
        .rx_udp_payload_axis_tready(rx_udp_payload_axis_tready),
        .rx_udp_payload_axis_tlast (rx_udp_payload_axis_tlast),
        .rx_udp_payload_axis_tuser (rx_udp_payload_axis_tuser),
        // UDP TX Interface (from application to network)
        .tx_udp_hdr_valid          (tx_udp_hdr_valid),
        .tx_udp_hdr_ready          (tx_udp_hdr_ready),
        .tx_udp_ip_dscp            (tx_udp_ip_dscp),
        .tx_udp_ip_ecn             (tx_udp_ip_ecn),
        .tx_udp_ip_ttl             (tx_udp_ip_ttl),
        .tx_udp_ip_source_ip       (tx_udp_ip_source_ip),
        .tx_udp_ip_dest_ip         (tx_udp_ip_dest_ip),
        .tx_udp_source_port        (tx_udp_source_port),
        .tx_udp_dest_port          (tx_udp_dest_port),
        .tx_udp_length             (tx_udp_length),
        .tx_udp_checksum           (tx_udp_checksum),
        .tx_udp_payload_axis_tdata (tx_udp_payload_axis_tdata),
        .tx_udp_payload_axis_tvalid(tx_udp_payload_axis_tvalid),
        .tx_udp_payload_axis_tready(tx_udp_payload_axis_tready),
        .tx_udp_payload_axis_tlast (tx_udp_payload_axis_tlast),
        .tx_udp_payload_axis_tuser (tx_udp_payload_axis_tuser),
        // Configuration
        .local_mac                 (local_mac),
        .local_ip                  (LOCAL_IP),
        .gateway_ip                (gateway_ip),
        .subnet_mask               (subnet_mask)
    );

    // ----------------------------------------------------------------
    // TX Path Instantiation - 发送路径实例化
    // ----------------------------------------------------------------
    udp_tx_path #(
        .DATA_W(DATA_W)
    ) udp_tx_path_inst (
        // System/Application Clock Domain
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),

        // Application Interface (sys_clk domain)
        .din_data (din_data),
        .din_valid(din_valid),
        .din_last (din_last),
        .din_ready(din_ready),

        // Core Clock Domain
        .clk(clk),
        .rst(rst),

        // UDP Core Interface (clk domain)
        .tx_udp_hdr_valid          (tx_udp_hdr_valid),
        .tx_udp_hdr_ready          (tx_udp_hdr_ready),
        .tx_udp_ip_dscp            (tx_udp_ip_dscp),
        .tx_udp_ip_ecn             (tx_udp_ip_ecn),
        .tx_udp_ip_ttl             (tx_udp_ip_ttl),
        .tx_udp_ip_source_ip       (tx_udp_ip_source_ip),
        .tx_udp_ip_dest_ip         (tx_udp_ip_dest_ip),
        .tx_udp_source_port        (tx_udp_source_port),
        .tx_udp_dest_port          (tx_udp_dest_port),
        .tx_udp_length             (tx_udp_length),
        .tx_udp_checksum           (tx_udp_checksum),
        .tx_udp_payload_axis_tdata (tx_udp_payload_axis_tdata),
        .tx_udp_payload_axis_tvalid(tx_udp_payload_axis_tvalid),
        .tx_udp_payload_axis_tready(tx_udp_payload_axis_tready),
        .tx_udp_payload_axis_tlast (tx_udp_payload_axis_tlast),
        .tx_udp_payload_axis_tuser (tx_udp_payload_axis_tuser),

        // Configuration
        .local_ip  (LOCAL_IP),
        .dest_ip   (DEST_IP),
        .local_port(LOCAL_PORT),
        .dest_port (DEST_PORT)
    );

    // ----------------------------------------------------------------
    // RX Path Instantiation - 接收路径实例化
    // ----------------------------------------------------------------
    udp_rx_path #(
        .DATA_W(DATA_W)
    ) udp_rx_path_inst (
        // System/Application Clock Domain
        .sys_clk                   (sys_clk),
        .sys_rst                   (sys_rst),
        // Application Interface (sys_clk domain)
        .dout_data                 (dout_data),
        .dout_valid                (dout_valid),
        .dout_last                 (dout_last),
        .dout_ready                (dout_ready),
        // Core Clock Domain
        .clk                       (clk),
        .rst                       (rst),
        // UDP Core Interface (clk domain)
        .rx_udp_hdr_valid          (rx_udp_hdr_valid),
        .rx_udp_hdr_ready          (rx_udp_hdr_ready),
        .rx_udp_ip_source_ip       (rx_udp_ip_source_ip),
        .rx_udp_ip_dest_ip         (rx_udp_ip_dest_ip),
        .rx_udp_source_port        (rx_udp_source_port),
        .rx_udp_dest_port          (rx_udp_dest_port),
        .rx_udp_payload_axis_tdata (rx_udp_payload_axis_tdata),
        .rx_udp_payload_axis_tvalid(rx_udp_payload_axis_tvalid),
        .rx_udp_payload_axis_tready(rx_udp_payload_axis_tready),
        .rx_udp_payload_axis_tlast (rx_udp_payload_axis_tlast),
        .rx_udp_payload_axis_tuser (rx_udp_payload_axis_tuser),

        // Metadata output (sys_clk domain)
        // .m_app_rx_src_ip  (m_app_rx_src_ip),
        // .m_app_rx_src_port(m_app_rx_src_port),
        // .m_app_rx_valid   (m_app_rx_valid),

        // Configuration
        .local_ip  (LOCAL_IP),
        .dest_ip   (DEST_IP),
        .local_port(LOCAL_PORT),
        .dest_port (DEST_PORT)
    );

endmodule

`resetall

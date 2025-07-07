/*

Copyright (c) 2014-2018 Alex Forencich

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
 * FPGA top-level module
 */
module top (
    /*
     * Clock: 100MHz
     * Reset: Push button, active low
     */
    input wire clk,
    // input  wire       reset_n,

    /*
     * GPIO
     */
    // input  wire       btnu,
    // input  wire       btnl,
    // input  wire       btnd,
    // input  wire       btnr,
    // input  wire       btnc,
    // input  wire [7:0] sw,
    output wire [  7:0] led,
    input  wire [5-1:0] key_in,

    /*
     * Ethernet: 1000BASE-T RGMII
     */
    input  wire       phy2_rx_clk,
    input  wire [3:0] phy2_rxd,
    input  wire       phy2_rx_ctl,
    output wire       phy2_tx_clk,
    output wire [3:0] phy2_txd,
    output wire       phy2_tx_ctl,
    output wire       phy2_reset_n,
    // input  wire       phy_int_n,
    // input  wire       phy_pme_n,

    /*
     * UART: 500000 bps, 8N1
     */
    input  wire uart_rxd,
    output wire uart_txd
);

    localparam SYS_FREQ = 125_000_000;
    localparam AD7380_DIV_FREQ = 47*2;
    localparam UPLOAD_RATE = 10;
    // Clock and reset

    wire       clk_ibufg;
    // Internal 125 MHz clock
    wire       clk_mmcm_out;
    wire       clk_int;
    wire       rst_int;
    wire       mmcm_rst = 1'b0;  //~reset_n;
    wire       mmcm_locked;
    wire       mmcm_clkfb;
    wire       clk90_mmcm_out;
    wire       clk90_int;
    wire       clk_200_mmcm_out;
    wire       clk_200_int;
    wire       rst_200_int;
    // GPIO
    wire       btnu_int;
    wire       btnl_int;
    wire       btnd_int;
    wire       btnr_int;
    wire       btnc_int;
    wire [7:0] sw;
    wire [7:0] sw_int;
    assign sw = 8'd0;
    wire        uart_rxd_int;
    (*mark_debug = "false"*)wire [31:0] din_data_func;
    (*mark_debug = "false"*)wire        din_valid_func;
    (*mark_debug = "false"*)wire        din_last_func;
    (*mark_debug = "false"*)wire        dout_ready_func;
    (*mark_debug = "false"*)wire [31:0] dout_data_func;
    (*mark_debug = "false"*)wire        dout_valid_func;
    (*mark_debug = "false"*)wire        dout_last_func;
    (*mark_debug = "false"*)wire        key_cap;
    // MMCM instance
    // 100 MHz in, 125 MHz out
    // PFD range: 10 MHz to 550 MHz
    // VCO range: 600 MHz to 1200 MHz
    // M = 10, D = 1 sets Fvco = 1000 MHz (in range)
    // Divide by 8 to get output frequency of 125 MHz
    // Need two 125 MHz outputs with 90 degree offset
    // Also need 200 MHz out for IODELAY
    // 1000 / 5 = 200 MHz
    IBUFG clk_ibufg_inst (
        .I(clk),
        .O(clk_ibufg)
    );

    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKOUT0_DIVIDE_F(8),
        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKOUT0_PHASE(0),

        .CLKOUT1_DIVIDE(8),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT1_PHASE(90),

        .CLKOUT2_DIVIDE(5),
        .CLKOUT2_DUTY_CYCLE(0.5),
        .CLKOUT2_PHASE(0),

        .CLKOUT3_DIVIDE(1),
        .CLKOUT3_DUTY_CYCLE(0.5),
        .CLKOUT3_PHASE(0),

        .CLKOUT4_DIVIDE(1),
        .CLKOUT4_DUTY_CYCLE(0.5),
        .CLKOUT4_PHASE(0),

        .CLKOUT5_DIVIDE(1),
        .CLKOUT5_DUTY_CYCLE(0.5),
        .CLKOUT5_PHASE(0),

        .CLKOUT6_DIVIDE(1),
        .CLKOUT6_DUTY_CYCLE(0.5),
        .CLKOUT6_PHASE(0),

        .CLKFBOUT_MULT_F(20),  //Fvco = 50mhz*20=1000mhz
        .CLKFBOUT_PHASE(0),
        .DIVCLK_DIVIDE(1),
        .REF_JITTER1(0.010),
        .CLKIN1_PERIOD(20.0),  //输入时钟周期-20ns
        .STARTUP_WAIT("FALSE"),
        .CLKOUT4_CASCADE("FALSE")
    ) clk_mmcm_inst (
        .CLKIN1   (clk_ibufg),         //50MHZ
        .CLKFBIN  (mmcm_clkfb),
        .RST      (mmcm_rst),
        .PWRDWN   (1'b0),
        .CLKOUT0  (clk_mmcm_out),
        .CLKOUT0B (),
        .CLKOUT1  (clk90_mmcm_out),
        .CLKOUT1B (),
        .CLKOUT2  (clk_200_mmcm_out),
        .CLKOUT2B (),
        .CLKOUT3  (),
        .CLKOUT3B (),
        .CLKOUT4  (),
        .CLKOUT5  (),
        .CLKOUT6  (),
        .CLKFBOUT (mmcm_clkfb),
        .CLKFBOUTB(),
        .LOCKED   (mmcm_locked)
    );

    BUFG clk_bufg_inst (
        .I(clk_mmcm_out),
        .O(clk_int)
    );

    BUFG clk90_bufg_inst (
        .I(clk90_mmcm_out),
        .O(clk90_int)
    );

    BUFG clk_200_bufg_inst (
        .I(clk_200_mmcm_out),
        .O(clk_200_int)
    );

    sync_reset #(
        .N(4)
    ) sync_reset_inst (
        .clk(clk_int),
        .rst(~mmcm_locked),
        .out(rst_int)
    );
    sync_reset #(
        .N(4)
    ) sync_reset_200m_inst (
        .clk(clk_200_int),
        .rst(~mmcm_locked),
        .out(rst_200_int)
    );



    sync_signal #(
        .WIDTH(1),
        .N(2)
    ) sync_signal_inst (
        .clk(clk_int),
        .in ({uart_rxd}),
        .out({uart_rxd_int})
    );

    // IODELAY elements for RGMII interface to PHY
    wire [3:0] phy2_rxd_delay;
    wire       phy2_rx_ctl_delay;

    IDELAYCTRL idelayctrl_inst (
        .REFCLK(clk_200_int),
        .RST   (rst_int),
        .RDY   ()
    );

    IDELAYE2 #(
        .IDELAY_TYPE("FIXED")
    ) phy_rxd_idelay_0 (
        .IDATAIN    (phy2_rxd[0]),
        .DATAOUT    (phy2_rxd_delay[0]),
        .DATAIN     (1'b0),
        .C          (1'b0),
        .CE         (1'b0),
        .INC        (1'b0),
        .CINVCTRL   (1'b0),
        .CNTVALUEIN (5'd0),
        .CNTVALUEOUT(),
        .LD         (1'b0),
        .LDPIPEEN   (1'b0),
        .REGRST     (1'b0)
    );

    IDELAYE2 #(
        .IDELAY_TYPE("FIXED")
    ) phy_rxd_idelay_1 (
        .IDATAIN    (phy2_rxd[1]),
        .DATAOUT    (phy2_rxd_delay[1]),
        .DATAIN     (1'b0),
        .C          (1'b0),
        .CE         (1'b0),
        .INC        (1'b0),
        .CINVCTRL   (1'b0),
        .CNTVALUEIN (5'd0),
        .CNTVALUEOUT(),
        .LD         (1'b0),
        .LDPIPEEN   (1'b0),
        .REGRST     (1'b0)
    );

    IDELAYE2 #(
        .IDELAY_TYPE("FIXED")
    ) phy_rxd_idelay_2 (
        .IDATAIN    (phy2_rxd[2]),
        .DATAOUT    (phy2_rxd_delay[2]),
        .DATAIN     (1'b0),
        .C          (1'b0),
        .CE         (1'b0),
        .INC        (1'b0),
        .CINVCTRL   (1'b0),
        .CNTVALUEIN (5'd0),
        .CNTVALUEOUT(),
        .LD         (1'b0),
        .LDPIPEEN   (1'b0),
        .REGRST     (1'b0)
    );

    IDELAYE2 #(
        .IDELAY_TYPE("FIXED")
    ) phy_rxd_idelay_3 (
        .IDATAIN    (phy2_rxd[3]),
        .DATAOUT    (phy2_rxd_delay[3]),
        .DATAIN     (1'b0),
        .C          (1'b0),
        .CE         (1'b0),
        .INC        (1'b0),
        .CINVCTRL   (1'b0),
        .CNTVALUEIN (5'd0),
        .CNTVALUEOUT(),
        .LD         (1'b0),
        .LDPIPEEN   (1'b0),
        .REGRST     (1'b0)
    );

    IDELAYE2 #(
        .IDELAY_TYPE("FIXED")
    ) phy_rx_ctl_idelay (
        .IDATAIN    (phy2_rx_ctl),
        .DATAOUT    (phy2_rx_ctl_delay),
        .DATAIN     (1'b0),
        .C          (1'b0),
        .CE         (1'b0),
        .INC        (1'b0),
        .CINVCTRL   (1'b0),
        .CNTVALUEIN (5'd0),
        .CNTVALUEOUT(),
        .LD         (1'b0),
        .LDPIPEEN   (1'b0),
        .REGRST     (1'b0)
    );
    led_blink #(
        .LED_NUM (1),
        .STS_FREQ(125_000_000)
    ) led0_blink_inst (
        .i_Sys_clk(clk_int),
        .i_Rst_n  (~rst_int),
        .o_led    (led[0])
    );
    led_blink #(
        .LED_NUM (1),
        .STS_FREQ(200_000_000)
    ) led1_blink_inst (
        .i_Sys_clk(clk_200_int),
        .i_Rst_n  (~rst_200_int),
        .o_led    (led[1])
    );

    key #(
        .CLK_FREQ(200_000_000)
    ) key0 (
        .clk_i  (clk_200_int),
        .key_i  (key_in[0]),
        .key_cap(key_cap)
    );
    reg led_flag;
    always @(posedge clk_200_int) begin
        if (rst_200_int) led_flag <= 1'b0;
        else if (key_cap) led_flag <= ~led_flag;
        else led_flag <= led_flag;
    end
    assign led[2] = led_flag;

    gen_testdata_2 #(
        // gen_testdata #(
        .DATA_W(32),
        .SYS_FREQ(200_000_000),
        .AD7380_DIV_FREQ(AD7380_DIV_FREQ),
        .SAMPLE_CNT_MAX(100),
        .PACKET_NUM(100)
    ) gen_testdata_inst (
        .clk       (clk_200_int),
        .rst       (rst_200_int),
        .start_flag(key_cap),
        .data_out  (din_data_func),
        .valid_out (din_valid_func),
        .last_out  (din_last_func)
    );
    udp_top #(
        .TARGET("XILINX"),
        .DATA_W(32)
    ) udp_top_inst (
        // user interface
        .wr_clk  (clk_200_int),
        .wr_rstn (~rst_200_int),
        .rd_clk  (clk_int),
        .rd_rstn (~rst_int),
        .wr_data (din_data_func),
        .wr_valid(din_valid_func),
        .wr_last (din_last_func),
        .wr_ready(),
        .rd_data (dout_data_func),
        .rd_valid(dout_valid_func),
        .rd_last (dout_last_func),
        .rd_ready(1),

        // clock and reset
        .clk  (clk_int),
        .clk90(clk90_int),
        .rst  (rst_int),

        // phy interface
        .phy_rx_clk (phy2_rx_clk),
        .phy_rxd    (phy2_rxd_delay),
        .phy_rx_ctl (phy2_rx_ctl_delay),
        .phy_tx_clk (phy2_tx_clk),
        .phy_txd    (phy2_txd),
        .phy_tx_ctl (phy2_tx_ctl),
        .phy_reset_n(phy2_reset_n)
    );
endmodule

`resetall

// sim/udp_rx_path/tb_udp_rx_path.v
`timescale 1ns / 1ps `default_nettype none

/*
 * Testbench for the udp_rx_path module.
 * This testbench is written in Verilog-2001.
 */
module tb_udp_top;

    // Parameters
    localparam SYS_CLK_PERIOD = 10;  // 100 MHz
    localparam CORE_CLK_PERIOD = 8;  // 125 MHz
    localparam MAX_PAYLOAD_BYTES = 256;
    localparam CLK_PERIOD_125M = 8;  // 125 MHz
    localparam CLK_PERIOD_250M = 4;  // 250 MHz

    // System/Application Clock Domain Signals
    // Core Clock Domain Signals
    reg        clk_250m;
    reg        clk_125m;
    reg        clk_125m_90deg;
    reg        rst_125m;

    wire       phy_rx_clk;
    wire [3:0] phy_rxd;
    wire       phy_rx_ctl;
    wire       phy_tx_clk;
    wire [3:0] phy_txd;
    wire       phy_tx_ctl;
    wire       phy_reset_n;
    reg        start_flag;
    //**********************************************************************************************
    //function
    //**********************************************************************************************
    // Task to initialize all stimulus signals
    task initialize_signals;
        begin
            rst_125m <= 1'b1;
            clk_250m <= 1'b1;
            clk_125m <= 1'b1;
            clk_125m_90deg <= 1'b1;
            start_flag <= 1'b0;
        end
    endtask
    // Task to apply reset to both clock domains
    task reset_dut;
        begin
            $display("[%0t] Applying reset...", $time);
            rst_125m <= 1'b1;
            #(SYS_CLK_PERIOD * 5);
            rst_125m <= 0;
            $display("[%0t] Reset released.", $time);
        end
    endtask
    initial begin
        clk_250m = 1'b1;  // Start with a phase shift
        forever #(CLK_PERIOD_250M / 2) clk_250m = ~clk_250m;
    end
    // initial begin
    //     clk_125m = 1'b1;  // Start with a phase shift
    //     forever #(CLK_PERIOD_125M / 2) clk_125m = ~clk_125m;
    // end
    // 生成相位偏移 90° 的 125 MHz 时钟
    // 这个时钟在第一个时钟上升沿之后延迟 2ns (90度) 翻转
    always @(posedge clk_250m) begin
        #(CLK_PERIOD_125M / 4) clk_125m = ~clk_125m;
    end
    always @(posedge clk_250m) begin
        #(0) clk_125m_90deg = ~clk_125m_90deg;
    end
    //**********************************************************************************************
    //function
    //**********************************************************************************************
    initial begin
        initialize_signals();
        reset_dut();
        #(SYS_CLK_PERIOD * 100) start_flag <= 1'b1;
        @(posedge clk_125m) start_flag <= 1'b0;
    end
    //**********************************************************************************************
    //function
    //**********************************************************************************************

    localparam DATA_W = 32;
    localparam SYS_FREQ = 125_000_0;
    localparam AD7380_DIV_FREQ = 47;
    localparam UPLOAD_RATE = 10;
    reg  [      31:0] cnt_1s = 32'd0;
    reg  [      31:0] cnt = 32'd0;
    wire [DATA_W-1:0] din_data_func;
    wire              din_valid_func;
    wire              din_last_func;
    wire              dout_ready_func;
    wire [DATA_W-1:0] dout_data_func;
    wire              dout_valid_func;
    wire              dout_last_func;
    gen_testdata #(
        .DATA_W(DATA_W),
        .SYS_FREQ(SYS_FREQ),
        .AD7380_DIV_FREQ(AD7380_DIV_FREQ),
        .SAMPLE_CNT_MAX(100)
    ) gen_testdata_inst (
        .clk       (clk_250m),
        .rst       (rst_125m),
        .start_flag(start_flag),
        .data_out  (din_data_func),
        .valid_out (din_valid_func),
        .last_out  (din_last_func)
    );
    udp_top #(
        .TARGET("GENERIC"),
        .DATA_W(DATA_W)
    ) DUT (
        // user interface
        .wr_clk     (clk_250m),
        .wr_rstn    (~rst_125m),
        .rd_clk     (clk_125m),
        .rd_rstn    (~rst_125m),
        .wr_data    (din_data_func),
        .wr_valid   (din_valid_func),
        .wr_last    (din_last_func),
        .wr_ready   (),
        .rd_data    (dout_data_func),
        .rd_valid   (dout_valid_func),
        .rd_last    (dout_last_func),
        .rd_ready   (1),
        // clock and reset
        .clk        (clk_125m),
        .clk90      (clk_125m_90deg),
        .rst        (rst_125m),
        // phy interface
        .phy_rx_clk (phy_rx_clk),
        .phy_rxd    (phy_rxd),
        .phy_rx_ctl (phy_rx_ctl),
        .phy_tx_clk (phy_tx_clk),
        .phy_txd    (phy_txd),
        .phy_tx_ctl (phy_tx_ctl),
        .phy_reset_n(phy_reset_n)
    );

    fpga_core #(
        .TARGET("GENERIC")
    ) TEST_DUT (
        // clock and reset
        .clk        (clk_125m),
        .clk90      (clk_125m_90deg),
        .rst        (rst_125m),
        // phy interface
        .phy_rx_clk (phy_tx_clk),
        .phy_rxd    (phy_txd),
        .phy_rx_ctl (phy_tx_ctl),
        .phy_tx_clk (phy_rx_clk),
        .phy_txd    (phy_rxd),
        .phy_tx_ctl (phy_rx_ctl),
        .phy_reset_n(phy_reset_n)
    );
endmodule

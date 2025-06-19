// sim/sub1-udp_tx_buffer/tb_udp_tx_buffer.v
`timescale 1ns / 1ps `default_nettype none

/*
 * Testbench for the udp_tx_path module.
 *
 * NOTE: This testbench is written in Verilog-2001 to match the DUT.
 *       It avoids SystemVerilog features.
 *
 * NOTE: This testbench requires the 'axis_async_fifo' module, which is a
 *       dependency of udp_tx_path, to be included in the simulation project.
 */
module tb_udp_tx_path;

    // Parameters
    localparam DATA_W = 64;
    localparam SYS_CLK_PERIOD = 8;  // 100 MHz
    localparam CORE_CLK_PERIOD = 8;  // 125 MHz
    localparam MAX_PACKET_WORDS = 16;  // Max words for test packets

    // System/Application Clock Domain Signals
    reg                  sys_clk;
    reg                  sys_rst;
    reg     [DATA_W-1:0] din_data;
    reg                  din_valid;
    reg                  din_last;
    wire                 din_ready;

    // Core Clock Domain Signals
    reg                  clk;
    reg                  rst;
    wire                 tx_udp_hdr_valid;
    reg                  tx_udp_hdr_ready;
    wire    [       5:0] tx_udp_ip_dscp;
    wire    [       1:0] tx_udp_ip_ecn;
    // ... (other header wires)
    wire    [      31:0] tx_udp_ip_dest_ip;
    wire    [      15:0] tx_udp_length;
    wire    [       7:0] tx_udp_payload_axis_tdata;
    wire                 tx_udp_payload_axis_tvalid;
    reg                  tx_udp_payload_axis_tready;
    wire                 tx_udp_payload_axis_tlast;
    wire                 tx_udp_payload_axis_tuser;

    // Configuration
    reg     [      31:0] local_ip;
    reg     [      31:0] dest_ip;
    reg     [      15:0] local_port;
    reg     [      15:0] dest_port;
    localparam SYS_FREQ = 125_0;
    localparam AD7380_DIV_FREQ = 47;
    localparam UPLOAD_RATE = 10;
    reg  [DATA_W-1:0] cnt_1s = {DATA_W{1'b0}};
    reg  [DATA_W-1:0] cnt = {DATA_W{1'b0}};
    reg  [DATA_W-1:0] din_data_func;
    wire        din_valid_func;
    wire        din_last_func;
    // Testbench internal signals
    reg     [DATA_W-1:0] tb_packet_mem              [0:MAX_PACKET_WORDS-1];
    reg                  apply_backpressure;
    integer              byte_count;

    // Instantiate the DUT (Device Under Test)
    udp_tx_path #(
        .DATA_W(DATA_W)
    ) dut (
        // System/Application Clock Domain
        .sys_clk  (sys_clk),
        .sys_rst  (sys_rst),
        .din_data (din_data_func),
        .din_valid(din_valid_func),
        .din_last (din_last_func),
        .din_ready(din_ready),

        // Core Clock Domain
        .clk                       (clk),
        .rst                       (rst),
        .tx_udp_hdr_valid          (tx_udp_hdr_valid),
        .tx_udp_hdr_ready          (tx_udp_hdr_ready),
        .tx_udp_ip_dscp            (tx_udp_ip_dscp),
        .tx_udp_ip_ecn             (tx_udp_ip_ecn),
        .tx_udp_ip_ttl             (),
        .tx_udp_ip_source_ip       (),
        .tx_udp_ip_dest_ip         (tx_udp_ip_dest_ip),
        .tx_udp_source_port        (),
        .tx_udp_dest_port          (),
        .tx_udp_length             (tx_udp_length),
        .tx_udp_checksum           (),
        .tx_udp_payload_axis_tdata (tx_udp_payload_axis_tdata),
        .tx_udp_payload_axis_tvalid(tx_udp_payload_axis_tvalid),
        .tx_udp_payload_axis_tready(tx_udp_payload_axis_tready),
        .tx_udp_payload_axis_tlast (tx_udp_payload_axis_tlast),
        .tx_udp_payload_axis_tuser (tx_udp_payload_axis_tuser),

        // Configuration
        .local_ip  (local_ip),
        .dest_ip   (dest_ip),
        .local_port(local_port),
        .dest_port (dest_port)
    );

    // Clock Generators
    initial begin
        sys_clk = 1'b0;
        forever #(SYS_CLK_PERIOD / 2) sys_clk = ~sys_clk;
    end

    initial begin
        clk = 1'b0;  // Start with a phase shift
        forever #(CORE_CLK_PERIOD / 2) clk = ~clk;
    end

    // Main Test Sequence
    initial begin
        $display("------------------------------------------------------------");
        $display("                    Testbench Started                       ");
        $display("------------------------------------------------------------");

        // Dump waves
        $dumpfile("tb_udp_tx_path.vcd");
        $dumpvars(0, tb_udp_tx_path);

        // Initialize and reset the DUT
        initialize_signals();
        reset_dut();

        // Apply configuration
        local_ip   <= 32'hC0A80164; // 192.168.1.100
        dest_ip    <= 32'hC0A8010A; // 192.168.1.10
        local_port <= 16'd1234;
        dest_port  <= 16'd5678;

        // --- Test Case 1: Send a single-word packet ---
        $display("\n[TC1] Sending a single-word (8-byte) packet...");
        tb_packet_mem[0] = 64'hAABBCCDD_EEFF0011;
        tb_packet_mem[1] = 64'h55AABBCCDD_EEFF00;
        send_app_packet(2, 0);  // Send 1 word, starting at index 0
        wait (dut.tx_state_reg == 2'd0);  // Wait until DUT core FSM is idle
        $display("[TC1] Completed.");

        #(CORE_CLK_PERIOD * 200);

        // --- Test Case 2: Send a multi-word packet ---
        $display("\n[TC2] Sending a multi-word (24-byte) packet...");
        tb_packet_mem[0] = 64'h00010203_04050607;
        tb_packet_mem[1] = 64'h08090A0B_0C0D0E0F;
        // tb_packet_mem[2] = 64'h10111213_14151617;
        send_app_packet(2, 0);  // Send 3 words, starting at index 0
        wait (dut.tx_state_reg == 2'd0);
        $display("[TC2] Completed.");

        #(CORE_CLK_PERIOD * 200);

        // --- Test Case 3: Send packet with backpressure from core ---
        $display("\n[TC3] Sending packet with consumer backpressure...");
        apply_backpressure <= 1'b1;  // Enable backpressure generation

        tb_packet_mem[0] = 64'hDEADBEEF_CAFEBABE;
        tb_packet_mem[1] = 64'h11112222_33334444;
        // tb_packet_mem[2] = 64'h55556666_77778888;
        send_app_packet(2, 0);  // Send 3 words

        wait (dut.tx_state_reg == 2'd0);
        apply_backpressure <= 1'b0;  // Disable backpressure
        $display("[TC3] Completed.");

        #(CORE_CLK_PERIOD * 200);
        $display("\n------------------------------------------------------------");
        $display("                    All Tests Completed                     ");
        $display("------------------------------------------------------------");
        // $finish;
    end

    // Task to initialize all input signals
    task initialize_signals;
        begin
            sys_rst <= 1'b1;
            rst <= 1'b1;
            din_data <= 0;
            din_valid <= 0;
            din_last <= 0;
            tx_udp_hdr_ready <= 1'b1;
            apply_backpressure <= 1'b0;
            local_ip <= 0;
            dest_ip <= 0;
            local_port <= 0;
            dest_port <= 0;
        end
    endtask

    // Task to apply reset to both clock domains
    task reset_dut;
        begin
            $display("[%t] Applying reset...", $time);
            sys_rst <= 1'b1;
            rst <= 1'b1;
            #(SYS_CLK_PERIOD * 5);
            sys_rst <= 0;
            rst <= 0;
            $display("[%t] Reset released.", $time);
        end
    endtask

    // Task to send a data packet from the application side
    task send_app_packet;
        input integer num_words;
        input integer start_index;
        integer i;
        begin
            wait (din_ready);
            @(posedge sys_clk);

            for (i = 0; i < num_words; i = i + 1) begin
                din_valid <= 1'b1;
                din_data  <= tb_packet_mem[start_index+i];
                din_last  <= (i == num_words - 1);
                @(posedge sys_clk);
                din_valid <= 1'b0;
                @(posedge sys_clk);
            end

            din_valid <= 1'b0;
            din_last  <= 1'b0;
            din_data  <= 'x;
        end
    endtask

    // Backpressure generator
    always @(posedge clk) begin
        if (rst) begin
            tx_udp_payload_axis_tready <= 1'b1;
        end else if (apply_backpressure) begin
            if (dut.tx_state_reg == 2'd2) begin  // If in PAYLOAD state
                // Randomly de-assert tready to simulate stuttering
                if ($random % 3 == 0) begin
                    tx_udp_payload_axis_tready <= 1'b0;
                end else begin
                    tx_udp_payload_axis_tready <= 1'b1;
                end
            end else begin
                tx_udp_payload_axis_tready <= 1'b1;  // Be ready for the header
            end
        end else begin
            tx_udp_payload_axis_tready <= 1'b1;  // Always ready when not testing backpressure
        end
    end

    // Core-side consumer model and verifier
    always @(posedge clk) begin
        if (rst) begin
            byte_count <= 0;
        end else begin
            // Monitor and verify header
            if (tx_udp_hdr_valid && tx_udp_hdr_ready) begin
                $display("[%t] [Consumer] UDP Header RX. Dest IP: %h, Total Length: %d", $time, tx_udp_ip_dest_ip, tx_udp_length);
            end

            // Monitor and verify payload
            if (tx_udp_payload_axis_tvalid && tx_udp_payload_axis_tready) begin
                $display("[%t] [Consumer] Payload Byte RX: 0x%h", $time, tx_udp_payload_axis_tdata);
                byte_count <= byte_count + 1;
                if (tx_udp_payload_axis_tlast) begin
                    $display("[%t] [Consumer] Last payload byte RX. Total payload bytes: %d", $time, byte_count + 1);
                    byte_count <= 0;
                end
            end
        end
    end

    //**********************************************************************************************
    //function
    //**********************************************************************************************

    always @(posedge clk) begin
        if (rst) cnt_1s <= 32'd0;
        else if (cnt_1s == SYS_FREQ) cnt_1s <= 0;
        else cnt_1s <= cnt_1s + 1;
    end
    always @(posedge clk) begin
        if (rst) cnt <= 32'd0;
        else if (cnt == AD7380_DIV_FREQ-1) cnt <= 0;
        else cnt <= cnt + 1;
    end
    always @(posedge clk) begin
        if (rst) din_data_func <= 32'd0;
        else if (cnt_1s == SYS_FREQ) din_data_func <= 0;
        else if (din_data_func == UPLOAD_RATE) din_data_func <= din_data_func;
        else if (din_valid_func) din_data_func <= din_data_func + 1;
        else din_data_func <= din_data_func;
    end
    assign din_valid_func = din_data_func<UPLOAD_RATE&& cnt == AD7380_DIV_FREQ-1;
    assign din_last_func  = din_data_func==UPLOAD_RATE-1&& cnt== AD7380_DIV_FREQ-1;
endmodule

`default_nettype wire

// sim/udp_rx_path/tb_udp_rx_path.v
`timescale 1ns / 1ps `default_nettype none

/*
 * Testbench for the udp_rx_path module.
 * This testbench is written in Verilog-2001.
 */
module tb_udp_rx_path;

    // Parameters
    localparam DATA_W = 64;
    localparam SYS_CLK_PERIOD = 10;  // 100 MHz
    localparam CORE_CLK_PERIOD = 8;  // 125 MHz
    localparam MAX_PAYLOAD_BYTES = 256;

    // System/Application Clock Domain Signals
    reg                  sys_clk;
    reg                  sys_rst;
    wire    [DATA_W-1:0] dout_data;
    wire                 dout_valid;
    wire                 dout_last;
    reg                  dout_ready;

    // Core Clock Domain Signals
    reg                  clk;
    reg                  rst;

    // UDP Core Interface (clk domain) - Stimulus
    reg                  rx_udp_hdr_valid;
    reg     [      47:0] rx_udp_eth_dest_mac;
    reg     [      47:0] rx_udp_eth_src_mac;
    reg     [      15:0] rx_udp_eth_type;
    reg     [       3:0] rx_udp_ip_version;
    reg     [       3:0] rx_udp_ip_ihl;
    reg     [       5:0] rx_udp_ip_dscp;
    reg     [       1:0] rx_udp_ip_ecn;
    reg     [      15:0] rx_udp_ip_length;
    reg     [      15:0] rx_udp_ip_identification;
    reg     [       2:0] rx_udp_ip_flags;
    reg     [      12:0] rx_udp_ip_fragment_offset;
    reg     [       7:0] rx_udp_ip_ttl;
    reg     [       7:0] rx_udp_ip_protocol;
    reg     [      15:0] rx_udp_ip_header_checksum;
    reg     [      31:0] rx_udp_ip_source_ip;
    reg     [      31:0] rx_udp_ip_dest_ip;
    reg     [      15:0] rx_udp_source_port;
    reg     [      15:0] rx_udp_dest_port;
    reg     [      15:0] rx_udp_length;
    reg     [      15:0] rx_udp_checksum;
    reg     [       7:0] rx_udp_payload_axis_tdata;
    reg                  rx_udp_payload_axis_tvalid;
    wire                 rx_udp_payload_axis_tready;
    reg                  rx_udp_payload_axis_tlast;
    reg                  rx_udp_payload_axis_tuser;
    wire                 rx_udp_hdr_ready;

    // Metadata output (sys_clk domain)
    wire    [      31:0] m_app_rx_src_ip;
    wire    [      15:0] m_app_rx_src_port;
    wire                 m_app_rx_valid;

    // Configuration
    reg     [      31:0] local_ip;
    reg     [      31:0] dest_ip;
    reg     [      15:0] local_port;
    reg     [      15:0] dest_port;

    // Testbench Internals
    integer              error_count;
    integer              packet_received_count;

    reg                  rx_packet_done;
    reg                  apply_backpressure;

    reg     [       7:0] sent_payload               [0:MAX_PAYLOAD_BYTES-1];
    reg     [       7:0] received_payload           [0:MAX_PAYLOAD_BYTES-1];
    integer              expected_payload_len;
    reg     [      31:0] expected_src_ip;
    reg     [      15:0] expected_src_port;


    // Instantiate the DUT (Device Under Test)
    udp_rx_path #(
        .DATA_W(DATA_W)
    ) dut (
        // System/Application Clock Domain
        .sys_clk   (sys_clk),
        // ... (connections are the same)
        .sys_rst   (sys_rst),
        .dout_data (dout_data),
        .dout_valid(dout_valid),
        .dout_last (dout_last),
        .dout_ready(dout_ready),

        // Core Clock Domain
        .clk(clk),
        .rst(rst),

        // UDP Core Interface (clk domain)
        .rx_udp_hdr_ready          (rx_udp_hdr_ready),
        .rx_udp_hdr_valid          (rx_udp_hdr_valid),
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

        // Metadata output (sys_clk domain)
        .m_app_rx_src_ip  (m_app_rx_src_ip),
        .m_app_rx_src_port(m_app_rx_src_port),
        .m_app_rx_valid   (m_app_rx_valid),

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
        clk = 1'b1;  // Start with a phase shift
        forever #(CORE_CLK_PERIOD / 2) clk = ~clk;
    end

    // Main Test Sequence
    initial begin
        $display("------------------------------------------------------------");
        $display("                    Testbench Started                       ");
        $display("------------------------------------------------------------");

        // Initialize and reset
        initialize_signals();
        reset_dut();

        // Configure DUT to accept packets from 192.168.1.10:5678 to local port 1234
        dest_ip    <= 32'hC0A8010A; // 192.168.1.10
        dest_port  <= 16'd5678;
        local_port <= 16'd1234;
        local_ip   <= 32'hC0A80164; // 192.168.1.100 (DUT's own IP)

        // --- Test Case 1: Send a matching packet ---
        $display("\n[TC1] Sending a matching 32-byte packet...");
        prepare_payload(32);
        send_udp_packet(32, 32'hC0A8010A, 16'd5678, 32'hC0A80164, 16'd1234);
        wait (rx_packet_done);  // Wait for consumer to finish
        verify_packet(1);
        reset_test_state();

        #(SYS_CLK_PERIOD * 20);

        // --- Test Case 2: Send a packet with wrong destination port ---
        $display("\n[TC2] Sending a mismatched packet (wrong dest port)...");
        prepare_payload(16);
        send_udp_packet(16, 32'hC0A8010A, 16'd5678, 32'hC0A80164, 16'd9999);  // Port 9999 should be rejected
        // Packet should be dropped, so rx_packet_done will not be set.
        // We just wait some time to ensure nothing was received.
        #(SYS_CLK_PERIOD * 50);
        verify_packet(0);  // Expect 0 packets received
        reset_test_state();

        #(SYS_CLK_PERIOD * 20);

        // --- Test Case 3: Send a matching packet with consumer backpressure ---
        $display("\n[TC3] Sending a 64-byte packet with consumer backpressure...");
        apply_backpressure = 1'b1;
        prepare_payload(64);
        send_udp_packet(64, 32'hC0A8010A, 16'd5678, 32'hC0A80164, 16'd1234);
        wait (rx_packet_done);
        apply_backpressure = 1'b0;
        verify_packet(1);
        reset_test_state();

        #(SYS_CLK_PERIOD * 20);

        // --- Test Case 4: Send a non-aligned packet ---
        $display("\n[TC4] Sending a non-aligned 27-byte packet...");
        prepare_payload(27);
        send_udp_packet(27, 32'hC0A8010A, 16'd5678, 32'hC0A80164, 16'd1234);
        wait (rx_packet_done);
        verify_packet(1);
        reset_test_state();

        $display("\n------------------------------------------------------------");
        if (error_count == 0) begin
            $display("                    All Tests Passed                        ");
        end else begin
            $display("                    !!! %d Errors Found !!!                 ", error_count);
        end
        $display("------------------------------------------------------------");
        $finish;
    end

    // Task to initialize all stimulus signals
    task initialize_signals;
        begin
            sys_rst <= 1'b1;
            rst <= 1'b1;
            dout_ready <= 1'b1;
            error_count = 0;
            // ... (rest of the initializations)
            rx_udp_hdr_valid <= 1'b0;
            rx_udp_eth_dest_mac <= 0;
            rx_udp_eth_src_mac <= 0;
            rx_udp_eth_type <= 16'h0800;  // IPv4
            rx_udp_ip_version <= 4'd4;
            rx_udp_ip_ihl <= 4'd5;  // 5 words (20 bytes)
            rx_udp_ip_dscp <= 0;
            rx_udp_ip_ecn <= 0;
            rx_udp_ip_length <= 0;
            rx_udp_ip_identification <= 0;
            rx_udp_ip_flags <= 0;
            rx_udp_ip_fragment_offset <= 0;
            rx_udp_ip_ttl <= 64;
            rx_udp_ip_protocol <= 17;  // UDP
            rx_udp_ip_header_checksum <= 0;
            rx_udp_ip_source_ip <= 0;
            rx_udp_ip_dest_ip <= 0;
            rx_udp_source_port <= 0;
            rx_udp_dest_port <= 0;
            rx_udp_length <= 0;
            rx_udp_checksum <= 0;
            rx_udp_payload_axis_tdata <= 0;
            rx_udp_payload_axis_tvalid <= 0;
            rx_udp_payload_axis_tlast <= 0;
            rx_udp_payload_axis_tuser <= 0;

            local_ip <= 0;
            dest_ip <= 0;
            local_port <= 0;
            dest_port <= 0;

            reset_test_state();
        end
    endtask

    task reset_test_state;
        begin
            rx_packet_done <= 1'b0;
            apply_backpressure <= 1'b0;
            expected_payload_len <= 0;
            packet_received_count <= 0;
        end
    endtask

    // Task to apply reset to both clock domains
    task reset_dut;
        begin
            $display("[%0t] Applying reset...", $time);
            sys_rst <= 1'b1;
            rst <= 1'b1;
            #(SYS_CLK_PERIOD * 5);
            sys_rst <= 0;
            rst <= 0;
            $display("[%0t] Reset released.", $time);
        end
    endtask

    // Task to prepare a test payload
    task prepare_payload;
        input integer len;
        integer i;
        begin
            expected_payload_len = len;
            for (i = 0; i < len; i = i + 1) begin
                sent_payload[i] = i % 256;
            end
        end
    endtask

    // Task to send a UDP packet on the core interface
    task send_udp_packet;
        input integer payload_len;
        input [31:0] p_src_ip;
        input [15:0] p_src_port;
        input [31:0] p_dest_ip;
        input [15:0] p_dest_port;
        integer i;
        begin
            // Set expected metadata for the checker
            expected_src_ip   = p_src_ip;
            expected_src_port = p_src_port;
            #(CORE_CLK_PERIOD * 10);
            // 1. Send Header
            @(posedge clk);
            rx_udp_hdr_valid    <= 1'b1;
            rx_udp_ip_source_ip <= p_src_ip;
            rx_udp_ip_dest_ip   <= p_dest_ip;
            rx_udp_source_port  <= p_src_port;
            rx_udp_dest_port    <= p_dest_port;
            rx_udp_ip_length    <= 16'(20 + 8) + payload_len;
            rx_udp_length       <= 16'(8) + payload_len;

            wait (rx_udp_hdr_ready);
            @(posedge clk);
            rx_udp_hdr_valid <= 1'b0;

            // 2. Send Payload
            for (i = 0; i < payload_len; i = i + 1) begin
                rx_udp_payload_axis_tvalid <= 1'b1;
                rx_udp_payload_axis_tdata  <= sent_payload[i];
                rx_udp_payload_axis_tlast  <= (i == payload_len - 1);

                @(posedge clk);
                while (!rx_udp_payload_axis_tready) begin
                    @(posedge clk);
                end
            end

            rx_udp_payload_axis_tvalid <= 1'b0;
            rx_udp_payload_axis_tlast  <= 1'b0;
        end
    endtask

    integer byte_write_ptr;
    // =========================================================================
    // MODIFIED TASK: verify_packet
    // =========================================================================
    task verify_packet;
        input integer expect_reception;
        integer i;
        integer received_len;
        begin
            // Capture final length from consumer logic
            received_len = byte_write_ptr;

            if (expect_reception == 1) begin
                if (packet_received_count == 0) begin
                    $error("[VERIFY] ERROR: Packet was expected but none was received.");
                    error_count = error_count + 1;
                end else begin
                    $display("[VERIFY] Verifying received packet...");
                    // Check length
                    if (received_len != expected_payload_len) begin
                        $error("[VERIFY] Length mismatch. Expected: %d, Got: %d", expected_payload_len, received_len);
                        error_count = error_count + 1;
                    end

                    // Check data
                    for (i = 0; i < expected_payload_len; i = i + 1) begin
                        if (sent_payload[i] != received_payload[i]) begin
                            $error("[VERIFY] Data mismatch at byte %d. Sent: 0x%h, Rcvd: 0x%h", i, sent_payload[i], received_payload[i]);
                            error_count = error_count + 1;
                            // break; // Optional: stop checking after first error
                        end
                    end

                    // Check metadata
                    if (m_app_rx_src_ip != expected_src_ip || m_app_rx_src_port != expected_src_port) begin
                        $error("[VERIFY] Metadata mismatch. Expected IP: %h Port: %d. Got IP: %h Port: %d", expected_src_ip, expected_src_port, m_app_rx_src_ip, m_app_rx_src_port);
                        error_count = error_count + 1;
                    end
                end
            end else begin  // expect_reception == 0
                if (packet_received_count > 0) begin
                    $error("[VERIFY] ERROR: Packet was received but should have been dropped.");
                    error_count = error_count + 1;
                end else begin
                    $display("[VERIFY] Verified that packet was correctly dropped.");
                end
            end
        end
    endtask

    // Consumer Logic
    always @(posedge sys_clk) begin
        // Handle dout_ready for backpressure test
        if (apply_backpressure) begin
            dout_ready <= ($random % 4 != 0);  // Randomly de-assert
        end else begin
            dout_ready <= 1'b1;
        end

        if (sys_rst) begin
            byte_write_ptr <= 0;
        end else if (rx_packet_done) begin  // Reset pointer after packet is processed
            byte_write_ptr <= 0;
        end else if (dout_valid && dout_ready) begin
            // Store received data into a byte array.
            if (byte_write_ptr + 0 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+0] <= dout_data[7:0];
            if (byte_write_ptr + 1 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+1] <= dout_data[15:8];
            if (byte_write_ptr + 2 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+2] <= dout_data[23:16];
            if (byte_write_ptr + 3 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+3] <= dout_data[31:24];
            if (byte_write_ptr + 4 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+4] <= dout_data[39:32];
            if (byte_write_ptr + 5 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+5] <= dout_data[47:40];
            if (byte_write_ptr + 6 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+6] <= dout_data[55:48];
            if (byte_write_ptr + 7 < MAX_PAYLOAD_BYTES) received_payload[byte_write_ptr+7] <= dout_data[63:56];

            // For the last word, only increment by the number of valid bytes
            if (dout_last) begin
                // The DUT doesn't provide the number of valid bytes in the last word,
                // so we rely on the expected length for verification.
                // The consumer logic here will assume full words until the end.
                // The length check in `verify_packet` is what matters.
                byte_write_ptr <= byte_write_ptr + (DATA_W / 8);
            end else begin
                byte_write_ptr <= byte_write_ptr + (DATA_W / 8);
            end
        end
    end

    // Packet reception completion signal
    always @(posedge sys_clk) begin
        if (sys_rst) begin
            rx_packet_done <= 1'b0;
            packet_received_count <= 0;
        end else begin
            if (m_app_rx_valid) begin  // Metadata is the final signal indicating a packet has been processed
                $display("[%0t] [Consumer] Packet metadata received. Src IP: %h, Src Port: %d", $time, m_app_rx_src_ip, m_app_rx_src_port);
                packet_received_count <= packet_received_count + 1;
                rx_packet_done <= 1'b1;
            end else if (rx_packet_done) begin  // Self-clearing
                rx_packet_done <= 1'b0;
            end
        end
    end

endmodule

// ------------------------------------------------------------------------------------------------
// Company                      : Wuhan Guide Sensmart Tech Co., Ltd
// Create Date                  : 20231110
// Author Name                  : zhangjl
// Module Name                  :
// Project Name                 :
// Tarject Device               : Titanium-ti180
// Tool Versions                : Efinity-2022.2.322.5.7
// Description                  : 该文件是
//                              
//                              
//                              
// Parameter Description        : IMAGE_WIDTH-->图像宽度
//                                IMAGE_HEIGHT-->图像高度
// Port Description             :
// Revision                     : 1.00.0000
// Modified by                  :
// Modified Data                :
// Additional Comments          :
// Standard Syndoc              :
// ------------------------------------------------------------------------------------------------
module led_blink #(
    parameter LED_NUM  = 8,
    parameter STS_FREQ = 125_000_000
) (
    //global input interface
    input  wire [     1       - 1 : 0] i_Sys_clk,
    input  wire [     1       - 1 : 0] i_Rst_n,
    output wire [LED_NUM      - 1 : 0] o_led
);  //led_blink
    //**********************************************************************************************
    //parameter and regs defination
    //**********************************************************************************************
    function integer clog2;
        input integer bit_depth;
        begin
            bit_depth = bit_depth - 1;
            for (clog2 = 0; bit_depth > 0; clog2 = clog2 + 1) begin
                bit_depth = bit_depth >> 1;
            end
        end
    endfunction
    reg [     1   - 1 : 0] en_cnt;
    reg [     32  - 1 : 0] cnt;
    reg [LED_NUM  - 1 : 0] led;


    //**********************************************************************************************
    // module1
    //**********************************************************************************************
    always @(posedge i_Sys_clk) begin
        if (~i_Rst_n) begin
            cnt <= 'd0;
        end else if (cnt == STS_FREQ - 'd1) begin
            cnt <= 'd0;
        end else begin
            cnt <= cnt + 'd1;
        end
    end
    //**********************************************************************************************
    always @(posedge i_Sys_clk) begin
        if (~i_Rst_n) begin
            led <= 'd0;
        end else if (cnt == STS_FREQ - 'd1) begin
            led <= led + 'd1;
        end else begin
            led <= led;
        end
    end
    assign o_led = led;
    //**********************************************************************************************
endmodule

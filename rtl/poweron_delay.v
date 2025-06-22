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
// Revision                     : 1.00.0
// Modified by                  :
// Modified Data                :
// Additional Comments          :
// Standard Syndoc              :
// ------------------------------------------------------------------------------------------------
module poweron_delay #(
    parameter SYSCLK_FREQ = 125,//mhz
    parameter DELAY_TIME = 1_000_000//us
) (
    //global input interface
    input  wire [1       - 1 : 0] i_Sys_clk,
    input  wire [1       - 1 : 0] i_Rst_n,
    output wire [1       - 1 : 0] o_Delay_done
);  //poweron_delay
    //**********************************************************************************************
    //parameter and regs defination
    //**********************************************************************************************
    localparam DELAY_TIME_CNT = DELAY_TIME * SYSCLK_FREQ;
    reg [31  - 1 : 0] cnt;

    always @(posedge i_Sys_clk or negedge i_Rst_n) begin
        if (!i_Rst_n) begin
            cnt <= 0;
        end else if (cnt == DELAY_TIME_CNT-1) begin
            cnt <= cnt;
        end else begin
            cnt <= cnt + 1;
        end
    end
    reg delay_done;
    always @(posedge i_Sys_clk or negedge i_Rst_n) begin
        if (!i_Rst_n) begin
            delay_done <= 0;
        end else if (cnt == DELAY_TIME_CNT-1) begin
            delay_done <= 1;
        end else begin
            delay_done <= delay_done;
        end
    end
    assign o_Delay_done = delay_done;

endmodule

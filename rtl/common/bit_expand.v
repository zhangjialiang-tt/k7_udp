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
module bit_expand #(
    parameter EXPAND_LEN = 20
) (
    //global input interface
    input  wire [1       - 1 : 0] i_Sys_clk,
    input  wire [1       - 1 : 0] i_Rst_n,
    input  wire [ 1      - 1 : 0] i_Din,
    output reg [ 1      - 1 : 0] o_Dout
);  //bit_expand
    //**********************************************************************************************
    //parameter and regs defination
    //**********************************************************************************************
    reg  [EXPAND_LEN-1:0] shift_reg_din;
    wire [1       - 1 : 0] delay_din=0;
    always @(posedge i_Sys_clk) begin
        if (~i_Rst_n) begin
            shift_reg_din <= 'd0;
        end else begin
            shift_reg_din <= {shift_reg_din[EXPAND_LEN-1:0], i_Din};
        end
    end
    assign delay_din = shift_reg_din[EXPAND_LEN-1]==1 ? 1 : 0;
    always @(posedge i_Sys_clk) begin
        if (~i_Rst_n) o_Dout <= 'd0;
        else if(shift_reg_din[EXPAND_LEN-1]==1) o_Dout <= 0;
        else if(i_Din) o_Dout <= 1;
        else o_Dout <= o_Dout;
    end
    //**********************************************************************************************
    // reg [ 8  - 1 : 0] din_expand_cnt;
    // wire [1   - 1 : 0] din_pos;
    // reg [1   - 1 : 0] expand_flag;
    // always @(posedge i_Sys_clk) begin
    //     if (~i_Rst_n) begin
    //         din_expand_cnt <= EXPAND_LEN;
    //     end else if (din_pos) begin
    //         din_expand_cnt <= 'd0;
    //     end else if (din_expand_cnt == EXPAND_LEN) begin
    //         din_expand_cnt <= EXPAND_LEN;
    //     end else begin
    //         din_expand_cnt <= din_expand_cnt + 1;
    //     end
    // end
    // capture_edge #(
    //     .EDGE("rising")
    // ) capture_edge_1_inst (
    //     .i_Sys_clk  (i_Sys_clk),
    //     .i_Rst_n    (i_Rst_n),
    //     .i_Din_valid(i_Din),
    //     .o_Dout_edge(din_pos)
    // );
    // always @(posedge i_Sys_clk) begin
    //     if (~i_Rst_n) begin
    //         expand_flag <= 'd0;
    //     end else if (din_expand_cnt < EXPAND_LEN) begin
    //         expand_flag <= 'd1;
    //     end else begin
    //         expand_flag <= 'd0;
    //     end
    // end
    // assign o_Dout = expand_flag;

endmodule

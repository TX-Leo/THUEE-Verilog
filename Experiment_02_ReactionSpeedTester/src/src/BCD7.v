///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: BCD7
// Function: 数码管显示数字
//////////////////////////////////////////////

`timescale 1ns / 1ps

module BCD7 (input [3:0] din,//输入数字
             output [6:0] dout//输出7段码
            );

    reg [6:0] dout;

    always @*begin
        case(din)
        4'h0: dout = 7'b0111111;
        4'h1: dout = 7'b0000110;
        4'h2: dout = 7'b1011011;
        4'h3: dout = 7'b1001111;
        4'h4: dout = 7'b1100110;
        4'h5: dout = 7'b1101101;
        4'h6: dout = 7'b1111101;
        4'h7: dout = 7'b0000111;
        4'h8: dout = 7'b1111111;
        4'h9: dout = 7'b1101111;
        default: dout = 7'b0;
        endcase
    end

endmodule
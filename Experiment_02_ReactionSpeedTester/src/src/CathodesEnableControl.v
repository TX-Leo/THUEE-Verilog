///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: CathodesEnableControl
// Function: 4进制计数器cnt
//////////////////////////////////////////////

`timescale 1ns / 1ps

module CathodesEnableControl(input [1:0] cnt,//4进制计数器
                             output [3:0] AN,//4个数码管使能
                             output point//小数点
                            );

    reg [3:0] AN;
    reg point;

    always @* begin
        case(cnt)
            2'b00: AN = 4'b0001;
            2'b01: AN = 4'b0010;
            2'b10: AN = 4'b0100;
            2'b11: AN = 4'b1000;
        endcase

        case(cnt)
            2'b00: point = 0;
            2'b01: point = 1;//开始亮起第二个数码管时显示小数点
            2'b10: point = 0;
            2'b11: point = 0;
        endcase
    end

endmodule

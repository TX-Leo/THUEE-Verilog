///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: FourHexadecimalCounter
// Function: 4进制计数器cnt
//////////////////////////////////////////////

`timescale 1ns / 1ps

module FourHexadecimalCounter(input clk,//输入时钟
                              input reset,//复位
                              output [1:0] cnt//计数器
                             );

    reg [1:0] cnt;

    always @(posedge reset or posedge clk) begin
        if(reset) begin
            cnt <= 2'b00;
        end
        else begin
            if(cnt == 2'b11) begin
                cnt <= 2'b00;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule

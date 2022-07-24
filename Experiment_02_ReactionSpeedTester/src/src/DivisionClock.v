///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: DivisionClock
// Function: 100MH系统时钟实现10000倍分频为10kHZ
//////////////////////////////////////////////

`timescale 1ns / 1ps

module DivisionClock(input sysclk,//系统时钟
                     input reset,//复位
                     output division_clk//分频时钟
                    );

    reg division_clk;
    reg [12:0] cnt;//计数器（中间变量），用于分频

    always @(posedge reset or posedge sysclk) begin
        if(reset) begin
                cnt <= 13'd0;
                division_clk <= 0;
            end
        else begin
            if(cnt == 13'd4999) begin
                cnt <= 13'd0;
                division_clk <= ~division_clk;
                end
            else begin 
                cnt <= cnt + 1;
            end
        end
    end

endmodule

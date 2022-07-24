///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: ReactionSpeedCount
// Function: 1s后开始测试并计数，更新实时每位应该显示的数字，直到按键了
//////////////////////////////////////////////

`timescale 1ns / 1ps

module ReactionSpeedCount(input clk,//时钟
                          input reset,//复位
                          input start_flag,//开始测试标志
                          input press,//按键输入
                          output [3:0] number0,//输出实时每位应该显示的数字0
                          output [3:0] number1,//输出实时每位应该显示的数字1
                          output [3:0] number2,//输出实时每位应该显示的数字2
                          output [3:0] number3 //输出实时每位应该显示的数字3
                          );


    reg [3:0] number0,number1,number2,number3;
    reg c0,c1,c2;//是否有进位（中间变量）
    reg label;//是否按键了

    always @(posedge reset or posedge clk or posedge press) begin
        if(reset) begin
            number0 <= 4'd0;
            number1 <= 4'd0;
            number2 <= 4'd0;
            number3 <= 4'd0;
            c0 <= 0;
            c1 <= 0;
            c2 <= 0;
            label <= 0;
        end
        else begin
            if(press) begin 
                label <= 1;
            end
            /*若想在1s内按键了会继续进行测试，将上述一行改为：*/
            // if(press) begin
            //     if(start_flag==0) label <= 0;
            //     else label <= 1;
            // end
            else begin
                if((start_flag == 1)&&(label ==0)) begin
                    if(number0 == 4'd9) begin
                        number0 <= 4'd0;
                        c0 <= 1;
                    end
                    else begin
                        number0 <= number0 + 1;
                    end
                    if(c0 == 1) begin
                        if(number1 == 4'd9) begin
                            number1 <= 4'd0;
                            c1 <= 1;
                        end
                        else begin
                            number1 <= number1 + 1;
                        end
                        c0 <= 0;
                    end
                    if(c1 == 1) begin
                        if(number2 == 4'd9) begin
                            number2 <= 4'd0;
                            c2 <= 1;
                        end
                        else begin
                            number2 <= number2 + 1;
                        end
                        c1 <= 0;
                    end
                    if(c2 == 1) begin
                        if(number3 == 4'd9) begin
                            number3 <= 4'd0;
                        end
                        else begin 
                            number3 <= number3 + 1;
                        end
                        c2 <= 0;
                    end
                end
            end
        end
    end

endmodule

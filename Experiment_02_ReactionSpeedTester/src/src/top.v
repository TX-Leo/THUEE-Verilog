///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: Top
// Function:
// （1） 系统复位后，延时 1 秒，点亮某 LED，被测试者观察到 LED 点亮后，立即按动按钮 S2。电路测量自 LED 亮起到按钮按下之间的时间差，并显示在数码管上，按按钮 S4 后，系统复位，并重复上述测试过程。
// （2） 采用全同步设计，即电路中所有触发器的时钟均为系统时钟。
// （3） 采用 4 位七段数码管显示，量程为 0.0ms~999.9ms。
// （4） 报告中给出占用逻辑资源和时序性能。
// （5） 输入输出及管脚绑定
//////////////////////////////////////////////

`timescale 1ns / 1ps

module top(input sysclk,      //系统时钟
           input reset,       //复位
           input press,       //按键输入
           output LED,        //LED显示
           output [3:0] AN,   //数码管使�??
           output [6:0] leds, //7段数码管
           output point);
    
    wire division_clk;//分频时钟
    wire start_flag;//是否测试开始的标志
    wire [3:0] number0,number1,number2,number3;//四位数码管要显示的数字
    wire [1:0] cnt;//四进制计数器
    wire [3:0] number;//要显示的数字
    assign LED = start_flag;//LED的亮与灭
    //忽略vscode里的报错（到vivado里没有错误）
    DivisionClock division_clock (.sysclk(sysclk),.reset(reset),.division_clk(division_clk));//输出clk(10kHZ)
    DelayOneSecond delay_one_second (.sysclk(sysclk),.reset(reset),.start_flag(start_flag));//1秒电路，输出start，1s后start为0
    ReactionSpeedCount reaction_speed_count (.clk(division_clk),.reset(reset),.start_flag(start_flag),.press(press),.number0(number0),.number1(number1),.number2(number2),.number3(number3));//测试开始计时（1khz），输出实时每位应该显示的数字
    FourHexadecimalCounter four_hexadecimalcounter (.clk(division_clk),.reset(reset),.cnt(cnt));//四进制计数器 输出cnt
    CathodesEnableControl cathodes_enable_control (.cnt(cnt),.AN(AN),.point(point));//依据cnt 输出AN和point
    CathodesMultiplexer cathodes_multiplexer (.cnt(cnt),.number0(number0),.number1(number1),.number2(number2),.number3(number3),.number(number));//依据cnt 输出number（number0,1,2,3其中的一个）
    BCD7 bcd7 (number,leds);//out变成7段数码管
    
endmodule
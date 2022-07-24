/*具有异步复位控制的 4bits 二进制同步加法计数器*/
module top (leds,ano,system_clk,clk,reset);
    input system_clk; //产生系统时钟信号
    input clk; //产生时钟信号
    input reset; //产生复位信号
    output ano; //输出使能
    output[6:0] leds; //输出7段码

    wire[3:0] counter; //同步计数器（中间变量
    wire clk_o; //用户时钟（中间变量）
    wire[6:0] leds; //输出7段码

    assign ano = 1;

    synchronous_adder adder(clk , reset , counter);//计数

    BCD7 bcd27seg (counter , leds); //显示数字转换为BCD7
    
    /*防止抖动，system_clk绑定到系统时钟P17 上，clk_i是用户自己的时钟，使用按键实现，使用防抖代码输出的clk_o作为防抖后的时钟使用*/
    debounce xbounce(system_clk , clk , clk_o); 
endmodule
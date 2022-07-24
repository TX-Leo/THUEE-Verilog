//注意代码规范：
//1.变量声明后空行
//2.两模块之间空行
//3.模块名后不留空格
//4.关键字后空格（always case等）
//5.分号向前紧跟
//6.双目运算符前后都要加空格，单目运算符不需要
//7.case在always块内要缩进，case内的每一条也要缩进
//8.begin和end要单独在一行，且不缩进，而且一句话也尽量写begin和end
//9.always if else 要单独占一行
//10.一行代码只干一件事，只写一条语句
//11.注释开始符号与代码之间有空格

/*具有异步复位控制的 4bits二进制同步加法计数器*/
module synchronous_subtractor (an,leds,ano,system_clk,clk,reset);
    input system_clk,clk,reset;
    input[3:0] an;
    output[3:0] ano;
    output[6:0] leds;
    wire[6:0] digi;
    reg[6:0] leds;
    reg[3:0] counter;
    wire clk_o;

    assign ano=an;
    
    always @(*)
    begin
        leds<=digi;
    end
    
    always @(posedge clk_o or negedge reset)
    begin
        if(~reset)
        begin
            counter<=4'b0;
        end
        else if(counter == 4'b0000)
        begin
            counter<=4'b1111;
        end
        else
        begin
            counter<=counter-1;
        end
    end

    BCD7 bcd27seg (counter,digi); //显示数字转换为BCD7码
    debounce xbounce(.clk(system_clk),.key_i(clk),.key_o(clk_o)); //防止抖动
endmodule
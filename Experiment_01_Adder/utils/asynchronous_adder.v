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

/*具有异步复位控制的 4bits 二进制异步加法计数器*/
module asynchronous_adder (an,leds,ano,system_clk,clk,reset);
    input system_clk,clk,reset; //产生系统时钟信号，产生时钟信号，产生复位信号
    input[3:0] an; //输入使能
    output[3:0] ano; //输出使能
    output[6:0] leds; //输出
    wire[6:0] digi; //显示数字
    reg[6:0] leds;
    reg[3:0] counter; //计数器
    wire clk_o; //时钟线

    assign ano = an;
    always @(*)
    begin
        leds <= digi;
    end

    always @(posedge clk_o or negedge reset) //时钟上升沿 or 复位下降沿
    begin
        if(~reset)
        begin
            counter[0] = 1'b0;
        end
        else
        begin
            counter[0] <= ~counter[0];
        end
    end

    always @(negedge counter[0] or negedge reset) //计数器0下降沿 or 复位下降沿
    begin
        if(~reset)
        begin
            counter[1] = 1'b0;
        end
        else
        begin
            counter[1] <= ~counter[1];
        end
    end

    always @(negedge counter[1] or negedge reset) //计数器1下降沿 or 复位下降沿
    begin
        if(~reset)
        begin
            counter[2] = 1'b0;
        end
        else
        begin
            counter[2] <= ~counter[2];
        end
    end

    always @(negedge counter[2] or negedge reset) //计数器2下降沿 or 复位下降沿
    begin
        if(~reset) 
        begin
            counter[3] = 1'b0;
        end
        else
        begin
            counter[3] <= ~counter[3];
        end
    end

    BCD7 bcd27seg (counter,digi);//显示数字转换为BCD7码
    debounce xbounce(.clk(system_clk),.key_i(clk),.key_o(clk_o)); //防止抖动
endmodule
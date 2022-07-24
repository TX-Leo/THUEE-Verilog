/*具有异步复位控制的4bits 二进制同步加法计数器*/
module synchronous_adder (clk,reset,counter);
    input clk; //产生时钟信号
    input reset; //产生复位信号
    output[3:0]  counter; //计数器
    
    reg[3:0] counter; //同步计数器（中间变量

    always @(posedge clk or posedge reset) //时钟上升沿 or 复位上升沿
    begin
        if(reset)
        begin
            counter <= 4'b0000; //复位，重新从0计数
        end
        else
        begin
            if (counter == 4'b10001)
            begin
                counter <= 4'b0000;
            end
            else
            begin
                counter = counter+1; //计数加一
            end
        end
    end
endmodule
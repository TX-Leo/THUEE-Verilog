module state(
    input system_clk, //系统时钟
    input clk, //用户时钟
    input reset, //复位
    input din,//串行数据输入
    output[2:0] leds//状态可视化
    output reg dout//数据输出
    );
    parameter       s0 = 3'b000,
                    s1 = 3'b001,
                    s2 = 3'b010,
                    s3 = 3'b011,
                    s4 = 3'b100,
                    s5 = 3'b101,
                    s6 = 3'b110;//六个状态

    wire clk_o; //用户时钟（中间变量）
    reg [2:0] present_state, next_state;
    reg [2:0] leds;

    //用mealy状态机设计101011序列检测器
    //状态寄存器
    always @(posedge clk_o or posedge reset)
    begin
        if(reset)
            present_state <= s0;
        else
            present_state <= next_state;
    end

    //状态转换模块
    always @(*)
    begin
        case(present_state)
        s0: if(din==1)
                next_state = s1;
            else
                next_state = s0;
        s1: if(din==0)
                next_state = s2;
            else
                next_state = s0;
        s2: if(din==1)
                next_state = s3;
            else
                next_state = s0;
        s3: if(din==0)
                next_state = s4;
            else
                next_state = s1;
        s4: if(din==1)
                next_state = s5;
            else
                next_state = s0;
        s5: if(din==1)
                next_state = s6;
            else
                next_state = s4;
        s6: if(din==0)
                next_state = s2;
            else
                next_state = s1;                
        default: next_state = s0;
        endcase
    end

    //负责逻辑输出
    always @(posedge clk_o or posedge reset)
    begin
        if(reset)
        begin
            leds=present_state;
            dout <= 1'b0;
        end
        else if(present_state == s6)
        begin
            leds=present_state;
            dout <= 1'b1;
        end
        else
        begin
            leds=present_state;
            dout <= 1'b0;
        end
    end

    debounce xbounce(system_clk , clk , clk_o); //防抖
endmodule
module display(reset,
               clk,
               sys_clk,
               choose_1,
               choose_2,
               LED,
               bcd_enable,
               bcd_signal);
    input reset;
    input clk; // controlled by the button
    input sys_clk; // to control the BCD, has nothing to do with the CPU logic
    input choose_1;
    input choose_2;
    
    output [7:0] LED;
    output [3:0] bcd_enable; // 0001,0010,0100,1000
    output [6:0] bcd_signal;
    
    wire clk_o;
    wire clk_for_LED;
    wire [1:0] choose;
    wire [1:0] counter_out; // 00,01,10,11
    wire [31:0] output1;
    wire [31:0] output2;
    wire [31:0] output3;
    wire [31:0] output4;
    wire [31:0] PC;
    
    wire [15:0] low_16bit_out;
    wire [3:0] digit_out; // thousand/hundred/ten/one
    
    assign LED    = PC[7:0];
    assign choose = {choose_1,choose_2};
    assign low_16bit_out = 
    (choose == 2'b00)? output1[15:0] : // $v0
    (choose == 2'b01)? output2[15:0] : // $a0
    (choose == 2'b10)? output3[15:0] : // $sp
    (choose == 2'b11)? output4[15:0] : // $ra
    0;
    
    debounce debounce(
    .clk(sys_clk),
    .key_i(clk),
    .key_o(clk_o)
    );
    
    CPU cpu(
    .clk(clk_o),
    .reset(reset),
    .output1(output1),
    .output2(output2),
    .output3(output3),
    .output4(output4),
    .PC_output(PC)
    );
    
    Counter4 counter4(
    .sys_clk(clk_for_LED),
    .out(counter_out)
    );
    
    Decode2_4 decode2_4(
    .in(counter_out),
    .out(bcd_enable)
    );

    Frequency_Divider frequency_divider(
    .sys_clk(sys_clk),
    .output_clk(clk_for_LED)
    );
    
    // mux to choose the thousand/hundard/ten/one digit
    assign digit_out = 
    (counter_out == 2'b00)? low_16bit_out[15:12] : // $v0
    (counter_out == 2'b01)? low_16bit_out[11:8] : // $a0
    (counter_out == 2'b10)? low_16bit_out[7:4] : // $sp
    (counter_out == 2'b11)? low_16bit_out[3:0] : // $ra
    0;
    
    BCD7 bcd7(
    .din(digit_out),
    .dout(bcd_signal)
    );
    
endmodule

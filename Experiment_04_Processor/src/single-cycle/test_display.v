`timescale 1ns / 1ps
module test_display();
    
    reg reset;
    reg clk;
    reg sys_clk;
    reg choose_1;
    reg choose_2;
    wire [7:0] LED;
    wire [3:0] bcd_enable;
    wire [6:0] bcd_signal;
    
    display display(reset,
                    clk,
                    sys_clk,
                    choose_1,
                    choose_2,
                    LED,
                    bcd_enable,
                    bcd_signal);

    
    initial begin
        reset = 1;
        clk = 0;
        sys_clk = 0;
        #10 reset = 0;
        #10 choose_1 = 0;
        #10 choose_2 = 0;
        forever begin
            #50 sys_clk = ~sys_clk;
        end
    end
    
    
endmodule

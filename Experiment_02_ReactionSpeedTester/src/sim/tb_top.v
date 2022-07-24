`timescale 1ns/1ps
module tb_top;
    parameter PERIOD = 10;
    reg sysclk = 0;
    reg reset = 0;
    reg press = 0;
    wire LED;
    wire [3:0] AN;
    wire [6:0] leds;
    wire point;
    initial begin
        forever begin
            #(PERIOD/2)
            sysclk = ~sysclk;
        end
    end
    initial begin
        sysclk = 1'b1;
        press = 1'b0;
        reset = 1'b0;
        #(100)
        reset = 1'b1;
        #(1)
        reset = 1'b0;
        #(19999)
        press = 1'b1;
        #(1)
        press = 1'b0;
        #(200)
        $finish;
    end

    top u_top(
    .sysclk(sysclk),
    .reset(reset),
    .press(press),

    .LED(LED),
    .AN(AN[3:0]),
    .leds(leds[6:0]),
    .point(point)
    );
endmodule
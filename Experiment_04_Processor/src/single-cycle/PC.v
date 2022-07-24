`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
//
// Create Date: 2021/04/30
// Design Name: SingleCycleCPU
// Module Name: PC
// Project Name: Single-cycle-cpu
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module PC(reset,
          clk,
          PC_i,
          PC_o);
    //Input Clock Signals
    input reset;
    input clk;
    //Input PC
    input [31:0] PC_i;
    //Output PC
    output reg [31:0] PC_o;
    
    initial begin
        PC_o <= 0;
    end
    
    always@(posedge reset or posedge clk)
    begin
        if (reset) begin
            PC_o <= 0;
        end
        else begin
            PC_o <= PC_i;
        end
    end
endmodule

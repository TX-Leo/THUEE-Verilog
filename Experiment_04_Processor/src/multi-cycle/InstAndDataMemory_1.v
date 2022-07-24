`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: InstAndDataMemory
// Project Name: Multi-cycle-cpu
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


module InstAndDataMemory(reset, clk, Address, Write_data, MemRead, MemWrite, Mem_data);
	//Input Clock Signals
	input reset;
	input clk;
	//Input Data Signals
	input [31:0] Address;
	input [31:0] Write_data;
	//Input Control Signals
	input MemRead;
	input MemWrite;
	//Output Data
	output [31:0] Mem_data;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
	parameter RAM_INST_SIZE = 32;
	
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	//read data
	assign Mem_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	//write data
	integer i;
	always @(posedge reset or posedge clk) begin
		if (reset) begin
		    // init instruction memory
            // addi $a0, $zero, 10 # a0 = 0 + 5
            RAM_data[8'd0] <= {6'h08, 5'd0, 5'd4, 16'h5};
            // xor $v0, $zero, $zero # v0 = 0 ^ 0 = 0
            RAM_data[8'd1] <= {6'h00, 5'd0, 5'd0, 5'd2, 5'd0, 6'h26};
            // jal sum # call sum function
            RAM_data[8'd2] <= {6'h03, 26'h4};
            // Loop:
            // beq $zero, $zero, Loop
            RAM_data[8'd3] <= {6'h04, 5'd0, 5'd0, 16'hffff};
            // sum:
            // addi $sp, $sp, -8 # decrement stack pointer
            RAM_data[8'd4] <= {6'h08, 5'd29, 5'd29, 16'hfff8};
            // sw $ra, 4($sp) # store return address
            RAM_data[8'd5] <= {6'h2b, 5'd29, 5'd31, 16'h4};
            // sw $a0, 0($sp) # store a0
            RAM_data[8'd6] <= {6'h2b, 5'd29, 5'd4, 16'h0};
            // slti $t0, $a0, 1 # t0 = (a0 < 1) ? 1 : 0
            RAM_data[8'd7] <= {6'h0a, 5'd4, 5'd8, 16'h1};
            // beq $t0, $zero, L1 # if t0 == 0, jump to L1
            RAM_data[8'd8] <= {6'h04, 5'h8, 5'h0, 16'h2};
            // addi $sp, $sp, 8 # increment stack pointer
            RAM_data[8'd9] <= {6'h08, 5'd29, 5'd29, 16'h0008};
            // jr $ra # return from function
            RAM_data[8'd10] <= {6'h0, 5'd31, 15'h0, 6'h08};
            // L1:
            // add $v0, $a0, $v0 # v0 = a0 + v0
            RAM_data[8'd11] <= {6'h00, 5'd4, 5'd2, 5'd2, 5'd0, 6'h20};
            // addi $a0, $a0, -1 # a0 = a0 - 1
            RAM_data[8'd12] <= {6'h08, 5'd4, 5'd4, 16'hffff};
            // jal sum # call sum function
            RAM_data[8'd13] <= {6'h03, 26'h4};
            // lw $a0, 0($sp) # load a0
            RAM_data[8'd14] <= {6'h23, 5'd29, 5'd4, 16'h0};
            // lw $ra, 4($sp) # load return address
            RAM_data[8'd15] <= {6'h23, 5'd29, 5'd31, 16'h4};
            // addi $sp, $sp, 8 # increment stack pointer
            RAM_data[8'd16] <= {6'h08, 5'd29, 5'd29, 16'h8};
            // add $v0, $a0, $v0 # v0 = a0 + v0
            RAM_data[8'd17] <= {6'h00, 5'd4, 5'd2, 5'd2, 5'd0, 6'h20};
            // jr $ra  # return from function
            RAM_data[8'd18] <= {6'h0, 5'd31, 15'h0, 6'h08};

            //init instruction memory
            //reset data memory		  
			for (i = RAM_INST_SIZE; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
		end else if (MemWrite) begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end

endmodule

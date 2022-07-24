`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
//
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: ALUControl
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


module ALUControl(ALUOp,
                  Funct,
                  ALUConf,
                  Sign);
    //Control Signals
    input [3:0] ALUOp;
    //Inst. Signals
    input [5:0] Funct;
    //Output Control Signals
    output reg [4:0] ALUConf;
    output reg Sign;
    
    //--------------Your code below-----------------------
    // MIPS Functs
    parameter add_fun  = 6'h20;
    parameter addu_fun = 6'h21; //! u
    parameter sub_fun  = 6'h22;
    parameter subu_fun = 6'h23; //! u
    
    parameter and_fun = 6'h24;
    parameter or_fun  = 6'h25;
    parameter xor_fun = 6'h26;
    parameter nor_fun = 6'h27;
    
    parameter sll_fun  = 6'h00;
    parameter srl_fun  = 6'h02;
    parameter sra_fun  = 6'h03;
    parameter slt_fun  = 6'h2a;
    parameter sltu_fun = 6'h2b; //! u
    
    parameter jr_fun   = 6'h08;
    parameter jalr_fun = 6'h09;
    
    // ALUOp
    parameter I1_op    = 3'b000; // I type: lw,sw
    parameter I2_op    = 3'b001; // I type: beq
    parameter R_op     = 3'b010; // R type
    parameter and_op   = 3'b011; // andi
    parameter slt_op   = 3'b100; // slti, sltiu
    parameter addiu_op = 3'b101;
    
    // ALUConf signal
    parameter and_ctrl = 5'b00000; // &
    parameter or_ctrl  = 5'b00001; // |
    parameter add_ctrl = 5'b00010; // +
    parameter sub_ctrl = 5'b00110; // -
    parameter slt_ctrl = 5'b00111; // set on less than
    parameter nor_ctrl = 5'b01000; // nor
    parameter xor_ctrl = 5'b01001; // xor
    parameter sll_ctrl = 5'b01010; // <<
    parameter srl_ctrl = 5'b10000; // >>
    parameter sra_ctrl = 5'b10001; // >>(a)
    
    // parameter setsub_ctrl = 5'b11010;
    
    // step 1: to decide the signed & unsigned
    always @(*) begin
        case(ALUOp[3])
            1'b0:Sign <= 1;
            1'b1:Sign <= 0;
        endcase
        if (ALUOp[2:0] == 3'b010) begin
            case(Funct)
                addu_fun: Sign <= 0;
                subu_fun: Sign <= 0;
                sltu_fun: Sign <= 0;
                default: Sign  <= 1;
            endcase
        end
    end
    
    
    // step 2: generate ALUConf according to Funct
    always @(*) begin
        if (ALUOp == 3'b010) begin // R type, decide the ALUConf by Funct
            case(Funct)
                add_fun:ALUConf  <= add_ctrl;
                addu_fun:ALUConf <= add_ctrl;
                sub_fun:ALUConf  <= sub_ctrl;
                subu_fun:ALUConf <= sub_ctrl;
                
                and_fun:ALUConf <= and_ctrl;
                or_fun:ALUConf  <= or_ctrl;
                xor_fun:ALUConf <= xor_ctrl;
                nor_fun:ALUConf <= nor_ctrl;
                
                slt_fun:ALUConf  <= slt_ctrl;
                sltu_fun:ALUConf <= slt_ctrl;
                sll_fun:ALUConf  <= sll_ctrl;
                srl_fun:ALUConf  <= srl_ctrl;
                sra_fun:ALUConf  <= sra_ctrl;
            endcase
        end
        else if (ALUOp == 3'b000) // use add
            ALUConf <= add_ctrl;
        else if (ALUOp == 3'b001) // use sub
            ALUConf <= sub_ctrl;
        else if (ALUOp == 3'b011) // use and
            ALUConf <= and_ctrl;
        else if (ALUOp == 3'b100) // use slt
            ALUConf <= slt_ctrl;
        else
            ALUConf <= add_ctrl;
    end
    
    //--------------Your code above-----------------------
    
endmodule

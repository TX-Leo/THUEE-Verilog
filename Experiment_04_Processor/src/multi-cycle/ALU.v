`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
//
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: ALU
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


module ALU(ALUConf,
           Sign,
           in1,
           in2,
           Zero,
           Result);
    // Control Signals
    input [4:0] ALUConf;
    input Sign;
    // Input Data Signals
    input [31:0] in1;
    input [31:0] in2;
    // Result put
    output Zero;
    output reg [31:0] Result;
    
    // ALUCtrl signal
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
    
    assign Zero = (Result == 0); // when Result  is 0, zero is 1
    
    // IMPORTANT! although the signed and unsigned settings has different results in +,-,&,|..., but they share the same representations
    // However, when it comes to slt and sra, they will produce different result performance
    always @(*) begin
        case(ALUConf)
            and_ctrl: Result <= in1 & in2;
            or_ctrl: Result  <= in1 | in2;
            add_ctrl: Result <= in1 + in2;
            sub_ctrl: Result <= in1 - in2;
            slt_ctrl: begin
                if (Sign) begin //signed
                    case({in1[31],in2[31]}) // to compare according to the sign bit
                        2'b01: Result <= 0;
                        2'b10: Result <= 1;
                        2'b00: Result <= (in1<in2);
                        2'b11: Result <= (in1[30:0]<in2[30:0]);
                    endcase
                end
                else // unsigned
                Result <= (in1 < in2);
            end
            nor_ctrl: Result <= ~(in1 | in2);
            xor_ctrl: Result <= (in1 ^ in2);
            sll_ctrl: Result <= (in2 << in1);
            srl_ctrl: Result <= (in2 >> in1);
            // important!! if you want to add shamt options, you should load the last 16 bits and get the shamt[10:6]
            sra_ctrl: Result <= ({{32{in2[31]}}, in2} >> in1); // the highst bit is always same as signal-bit
            // when it comes to unsigned numbers, sra_ctrl may get wrong answers
            // see: https://chortle.ccsu.edu/AssemblyTutorial/Chapter-14/ass14_14.html
            default: Result <= 0;
        endcase
    end
    // Your code above
    
endmodule

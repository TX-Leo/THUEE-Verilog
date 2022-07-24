`timescale 1ns / 1ps
module ALU(in1,
           in2,
           ALUCtrl,
           Sign,
           out,
           zero);
    input [31:0] in1, in2;
    input [4:0] ALUCtrl;
    input Sign;
    output reg [31:0] out;
    output zero;
    
    // Your code below
    
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
    
    assign zero = (out == 0); // when out is 0, zero is 1
    
    // IMPORTANT! although the signed and unsigned settings has different results in +,-,&,|..., but they share the same representations
    // However, when it comes to slt and sra, they will produce different result performance
    always @(*) begin
        case(ALUCtrl)
            and_ctrl: out <= in1 & in2;
            or_ctrl: out  <= in1 | in2;
            add_ctrl: out <= in1 + in2;
            sub_ctrl: out <= in1 - in2;
            slt_ctrl: begin
                if (Sign) begin //signed
                    case({in1[31],in2[31]}) // to compare according to the sign bit
                        2'b01: out <= 0;
                        2'b10: out <= 1;
                        2'b00: out <= (in1<in2);
                        2'b11: out <= (in1[30:0]<in2[30:0]);
                    endcase
                end
                else // unsigned
                out <= (in1 < in2);
            end
            nor_ctrl: out <= ~(in1 | in2);
            xor_ctrl: out <= (in1 ^ in2);
            sll_ctrl: out <= (in2 << in1);
            srl_ctrl: out <= (in2 >> in1);
            // important!! if you want to add shamt options, you should load the last 16 bits and get the shamt[10:6]
            sra_ctrl: out <= ({{32{in2[31]}}, in2} >> in1); // the highst bit is always same as signal-bit
            // when it comes to unsigned numbers, sra_ctrl may get wrong answers
            // see: https://chortle.ccsu.edu/AssemblyTutorial/Chapter-14/ass14_14.html
            default: out <= 0;
        endcase
    end
    // Your code above
    
endmodule

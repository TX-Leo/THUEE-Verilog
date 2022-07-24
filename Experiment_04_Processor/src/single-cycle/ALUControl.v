`timescale 1ns / 1ps
module ALUControl(OpCode,
                  Funct,
                  ALUCtrl,
                  Sign);
    input [5:0] OpCode;
    input [5:0] Funct;
    output reg [4:0] ALUCtrl;
    output reg Sign;
    
    // Your code below
    
    reg [2:0] ALUOp;
    
    // MIPS Opcodes
    parameter lw_op  = 6'h23; // load word(I)
    parameter sw_op  = 6'h2b; // save word(I)
    parameter lui_op = 6'h0f; // load upper 16 bits of immediate(I)
    
    parameter add_op   = 6'h00; // add(R)
    parameter addu_op  = 6'h00; // add unsigned #! u(R)
    parameter sub_op   = 6'h00; // sub(R)
    parameter subu_op  = 6'h00; // sub unsigned #! u(R)
    parameter addi_op  = 6'h08; // add immediate(I)
    parameter addiu_op = 6'h09; // add immediate unsigned #! u(I)
    
    parameter and_op   = 6'h00; // and(R)
    parameter or_op    = 6'h00; // or(R)
    parameter xor_op   = 6'h00; // xor(R)
    parameter nor_op   = 6'h00; // nor(R)
    parameter andi_op  = 6'h0c; // and immediate(I)
    parameter sll_op   = 6'h00; // shift left logical(R)
    parameter srl_op   = 6'h00; // shift right logical(R)
    parameter sra_op   = 6'h00; // shift right algorithm(R)
    parameter slt_op   = 6'h00; // set on less than(R)
    parameter sltu_op  = 6'h00; // set on less than unsigned #! u(R)
    parameter slti_op  = 6'h0a; // set on less than immediate(I)
    parameter sltiu_op = 6'h0b; // set on less than immediate unsigned #! u(I)
    
    parameter beq_op  = 6'h04; // branch equal(I)
    parameter j_op    = 6'h02; // jump(J)
    parameter jal_op  = 6'h03; // jump and link(J)
    parameter jr_op   = 6'h00; // jump register(R)
    parameter jalr_op = 6'h00; // (R)
    
    
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
    parameter I1_op = 3'b000; // I type: lw,sw
    parameter I2_op = 3'b001; // I type: beq
    parameter R_op  = 3'b010; // R type
    
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
    
    // parameter setsub_ctrl = 5'b11010;
    
    // to decide the signed & unsigned
    // I & R type
    always @(*) begin
        case(OpCode)
            addiu_op: Sign <= 0;
            sltiu_op: Sign <= 0;
            default: Sign  <= 1;
        endcase
        if (OpCode == 6'h00) begin
            case(Funct)
                addu_fun: Sign <= 0;
                subu_fun: Sign <= 0;
                sltu_fun: Sign <= 0;
                default: Sign  <= 1;
            endcase
        end
    end
    
    // step 1: generate ALUop according to OpCode
    always @(*) begin
        case(OpCode)
            lw_op: ALUOp   <= 3'b000;
            sw_op: ALUOp   <= 3'b000;
            lui_op: ALUOp  <= 3'b000;
            addi_op: ALUOp <= 3'b000;
            addiu_op:ALUOp <= 3'b000;
            andi_op: ALUOp <= 3'b011;
            slti_op: ALUOp <= 3'b100;
            sltiu_op:ALUOp <= 3'b100;
            beq_op: ALUOp  <= 3'b001;
            default: ALUOp <= 3'b010;
        endcase
    end
    
    // step 2: generate ALUCtrl according to Funct
    always @(*) begin
        if (ALUOp == 3'b010) begin
            case(Funct)
                add_fun:ALUCtrl  <= add_ctrl;
                addu_fun:ALUCtrl <= add_ctrl;
                sub_fun:ALUCtrl  <= sub_ctrl;
                subu_fun:ALUCtrl <= sub_ctrl;
                
                and_fun:ALUCtrl <= and_ctrl;
                or_fun:ALUCtrl  <= or_ctrl;
                xor_fun:ALUCtrl <= xor_ctrl;
                nor_fun:ALUCtrl <= nor_ctrl;
                
                slt_fun:ALUCtrl <= slt_ctrl;
                sltu_fun:ALUCtrl <= slt_ctrl;
                sll_fun:ALUCtrl <= sll_ctrl;
                srl_fun:ALUCtrl <= srl_ctrl;
                sra_fun:ALUCtrl <= sra_ctrl;

                default:ALUCtrl <= add_ctrl;
            endcase
        end
        else if (ALUOp == 3'b000) // use add
            ALUCtrl <= add_ctrl;
        else if (ALUOp == 3'b001) // use sub
            ALUCtrl <= sub_ctrl;
        else if (ALUOp == 3'b011) // use and
            ALUCtrl <= and_ctrl;
        else if (ALUOp == 3'b100) // use slt
            ALUCtrl <= slt_ctrl;
        else
            ALUCtrl <= add_ctrl;
    end
    
    // Your code above
    
endmodule

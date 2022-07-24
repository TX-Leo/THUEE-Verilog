`timescale 1ns / 1ps
module Control(OpCode,
               Funct,
               PCSrc,
               Branch,
               RegWrite,
               RegDst,
               MemRead,
               MemWrite,
               MemtoReg,
               ALUSrc1,
               ALUSrc2,
               ExtOp,
               LuOp);
    input [5:0] OpCode;
    input [5:0] Funct;
    output reg [1:0] PCSrc;
    output reg Branch;
    output reg RegWrite;
    output reg [1:0] RegDst;
    output reg MemRead;
    output reg MemWrite;
    output reg [1:0] MemtoReg;
    output reg ALUSrc1;
    output reg ALUSrc2;
    output reg ExtOp;
    output reg LuOp;
    
    // Your code below
    
    // MIPS Opcodes
    parameter lw_op  = 6'h23; // load word(I)
    parameter sw_op  = 6'h2b; // save word(I)
    parameter lui_op = 6'h0f; // load upper 16 bits of immediate(I)
    
    parameter addi_op  = 6'h08; // add immediate(I)
    parameter addiu_op = 6'h09; // add immediate unsigned #! u(I)
    
    parameter andi_op  = 6'h0c; // and immediate(I)
    parameter slti_op  = 6'h0a; // set on less than immediate(I)
    parameter sltiu_op = 6'h0b; // set on less than immediate unsigned #! u(I)
    
    parameter beq_op = 6'h04; // branch equal(I)
    parameter j_op   = 6'h02; // jump(J)
    parameter jal_op = 6'h03; // jump and link(J)
    
    parameter R_op = 6'h00; // represent for all R-types
    
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
    
    initial begin
        PCSrc    <= 0;
        Branch   <= 0;
        RegWrite <= 0;
        RegDst   <= 0;
        MemRead  <= 0;
        MemWrite <= 0;
        MemtoReg <= 0;
        ALUSrc1  <= 0;
        ALUSrc2  <= 0;
        ExtOp    <= 0;
        LuOp     <= 0;
    end
    
    always @(*) begin
        // PCSrc
        case(OpCode)
            j_op,jal_op: begin
                PCSrc <= 2'b01;
            end
            
            R_op: begin
                case(Funct)
                    jr_fun,jalr_fun:begin
                        PCSrc <= 2'b10;
                    end
                    default:begin
                        PCSrc <= 2'b00;
                    end
                endcase
            end
            
            default: begin
                PCSrc <= 2'b00;
            end
        endcase
        
        // Branch
        case(OpCode)
            beq_op:begin
                Branch <= 1'b1;
            end
            
            default:begin
                Branch <= 1'b0;
            end
        endcase
        
        // RegWrite
        case(OpCode)
            sw_op,beq_op,j_op:begin
                RegWrite <= 0;
            end
            
            R_op:begin
                case(Funct)
                    jr_fun:begin
                        RegWrite <= 0;
                    end
                    default:begin
                        RegWrite <= 1;
                    end
                endcase
            end
            
            default:begin
                RegWrite <= 1;
            end
        endcase
        
        // RegDst
        case(OpCode)
            R_op:begin
                case(Funct)
                    jalr_fun:begin
                        RegDst <= 2'b10;
                    end
                    default:begin
                        RegDst <= 2'b01;
                    end
                endcase
            end
            
            jal_op:begin
                RegDst <= 2'b10;
            end
            
            default:begin
                RegDst <= 2'b00;
            end
        endcase
        
        // MemRead
        case(OpCode)
            lw_op:begin
                MemRead <= 1;
            end
            
            default:begin
                MemRead <= 0;
            end
        endcase
        
        // MemWrite
        case(OpCode)
            sw_op:begin
                MemWrite <= 1;
            end
            
            default:begin
                MemWrite <= 0;
            end
        endcase
        
        // MemtoReg
        case(OpCode)
            lw_op:begin
                MemtoReg <= 2'b01;
            end
            
            jal_op:begin
                MemtoReg <= 2'b10;
            end
            
            R_op:begin
                case(Funct)
                    jalr_fun:begin
                        MemtoReg <= 2'b10;
                    end
                    default:begin
                        MemtoReg <= 2'b00;
                    end
                endcase
            end
            
            default:begin
                MemtoReg <= 2'b00;
            end
        endcase
        
        // ALUSrc1
        case(OpCode)
            R_op:begin
                case(Funct)
                    sll_fun,srl_fun,sra_fun:begin
                        ALUSrc1 <= 1;
                    end
                    default:begin
                        ALUSrc1 <= 0;
                    end
                endcase
            end
            
            default:begin
                ALUSrc1 <= 0;
            end
        endcase
        
        // ALUSrc2
        case(OpCode)
            R_op,beq_op:begin
                ALUSrc2 <= 0;
            end
            
            default:begin
                ALUSrc2 <= 1;
            end
        endcase
        
        // ExtOp
        case(OpCode)
            andi_op:begin
                ExtOp <= 0;
            end
            
            default:begin
                ExtOp <= 1;
            end
        endcase
        
        // LuOp
        case(OpCode)
            lui_op:begin
                LuOp <= 1;
            end
            
            default:begin
                LuOp <= 0;
            end
        endcase
    end
    // Your code above
endmodule

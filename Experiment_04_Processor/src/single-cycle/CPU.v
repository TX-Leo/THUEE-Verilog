module CPU(reset,
           clk,
           output1,
           output2,
           output3,
           output4,
           PC_output);
    input reset, clk;
    output [31:0] output1, output2, output3, output4;
    output [31:0] PC_output;
    
    //--------------Your code below-----------------------

    // PC
    wire [31:0] PC_i ;
    wire [31:0] PC_o;

    PC pc(
    .reset(reset),
    .clk(clk),
    .PC_i(PC_i),
    .PC_o(PC_o)
    );
    // TODO: PC_Write useful in single cycle?
    
    // instruction memory
    wire [31:0] Instruction;
    InstructionMemory instructionmemory(
    .Address(PC_o),
    .Instruction(Instruction)
    );
    
    // select the instruction type
    wire [5:0] OpCode;
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [4:0] Rd;
    wire [4:0] Shamt;
    wire [5:0] Funct;
    wire [15:0] Immediate;
    wire [26:0] Address;
    
    assign OpCode = Instruction[31:26];
    assign Rs    = Instruction[25:21];
    assign Rt    = Instruction[20:16];
    assign Rd    = Instruction[15:11];
    assign Shamt = Instruction[10:6];
    assign Funct = Instruction[5:0];
    assign Immediate = Instruction[15:0];
    assign Address = Instruction[25:0];
    
    // controller
    wire [1:0] PCSrc;
    wire Branch;
    wire regWrite;
    wire [1:0] regDst;
    wire MemRead;
    wire MemWrite;
    wire [1:0] Memtoreg;
    wire ALUSrc1;
    wire ALUSrc2;
    wire ExtOp;
    wire LuOp;
    Control control(
    .OpCode(OpCode),
    .Funct(Funct),
    .PCSrc(PCSrc),
    .Branch(Branch),
    .RegWrite(regWrite),
    .RegDst(regDst),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(Memtoreg),
    .ALUSrc1(ALUSrc1),
    .ALUSrc2(ALUSrc2),
    .ExtOp(ExtOp),
    .LuOp(LuOp)
    );
    
    // * Mux of PC
    // ! the adder of PC(PC <= PC + 4)
    // ! the adder of PC(PC <= PC + 4 + {SignExt(imm16),2b00})
    wire Zero;
    wire [31:0] ImmExtOut;
    wire [31:0] ImmExtShift;
    wire [31:0] Read_data1, Read_data2;

    wire [31:0] PC_default_next; 
    assign PC_default_next = PC_o + 4;

    assign PC_i = 
        (PCSrc == 2'b01) ? {PC_default_next[31:28], Address, 2'b00} :
        (PCSrc == 2'b10) ? Read_data1 :
        (Branch & Zero) ? PC_default_next + ImmExtShift:
        PC_default_next;

    
    // * Mux of wire source
    wire [4:0] Read_register1, Read_register2, Write_register;
    wire [31:0] Write_register_data;
    assign Read_register1 = Rs;
    assign Read_register2 = Rt;

    assign Write_register = 
        (regDst == 2'b00) ? Rt :
        (regDst == 2'b01) ? Rd :
        5'b11111;
    
    // register file
    RegisterFile registerfile(
    .reset(reset),
    .clk(clk),
    .RegWrite(regWrite),
    .Read_register1(Read_register1),
    .Read_register2(Read_register2),
    .Write_register(Write_register),
    .Write_data(Write_register_data),
    .Read_data1(Read_data1),
    .Read_data2(Read_data2)
    );
    
    // immediate extension
    // ! it can directly generate the imm32 and left shift it
    ImmProcess immprocess(
    .ExtOp(ExtOp),
    .LuiOp(LuOp),
    .Immediate(Immediate),
    .ImmExtOut(ImmExtOut),
    .ImmExtShift(ImmExtShift)
    );
    
    
    // * Mux of imm or wire
    wire [31:0] in1;
    wire [31:0] in2;

    assign in1 = 
        (ALUSrc1 == 1'b0) ? Read_data1 :
        Shamt;
    assign in2 = 
        (ALUSrc2 == 1'b0) ? Read_data2 :
        ImmExtOut;
    
    // ALU controller
    wire [4:0] ALUCtrl;
    wire Sign;
    ALUControl alucontrol(
    .OpCode(OpCode),
    .Funct(Funct),
    .ALUCtrl(ALUCtrl),
    .Sign(Sign)
    );
    
    // ALU
    wire [31:0] Out;
    
    ALU alu(
    .ALUCtrl(ALUCtrl),
    .in1(in1),
    .in2(in2),
    .Sign(Sign),
    .out(Out),
    .zero(Zero)
    );
    
    // data memory
    wire [31:0] Read_data;
    DataMemory datamemory(
    .reset(reset),
    .clk(clk),
    .Address(Out),
    .Write_data(Read_data2),
    .Read_data(Read_data),
    .MemRead(MemRead),
    .MemWrite(MemWrite)
    );
    
    // * Mux of ALU or mem
    assign Write_register_data = 
        (Memtoreg == 2'b00) ? Out :
        (Memtoreg == 2'b01) ? Read_data :
        PC_default_next;

    // output
    assign output1=registerfile.RF_data[2]; // $v0
    assign output2=registerfile.RF_data[4]; // $a0
    assign output3=registerfile.RF_data[29]; // $sp
    assign output4=registerfile.RF_data[31]; // $ra
    assign PC_output=PC_o; // low 8 bits of PC
    
    //--------------Your code above-----------------------
    
endmodule
    

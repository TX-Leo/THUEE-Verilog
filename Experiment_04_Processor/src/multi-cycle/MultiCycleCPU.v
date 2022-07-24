`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
//
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: MultiCycleCPU
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

module MultiCycleCPU (reset,
                      clk,
                      output1,
                      output2,
                      output3,
                      output4,
                      PC_output);
    //Input Clock Signals
    input reset;
    input clk;
    output [31:0] output1, output2, output3, output4;
    output [31:0] PC_output;
    
    //--------------Your code below-----------------------
    
    // Controller
    wire [5:0] OpCode;
    wire [4:0] Rs;
    wire [4:0] Rt;
    wire [4:0] Rd;
    wire [4:0] Shamt;
    wire [5:0] Funct;
    wire [15:0] Immediate;
    wire [26:0] Address_j;
    
    wire [1:0] PCSrc;
    wire [3:0] ALUOp;
    wire PCWrite;
    wire PCWrite_with_cond;
    wire PCWriteCond;
    wire RegWrite;
    wire IorD;
    wire IRWrite;
    wire [1:0] RegDst;
    wire MemRead;
    wire MemWrite;
    wire [1:0] MemtoReg;
    wire [1:0] ALUSrc1;
    wire [1:0] ALUSrc2;
    wire ExtOp;
    wire LuiOp;
    
    Controller controller(
    .reset(reset),
    .clk(clk),
    .OpCode(OpCode),
    .Funct(Funct),
    .PCWrite(PCWrite),
    .PCWriteCond(PCWriteCond),
    .IorD(IorD),
    .IRWrite(IRWrite),
    .PCSource(PCSrc),
    .RegWrite(RegWrite),
    .RegDst(RegDst),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ALUSrcA(ALUSrc1),
    .ALUSrcB(ALUSrc2),
    .ALUOp(ALUOp),
    .ExtOp(ExtOp),
    .LuiOp(LuiOp)
    );
    
    // PC
    wire [31:0] PC_i;
    wire [31:0] PC_o;
    PC Pc(
    .reset(reset),
    .clk(clk),
    .PCWrite(PCWrite_with_cond),
    .PC_i(PC_i),
    .PC_o(PC_o)
    );
    
    wire [31:0] Address;
    wire [31:0] Write_data;
    wire [31:0] Mem_data;
    wire [31:0] ALUOut;
    wire [31:0] ALUOut_register_data;
    
    // * Mux of choose Data or Instruction in memory
    assign Address = 
    (IorD == 1'b0)? PC_o :
    ALUOut_register_data;
    
    // memory
    InstAndDataMemory Instanddatamemory(
    .reset(reset),
    .clk(clk),
    .Address(Address),
    .Write_data(Write_data),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Mem_data(Mem_data)
    );
    
    // instruction register
    InstReg Instreg(
    .reset(reset),
    .clk(clk),
    .IRWrite(IRWrite),
    .Instruction(Mem_data),
    .OpCode(OpCode),
    .rs(Rs),
    .rt(Rt),
    .rd(Rd),
    .Shamt(Shamt),
    .Funct(Funct)
    );
    
    
    assign Immediate = {Rd[4:0], Shamt[4:0], Funct[5:0]};
    assign Address_j = {Rs[4:0], Rt[4:0], Immediate[15:0]};
    
    // memory data register
    wire [31:0] Data;
    RegTemp Memory_data_register(
    .reset(reset),
    .clk(clk),
    .Data_i(Mem_data),
    .Data_o(Data)
    );
    
    // * Mux of wire source
    wire [31:0] Read_data1, Read_data2;
    wire [4:0] Read_register1, Read_register2, Write_register;
    assign Read_register1 = Rs;
    assign Read_register2 = Rt;
    
    assign Write_register = 
    (RegDst == 2'b00)? Rt:
    (RegDst == 2'b01)? Rd:
    5'b11111; // $ra
    
    // * Mux of write data source
    wire [31:0] Write_register_data;
    assign Write_register_data = 
    (MemtoReg == 2'b00)? Data:
    (MemtoReg == 2'b01)? ALUOut_register_data:
    PC_o;
    
    wire [31:0] ImmExtOut;
    wire [31:0] ImmExtShift;
    
    // immediate extension
    ImmProcess Immprocess(
    .ExtOp(ExtOp),
    .LuiOp(LuiOp),
    .Immediate(Immediate),
    .ImmExtOut(ImmExtOut),
    .ImmExtShift(ImmExtShift)
    );
    
    
    // register file
    RegisterFile Registerfile(
    .reset(reset),
    .clk(clk),
    .RegWrite(RegWrite),
    .Read_register1(Read_register1),
    .Read_register2(Read_register2),
    .Write_register(Write_register),
    .Write_data(Write_register_data),
    .Read_data1(Read_data1),
    .Read_data2(Read_data2)
    );
    
    //? register of Read Data1(A) and Read Data2(B)
    wire [31:0] Read_register_data1;
    wire [31:0] Read_register_data2;
    
    RegTemp Read_data_1_Register(.reset(reset), .clk(clk), .Data_i(Read_data1), .Data_o(Read_register_data1));
    RegTemp Read_data_2_Register(.reset(reset), .clk(clk), .Data_i(Read_data2), .Data_o(Read_register_data2));
    assign Write_data = Read_register_data2;
    
    // ALU controller
    wire [4:0] ALUConf;
    wire Sign;
    ALUControl AluControl(
    .ALUOp(ALUOp),
    .Funct(Funct),
    .ALUConf(ALUConf),
    .Sign(Sign)
    );
    
    wire [31:0] in1;
    wire [31:0] in2;
    
    // * Mux of ALU in1
    assign in1 = 
    (ALUSrc1 == 2'b00)? PC_o:
    (ALUSrc1 == 2'b10)? Shamt:
    Read_register_data1;
    
    // * Mux of ALU in2
    assign in2 = 
    (ALUSrc2 == 2'b00)? Read_register_data2:
    (ALUSrc2 == 2'b01)? 32'h4:
    (ALUSrc2 == 2'b10)? ImmExtOut:
    ImmExtShift;
    
    // ALU
    wire Zero;
    ALU ALU(
    .ALUConf(ALUConf),
    .Sign(Sign),
    .in1(in1),
    .in2(in2),
    .Zero(Zero),
    .Result(ALUOut)
    );
    
    //? register of ALUOut
    RegTemp ALU_register(
    reset, clk, ALUOut, ALUOut_register_data
    );
    
    
    // * Mux of PC
    // TODO do not understand the logic
    assign PC_i = 
    (PCSrc == 2'b00)? ALUOut:
    (PCSrc == 2'b01)? ALUOut_register_data:
    (PCSrc == 2'b10)? {PC_o[31:28],Address_j,2'b00}:
    Read_register_data1;
    
    // generate control signal of PC
    assign PCWrite_with_cond = 
    ((Zero && PCWriteCond)||PCWrite)? 1'b1:
    1'b0;

    assign output1=Registerfile.RF_data[2];
    assign output2=Registerfile.RF_data[4];
    assign output3=Registerfile.RF_data[29];
    assign output4=Registerfile.RF_data[31];
    assign PC_output=PC_o;
    
    //--------------Your code above-----------------------
endmodule

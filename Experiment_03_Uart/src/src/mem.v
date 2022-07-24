`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 16:20:23
// Design Name: 
// Module Name: mem
// Project Name: 
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


module mem
#(parameter MEM_SIZE = 512)
(
    input clk,
    input [15:0] addr,
    input rd_en,
    input wr_en,
    output reg [31:0] rdata,
    input [31:0] wdata
    );
    
    
    reg [31:0] memData [MEM_SIZE:1];

    
    always@(posedge clk)begin
     begin
            if(wr_en) memData[addr] <= wdata;
            if(rd_en)  rdata <=  memData[addr];
            else rdata<= 32'd0; 
        end
    end

endmodule

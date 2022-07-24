///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: CathodesMultiplexer
// Function: 选择显示哪个数码管
//////////////////////////////////////////////

`timescale 1ns / 1ps

module CathodesMultiplexer (input [1:0] cnt,
                            input [3:0] number0,
                            input [3:0] number1,
                            input [3:0] number2,
                            input [3:0] number3,
                            output [3:0] number
                            );

    reg [3:0] number;

    always @* begin
        case(cnt)
            2'b00: number = number0;
            2'b01: number = number1;
            2'b10: number = number2;
            2'b11: number = number3;
        endcase
    end

endmodule

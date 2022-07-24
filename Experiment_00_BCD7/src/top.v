module top (an, bcd, ano, leds);
input [3:0] an;
input [3:0] bcd;
output [3:0] ano;
output [6:0] leds;

wire [6:0] leds;

assign ano=an;
//assign leds=~digi;

BCD7 bcd27seg (bcd,leds);

endmodule
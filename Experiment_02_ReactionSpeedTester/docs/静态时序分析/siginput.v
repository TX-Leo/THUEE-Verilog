module siginput(
 input [1:0] testmode,//00,01,10,11分别代表4种频率，分别�?3125�?6250�?50�?12500Hz，使用SW1~SW0来控�?
 input sysclk,//系统时钟100M
 output sigin1//输出待测信号
 );
reg[20:0] state;
reg[20:0] divide;
reg sigin;
assign sigin1=sigin;
always@(*)
begin
case(testmode[1:0])
2'b00:divide=21'd32000;//3125Hz,分频比为32000
2'b01:divide=21'd16000;//6250Hz，分频比�?16000
2'b10:divide=21'd2000000;//50Hz,分频比为2000000
2'b11:divide=21'd8000;//12500Hz，分频比�?8000
endcase
end
always@(posedge sysclk)//按divide分频
begin
if(state==0)
sigin=~sigin;
state=state+21'd2;
if(state==divide)
state=21'b0;
end
endmodule

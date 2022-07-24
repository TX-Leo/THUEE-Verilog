module ShiftRegister
(
    input system_clk,
    input clk,
    input reset, 
    input din,
    output wire dout,
    output[5:0] q
);
    reg [5:0] q;
    wire clk_o; //用户时钟（中间变量）
    assign dout = (q == 6'b101011) ? 1'b1:1'b0;
    
    always @ (posedge clk or posedge reset)
    if(reset))
        q <= 6'd0;
    else
        q <= {q[4:0],din};
    
    debounce xbounce(system_clk , clk , clk_o); //防抖
endmodule 
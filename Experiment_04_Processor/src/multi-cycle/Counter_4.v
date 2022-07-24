module Counter4 (sys_clk,
                 out);
    input wire sys_clk;
    output reg [1:0] out;
    
    initial begin
        out <= 0;
    end
    
    always @(posedge sys_clk) begin
        if (out == 3) begin
            out <= 0;
        end
        else begin
            out <= out + 1;
        end
    end
endmodule //counter4

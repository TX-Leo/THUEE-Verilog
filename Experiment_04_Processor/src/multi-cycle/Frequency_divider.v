module Frequency_Divider(sys_clk,
                         output_clk);
    input sys_clk;
    output reg output_clk;
    
    parameter divide = 10000;
    reg [13:0] count;
    initial begin
        output_clk <= 0;
    end
    
    always @(posedge sys_clk) begin
        if (count < divide/2 -1) begin
            count      <= count + 1;
            output_clk <= output_clk;
        end
        else begin
            count      <= 14'd0;
            output_clk <= ~output_clk;
        end
    end
    
endmodule

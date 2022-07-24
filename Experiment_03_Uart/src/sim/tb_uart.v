`timescale 1ns / 1ps
`define PERIOD 10  //100MHz

module TbUart();
    reg clk;     
    reg rst;     
    reg mem2uart; 
    wire recv_done; 
    wire send_done;   
    reg Rx_Serial;
    wire Tx_Serial;

    UART_MEM uart_mem(.clk(clk),
                      .rst(rst),
                      .mem2uart(mem2uart),
                      .recv_done(recv_done),
                      .send_done(send_done),
                      .Rx_Serial(Rx_Serial),
                      .Tx_Serial(Tx_Serial)
                      );

    initial begin
    forever
        #(`PERIOD/2)  
            clk = ~clk;
    end

    initial 
    begin
        clk = 1'b0;
        rst = 1'b1;
        mem2uart = 1'b0;
        Rx_Serial = 1'b1;
        #(`PERIOD*10)
            rst = 1'b0;
    end

    integer i,j;
    initial
    begin
        for(i = 0;i < 4096;i = i + 1)  
        begin  
            Rx_Serial = 1'b0;
            #(`PERIOD*21);
            for(j = 0;j < 8;j = j + 1)  
            begin
                Rx_Serial = {$random} % 2;
                #(`PERIOD*21);
            end
            Rx_Serial = 1'b1;
            #(`PERIOD*21);
        end
        #(`PERIOD*100)
            mem2uart = 1'b1;
        #(`PERIOD*1000000);
        $finish;
    end

endmodule
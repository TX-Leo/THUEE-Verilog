///////////////////////////////////////////////
// Author:TX-Leo
// Target Devices: XILINX xc7A35TCSG324-1
// Tool Versions: Vivado 2019.2
// Create Date: 2022/04/25
// Project Name: ReactionSpeedTester
// Description: It's TX-Leo's Experiment_02
// Module Name: DivisionClock
// Function: cnt计数，数到100000000（100MHZ）则开始测试标志start_flag变为1
//////////////////////////////////////////////

`timescale 1ns / 1ps

module DelayOneSecond(input sysclk,//系统时钟
                      input reset,   //复位         
                      output start_flag//开始测试标志
                    );

    reg start_flag;
    reg [26:0] cnt;//计数（中间变量），数到100000000（100MHZ）则开始测试标志start_flag变为1
    /*若想自定义延时（精确到0.1s，0-10s）*/
    //举例：delay=({$random} % 100)/10;
    always @(posedge reset or posedge sysclk) begin
        if(reset) begin 
            cnt <= 27'd0;
            start_flag <= 0;
        end
        else begin
            if(cnt == 27'd99999999) begin
            start_flag <= 1;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule
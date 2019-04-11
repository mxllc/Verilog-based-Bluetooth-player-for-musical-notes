`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/17 18:45:38
// Design Name: 
// Module Name: uart_clkdiv
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


module uart_clkdiv(clk,clk_out,rst);
    input clk,rst;
    output reg clk_out;

    parameter Baud_Rate=9600; //波特率
    localparam div_num='d100_000_000/Baud_Rate; //分频数为时钟速率除以波特率, 板子频率100M
//     localparam div_num='d10_000_000/Baud_Rate;

    reg[15:0]num;

    always@(posedge clk)
    	if(num==div_num)begin
    		num<=0;
    		clk_out<=1;
    	end
    	else begin
    		num<=num+1;
    		clk_out<=0;
    	end
endmodule

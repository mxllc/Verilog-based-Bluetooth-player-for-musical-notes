`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/20 08:41:32
// Design Name: 
// Module Name: Divider
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


module Divider #(parameter times=20)(I_CLK,Rst,O_CLK);

    input I_CLK,Rst;
    output O_CLK;
    reg temp=1'b0;
    
    localparam tmp_times=times/2;
    
    assign O_CLK=temp;
    
    integer cnt=0;
    
    always @(posedge I_CLK)
    begin
       if(Rst==1'b1)
       begin
           cnt<=0;
           temp<=1'b0;
       end
       else
       begin
           if(cnt==tmp_times-1)
           begin
               temp<=~temp;
               cnt<=0;
           end
           else
               cnt<=cnt+1;  
       end
    end
       

endmodule

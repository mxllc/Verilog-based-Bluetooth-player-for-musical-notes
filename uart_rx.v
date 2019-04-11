`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/17 18:44:18
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(rxd,clk,rx_ack,bdata,rx_begin);
    input rxd,clk;
    output reg [7:0] bdata;
    output rx_ack;
    output rx_begin;
    
    //串口接收状态机分为三个状态：等待、接收、接收完成
    localparam IDLE=0,
           RECEIVE=1,
           RECEIVE_END=2;

    reg [3:0]cur_st,nxt_st; //状态机变量
    reg [4:0]count;

    wire neg_clk;
    assign neg_clk=clk;

    always@(posedge clk)
      cur_st<=nxt_st;

    always@(*)
    begin
        nxt_st=cur_st;
      case(cur_st)
        IDLE: if(!rxd)nxt_st=RECEIVE; //接收到开始信号，开始接收数据
        RECEIVE: if(count==7)nxt_st=RECEIVE_END; //八位数据接收计数
        RECEIVE_END: nxt_st=IDLE; //接收完成
        default: nxt_st=IDLE;
      endcase
    end
    
    
    
    
    always@(posedge neg_clk)
      if(cur_st ==RECEIVE)
        count<=count+1; //接收数据计数
      else if(cur_st==IDLE || cur_st==RECEIVE_END)
        count<=0;

    always@(posedge neg_clk)
      if(cur_st==RECEIVE)
      begin
        bdata[6:0]<=bdata[7:1]; //调试串口 从低位到高位 发送数据
        bdata[7]<=rxd;
      end
      
    assign rx_begin=(cur_st ==RECEIVE)?1'b1:1'b0;
    assign rx_ack=(cur_st==RECEIVE_END)?1'b1:1'b0; //接收完成时回复信号

endmodule

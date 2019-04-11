`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 09:29:59
// Design Name: 
// Module Name: TotalTop
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

module Top_Controller 
  (

   input                                        rst,
   input                                        clk,
   input                                        rxd,
   output                                       txd,
   input                                        music_play,
   input                                        bluetooth_receive,
   
   
   output [7:0]test_data,
   output  idle,
   output  do,
   
   input  st,//开始、暂停信号 1开始 0暂停
   input  ena,//使能信号 1可以使用，0不显示
   output [7:0] oSel,//板子上选择8个中的哪些显示 7为最高位
   output [6:0] oData,//选择输出的数字
   input time_rst,
   input back,
   output playout,
   output [4:0]symbol
   
   
   );


  ShowTime stime(.clk(clk),.rst(time_rst),.st(st),.ena(ena),.oSel(oSel),.oData(oData),.back(back));


  localparam    IDLE=0,
                DATA_IN_REQUIRE_WAIT=1,
                DATA_IN_REQUIRE_PRE=2,
                DATA_IN_REQUIRE=3,
                DATA_IN_END=4,
                DATA_OUT=5,
                DATA_OUT_END=6;
                
                


   reg [3:0]cur_st,nxt_st;



//test signal
    assign idle=(cur_st==IDLE)?1:0;
    assign do=(cur_st==DATA_OUT)?1:0;

    
    
    

    reg [7:0]pdata;//play
    wire[7:0]bdata;//bluetooth
    assign symbol=pdata[4:0];

wire clk_9600;
uart_clkdiv uc(.clk(clk),.clk_out(clk_9600),.rst(rst));
uart_rx ur(.rxd(rxd),.clk(clk_9600),.rx_ack(rx_ack),.bdata(bdata),.rx_begin(rx_begin));
assign test_data=bdata;
wire clk_play;
Divider #(50_000_000) s0(.I_CLK(clk),.Rst(rst),.O_CLK(clk_play));//一秒2个音符

Play pl(.clk(clk),.sw(pdata[4:0]),.rst(rst),.out(playout));


always@(posedge clk or posedge rst)
    if(rst)
        cur_st<=0;
    else cur_st<=nxt_st;

wire neg_clk;
assign neg_clk=~clk;

reg[5:0]icount;//数据计数
reg[6:0]ocount;//数据计数
reg [7:0]ram[63:0];

//次态改变
always@(*)begin
    nxt_st=cur_st;
    case(cur_st)
        IDLE:if(music_play)   nxt_st=DATA_OUT;
            else if(bluetooth_receive) nxt_st=DATA_IN_REQUIRE_WAIT;

        DATA_IN_REQUIRE_WAIT:if(!bluetooth_receive)nxt_st=IDLE;
            else if(rx_begin) nxt_st=DATA_IN_REQUIRE_PRE;

        DATA_IN_REQUIRE_PRE:if(rx_ack)nxt_st=DATA_IN_REQUIRE;

        DATA_IN_REQUIRE:nxt_st=DATA_IN_END;

        DATA_OUT: if(ocount==64)nxt_st=DATA_OUT_END;
            else if(!music_play) nxt_st=IDLE;
        DATA_IN_END: nxt_st=DATA_IN_REQUIRE_WAIT;

        DATA_OUT_END:nxt_st=IDLE;

        default:nxt_st=IDLE;  
    endcase    
end



    always@(posedge neg_clk or posedge rst)
        if(rst)
            icount<=0;
        else if(cur_st== DATA_IN_END) begin
            icount<=icount+1;
        end
        else if(cur_st==IDLE)
            icount<=0;

    always@(posedge clk_play or posedge rst)
        if(rst)
            ocount<=0;
        else if(cur_st== DATA_OUT) 
            ocount<=ocount+1;
        else if(cur_st==IDLE)
            ocount<=0;

    integer rst_cnt;
    always@(posedge neg_clk or posedge rst)
    if(rst)begin
        for(rst_cnt=0;rst_cnt<=63;rst_cnt=rst_cnt+1)
         ram[rst_cnt]<=8'H0; //reset ram
     end
    else if(cur_st== DATA_IN_REQUIRE) 
        ram[icount]<=bdata;
    else if(cur_st==IDLE)
      rst_cnt<=0;
    

    always@(posedge clk_play or posedge rst)
    if(rst)
        pdata<=8'H0;
    else if(cur_st== DATA_OUT) 
        pdata<=ram[ocount];
    else if(cur_st== IDLE)
        pdata<=8'H0;
        
endmodule

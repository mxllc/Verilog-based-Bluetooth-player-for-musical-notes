`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/11 11:55:38
// Design Name: 
// Module Name: ShowTime
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


module ShowTime(clk,rst,st,ena,oSel,oData,back);
    input clk;//板子的时钟频率
    input rst;//复位信号 在ena有效下 1表示复位，显示00:00
    input st;//开始、暂停信号 1开始 0暂停
    input ena;//使能信号 1可以使用，0不显示
    output [7:0] oSel;//板子上选择8个中的哪些显示 7为最高位
    output [6:0] oData;//选择输出的数字
    input back;//倒计时
    reg [2:0] iSel=3'b000;
    reg [3:0] iData;
    wire ShowFrequence;//1秒1次的频率
    SingleDisplay7 sd7(.iData(iData),.iSel(iSel),.ena(ena),.oData(oData),.oSel(oSel));
    Divider #(100000000) dir(.I_CLK(clk),.Rst(rst),.O_CLK(ShowFrequence));//100000000
    
    wire clk_refresh;//8个位置刷新频率
    Divider #(100000) dirrf(.I_CLK(clk),.Rst(rst),.O_CLK(clk_refresh)); //   10KHz   for a refresh frequency of about 1 KHz to 60Hz

    reg [3:0] sec_h=4'b0000, sec_l=4'b0000, min_h=4'b0000, min_l=4'b0000, hor_h=4'b0000, hor_l=4'b0000;

    always @(posedge ShowFrequence or posedge rst)
    begin
        if(rst)
        begin
            sec_l<=4'b0000;
            sec_h<=4'b0000;
            min_l<=4'b0000;
            min_h<=4'b0000;
            hor_l<=4'b0000;
            hor_h<=4'b0000;         
        end
        else if(st)//开始计时信号
        begin
        if(!back)begin
            if(sec_l==4'b1001)//秒的低位=9
            begin
                sec_l<=4'b0000;
                if(sec_h==4'b0101)//秒的高位=5
                begin
                    sec_h<=4'b0000;

                    if(min_l==4'b1001)//分的低位=9
                    begin
                        min_l<=4'b0000;
                        if(min_h==4'b0101)//分的高位=5
                        begin
                            min_h<=4'b0000;

                            if(hor_h==4'b0010)//时的高位=2
                            begin
                                if(hor_l==4'b0011)//时的低位=3
                                begin
                                    hor_h<=4'b0000;
                                    hor_l<=4'b0000;
                                end
                                else
                                    hor_l<=hor_l+4'b0001;
                            end
                            else//时的高位=0,1
                            begin
                                if(hor_l==4'b1001)//时的低位=9
                                begin
                                    hor_h<=hor_h+4'b0001;
                                    hor_l<=4'b0000;
                                end
                                else
                                    hor_l<=hor_l+4'b0001;
                            end
                        end
                        else
                        min_h<=min_h+4'b0001;
                    end
                    else
                    min_l<=min_l+4'b0001;
                end
                else
                    sec_h<=sec_h+4'b0001;
            end
            else
                sec_l<=sec_l+4'b0001;
        end
        else begin
            if(sec_l==4'b0000)//秒的低位=0
            begin
                sec_l<=4'b1001;
                if(sec_h==4'b0000)//秒的高位=0
                begin
                    sec_h<=4'b0101;

                    if(min_l==4'b0000)//分的低位=0
                    begin
                        min_l<=4'b1001;
                        if(min_h==4'b0000)//分的高位=0
                        begin
                            min_h<=4'b0101;

                            if(hor_h==4'b0000)//时的高位=0
                            begin
                                if(hor_l==4'b0000)//时的低位=0
                                begin
                                    hor_h<=4'b0010;
                                    hor_l<=4'b0011;
                                end
                                else
                                    hor_l<=hor_l-4'b0001;
                            end
                            else//时的高位=2,1
                            begin
                                if(hor_l==4'b0000)//时的低位=0
                                begin
                                    hor_h<=hor_h-4'b0001;
                                    hor_l<=4'b0000;
                                end
                                else
                                    hor_l<=hor_l-4'b0001;
                            end
                        end
                        else
                        min_h<=min_h-4'b0001;
                    end
                    else
                    min_l<=min_l-4'b0001;
                end
                else
                    sec_h<=sec_h-4'b0001;
            end
            else
                sec_l<=sec_l-4'b0001;
        end

        end
    end



    //延时效应显示每一位(6位)
    reg [2:0]cnt=3'b000;
    always@(posedge clk_refresh)
    begin
      case(cnt)
            3'b000:
            begin
                iData<=sec_l;
                cnt<=cnt+3'b001;
            end
            3'b001:
            begin
                iData<=sec_h;
                cnt<=cnt+3'b010;
            end
            3'b011: 
            begin
                iData<=min_l;
                cnt<=cnt+3'b001;
            end
            3'b100:
            begin
                iData<=min_h;
                cnt<=cnt+3'b010;
            end
            3'b110:
            begin
                iData<=hor_l;
                cnt<=cnt+3'b001;
            end
            3'b111:
            begin
                iData<=hor_h;
                cnt<=3'b000;
            end
            default:cnt<=3'b000;
            endcase   
            iSel<=cnt;    
    end
endmodule

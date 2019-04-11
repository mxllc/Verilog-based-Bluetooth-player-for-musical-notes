`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/26 15:40:33
// Design Name: 
// Module Name: Play
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


module Play(
input clk,
input [4:0]sw,
input rst,
output out

    );
    localparam l_do=339_732,
               l_ri=302_668,
               l_mi=269_560,
               l_fa=258_666,
               l_so=253_334,
               l_la=201_866,
               l_si=179_998,
               
               m_do=169_866,
               m_ri=156_534,
               m_mi=134_666,
               m_fa=125_600,
               m_so=113_334,
               m_la=101_006,
               m_si=88_000,
               
               h_do=85_066,
               h_ri=73_866,
               h_mi=66_134,
               h_fa=62_134,
               h_so=55_466,
               h_la=49_333,
               h_si=44_000,
               
               stop=266;
    reg [4:0]cnt;
    always@(posedge clk)
        case(sw)
        5'd0:cnt<=5'd0;
        5'd1:cnt<=5'd1;
        5'd2:cnt<=5'd2;
        5'd3:cnt<=5'd3;
        5'd4:cnt<=5'd4;
        5'd5:cnt<=5'd5;
        5'd6:cnt<=5'd6;
        5'd7:cnt<=5'd7;
        5'd8:cnt<=5'd8;
        5'd9:cnt<=5'd9;
        5'd10:cnt<=5'd10;
        5'd11:cnt<=5'd11;
        5'd12:cnt<=5'd12;
        5'd13:cnt<=5'd13;
        5'd14:cnt<=5'd14;
        5'd15:cnt<=5'd15;
        5'd16:cnt<=5'd16;
        5'd17:cnt<=5'd17;
        5'd18:cnt<=5'd18;
        5'd19:cnt<=5'd19;
        5'd20:cnt<=5'd20;
        5'd21:cnt<=5'd21;                                
        default:cnt<=5'd0;
        endcase
    assign out=mclk[cnt];
    wire mclk[21:0];
    Divider #(stop) s0(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[0]));
    
    Divider #(l_do) l1(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[1]));
    Divider #(l_ri) l2(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[2]));
    Divider #(l_mi) l3(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[3]));
    Divider #(l_fa) l4(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[4]));
    Divider #(l_so) l5(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[5]));
    Divider #(l_la) l6(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[6]));
    Divider #(l_si) l7(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[7]));
    
    Divider #(m_do) m1(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[8]));
    Divider #(m_ri) m2(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[9]));
    Divider #(m_mi) m3(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[10]));
    Divider #(m_fa) m4(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[11]));
    Divider #(m_so) m5(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[12]));
    Divider #(m_la) m6(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[13]));
    Divider #(m_si) m7(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[14]));
    
    Divider #(h_do) h1(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[15]));
    Divider #(h_ri) h2(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[16]));
    Divider #(h_mi) h3(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[17]));
    Divider #(h_fa) h4(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[18]));
    Divider #(h_so) h5(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[19]));
    Divider #(h_la) h6(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[20]));
    Divider #(h_si) h7(.I_CLK(clk),.Rst(rst),.O_CLK(mclk[21]));
    
    
endmodule

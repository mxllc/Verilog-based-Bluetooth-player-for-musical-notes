`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/11 12:12:02
// Design Name: 
// Module Name: SingleDisplay7
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


module SingleDisplay7(iData,iSel,ena,oData,oSel);
    input [3:0] iData;
    input [2:0] iSel;
    input ena;
    output [6:0] oData;
    output [7:0] oSel;
    
    //选择位置
    assign oSel[7]=~(ena & iSel[2] & iSel[1] & iSel[0]);
    assign oSel[6]=~(ena & iSel[2] & iSel[1] & (~iSel[0]));
    assign oSel[5]=~(ena & iSel[2] & (~iSel[1]) & iSel[0]);
    assign oSel[4]=~(ena & iSel[2] & (~iSel[1]) & (~iSel[0]));
    assign oSel[3]=~(ena & (~iSel[2]) & iSel[1] & iSel[0]);
    assign oSel[2]=~(ena & (~iSel[2]) & iSel[1] & (~iSel[0]));
    assign oSel[1]=~(ena & (~iSel[2]) & (~iSel[1]) & iSel[0]);
    assign oSel[0]=~(ena & (~iSel[2]) & (~iSel[1]) & (~iSel[0]));
    
    //选择数字
    display7 di7 (.iData(iData),.oData(oData));
endmodule

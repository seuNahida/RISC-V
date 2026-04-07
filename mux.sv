`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/02 22:16:26
// Design Name: 
// Module Name: mux#
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


module mux#(
    parameter DATAWIDTH = 32
)(
    input logic[DATAWIDTH - 1 : 0] A,
    input logic[DATAWIDTH - 1 : 0] B,
    input logic control,
    output logic[DATAWIDTH -1 : 0] Result
    );

    assign Result = control ? B : A;
endmodule

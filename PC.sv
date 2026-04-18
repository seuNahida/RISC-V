`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/02 22:16:26
// Design Name: 
// Module Name: pc#
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


module pc#(
    parameter DATAWIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic ena,
    input logic[DATAWIDTH - 1 : 0] npc,
    output logic[DATAWIDTH - 1 : 0] pc_out 
    );

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            pc_out <= 32'h80000000;
        end
        else begin
            if(ena) pc_out <= npc;
        end
    end
endmodule

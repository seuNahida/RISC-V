`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 16:53:09
// Design Name: 
// Module Name: pc_control
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


module pc_control #(
    parameter DATAWIDTH = 32
)(
    input logic[DATAWIDTH - 1 : 0] npc_b,
    input logic[DATAWIDTH - 1 : 0] npc_j,
    input logic[DATAWIDTH - 1 : 0] npc_n,
    input logic [1:0] pcflag,
    output logic [DATAWIDTH - 1 : 0] npc
);

    always_comb begin
        case(pcflag)
            2'b10: npc = npc_b;
            2'b01: npc = npc_j;
            2'b00: npc = npc_n;
            default: npc = npc_n;
        endcase
    end
endmodule

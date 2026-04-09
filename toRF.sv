`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 19:08:39
// Design Name: 
// Module Name: toRF
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


module toRF #(
    parameter DATAWIDTH = 32
)(
    input logic[1:0] RegWriteSrc,
    input logic[DATAWIDTH - 1 : 0] npc_n,
    input logic[DATAWIDTH - 1 : 0] alu_result,
    input logic[DATAWIDTH - 1 : 0] dm_result,
    input logic[DATAWIDTH - 1 : 0] imm,
    output logic[DATAWIDTH - 1 : 0] result
);

    always_comb begin
        case(RegWriteSrc)
            2'b00: result = alu_result;
            2'b01: result = dm_result;
            2'b10: result = npc_n;
            2'b11: result = imm;
            default: result = 32'bX;
        endcase
    end
endmodule

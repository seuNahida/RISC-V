`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 18:41:58
// Design Name: 
// Module Name: branch_control
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


module branch_control (
    input logic [2:0] branch,
    input logic N,
    input logic V,
    input logic Z,
    input logic C,
    output logic branch_flag
    );

    always_comb begin
        branch_flag = 0;
        case(branch)
            3'b000: if(Z) branch_flag = 1'b1;
            3'b001: if(!Z) branch_flag = 1'b1;
            3'b100: if(N ^ V) branch_flag = 1'b1;
            3'b101: if(!(N ^ V)) branch_flag = 1'b1;
            3'b110: if(C) branch_flag = 1'b1;
            3'b111: if(!C) branch_flag = 1'b1;
            3'b010: branch_flag = 1'b1;
            3'b011: branch_flag = 1'b0;
            default: branch_flag = 1'b0;
        endcase
    end
endmodule

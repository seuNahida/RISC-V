`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 20:27:42
// Design Name: 
// Module Name: word_ex
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


module word_ex #(
    parameter DATAWIDTH = 32
)(
    input logic[3:0] funct,
    input logic [DATAWIDTH - 1 : 0] out_temp,
    output logic [DATAWIDTH - 1 : 0] out
);

    always_comb begin
        case(funct)
            3'b010: out = out_temp;
            3'b001: out = {{16{out_temp[15]}}, out_temp[15:0]};
            3'b101: out = {16'b0, out_temp[15:0]};
            3'b000: out = {{24{out_temp[7]}}, out_temp[7:0]};
            3'b100: out = {24'b0, out_temp[7:0]};
            default: out = out_temp;
        endcase
    end
endmodule

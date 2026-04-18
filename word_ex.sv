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
    input logic[2:0] funct,
    input logic [DATAWIDTH - 1 : 0] out_temp,
    output logic [DATAWIDTH - 1 : 0] out
);
    logic[DATAWIDTH-1:0] shifted_data;
    always_comb begin
        shifted_data = out_temp;
        case(funct)
            3'b010: out = shifted_data;
            3'b001: out = {{16{shifted_data[15]}}, shifted_data[15:0]};
            3'b101: out = {16'b0, shifted_data[15:0]};
            3'b000: out = {{24{shifted_data[7]}}, shifted_data[7:0]};
            3'b100: out = {24'b0, shifted_data[7:0]};
            default: out = shifted_data;
        endcase
    end
endmodule

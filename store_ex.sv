`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/09 21:09:22
// Design Name: 
// Module Name: store_ex
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


module store_ex #(
    parameter DATAWIDTH = 32
)(
    input logic[2:0] funct,
    input logic [DATAWIDTH - 1 : 0] out_temp,
    output logic [DATAWIDTH - 1 : 0] out,
    output logic [1:0] we
);

    always_comb begin
        out = '0;
        case(funct)
            3'b010: begin 
                out = out_temp;
                we = 2'b10;
            end
            3'b001, 3'b101: begin
                out = {16'b0, out_temp[15:0]};
                we = 2'b01;
            end
            3'b000, 3'b100: begin 
                out = {24'b0, out_temp[7:0]};
                we = 2'b00;
            end
            default: we = 2'b00;
        endcase
    end
endmodule

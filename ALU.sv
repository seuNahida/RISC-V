`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/02 16:53:55
// Design Name: 
// Module Name: ALU#
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


module ALU#(
    parameter DATAWIDTH = 32
)(
    input logic[DATAWIDTH-1: 0] a,
    input logic[DATAWIDTH-1: 0] b,
    input logic[1:0] Control,
    output logic[DATAWIDTH-1: 0] result,
    output logic N,
    output logic V,
    output logic Z,
    output logic C
    );

    typedef enum logic[1 : 0] {
        ALU_ADD = 2'b00, 
        ALU_SUB = 2'b01,
        ALU_AND = 2'b10,
        ALU_OR  = 2'b11
    } alu_op;

    always_comb begin
        result = '0;
        C = 1'b0;
        V = 1'b0;
        
        case(Control)
        ALU_ADD: begin 
            {C, result} = a + b;
            V = (a[DATAWIDTH - 1] == b[DATAWIDTH - 1]) && (result[DATAWIDTH - 1] != a[DATAWIDTH - 1]);
        end
        ALU_SUB: begin
            result = a - b;
            C = (a < b);
            V = (a[DATAWIDTH - 1] != b[DATAWIDTH - 1]) && (result[DATAWIDTH - 1] != a[DATAWIDTH - 1]);
        end
        ALU_AND: begin
            result = a & b;
        end
        ALU_OR: begin
            result = a | b;
        end
        default: result = '0;
    endcase

    N = result[DATAWIDTH - 1];
    Z = result == '0 ? 1'b1 : 1'b0;

    end

endmodule

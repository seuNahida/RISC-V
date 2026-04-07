`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 20:11:50
// Design Name: 
// Module Name: ALU_controller
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


module ALU_controller(
    input logic [3:0] funct,
    input logic [1:0] ALUOP,
    output logic [1:0] ALUControl
    );

    always_comb begin
        case(ALUOP)
            2'b00: ALUControl = 2'b00;
            2'b01: ALUControl = 2'b01;
            2'b10: begin
                case(funct)
                    4'b0000: ALUControl = 2'b00;
                    4'b1000: ALUControl = 2'b01;
                    4'b0111: ALUControl = 2'b10;
                    4'b0110: ALUControl = 2'b11;
                    default: ALUControl = 2'b00;
                endcase
            end
            default: ALUControl = 2'b00;
        endcase
    end
endmodule

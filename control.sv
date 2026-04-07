`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 20:20:32
// Design Name: 
// Module Name: control
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


module control(
    input logic [6:0] opcode,
    output logic Branch,
    output logic MemToReg,
    output logic MemWrite,
    output logic [1:0] ALUOP,
    output logic ALUSrc,
    output logic RegWrite
    );

    always_comb begin
        case(opcode)
            7'b0110011: begin
                ALUSrc = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOP = 2'b10;
            end
            7'b0000011: begin
                ALUSrc = 1'b1;
                MemToReg = 1'b1;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 1'b0;
                ALUOP = 2'b00;
            end
            7'b0100011: begin
                ALUSrc = 1'b1;
                MemToReg = 1'bX;
                RegWrite = 1'b0;
                MemWrite = 1'b1;
                Branch = 1'b0;
                ALUOP = 2'b00;
            end
            7'b1100011: begin
                ALUSrc = 1'b0;
                MemToReg = 1'bX;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                Branch = 1'b1;
                ALUOP = 2'b01;
            end
            default: begin
                Branch = 1'b0;
                MemToReg = 1'b0;
                MemWrite = 1'b0;
                ALUOP = 2'b00;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
            end
        endcase
    end
endmodule

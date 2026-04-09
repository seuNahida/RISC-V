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
    input logic [2:0] branch_type,
    input logic [6:0] opcode,
    output logic [2:0] Branch,
    output logic [1:0] RegWriteSrc,
    output logic MemWrite,
    output logic [2:0] ALUOP,
    output logic ALUSrc,
    output logic RegWrite,
    output logic Jump
    );

    always_comb begin
        case(opcode)
            7'b0110011: begin//R-Type
                ALUSrc = 1'b0;
                RegWriteSrc = 2'b00;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 3'b011;
                ALUOP = 3'b010;
                Jump = 1'b0;
            end
            7'b0010011: begin//I-Type
                ALUSrc = 1'b1;
                RegWriteSrc = 2'b00;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 3'b011;
                ALUOP = 3'b011;
                Jump = 1'b0;
            end
            7'b0000011: begin//Load
                ALUSrc = 1'b1;
                RegWriteSrc = 2'b01;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 3'b011;
                ALUOP = 3'b000;
                Jump = 1'b0;
            end
            7'b0100011: begin//Store
                ALUSrc = 1'b1;
                RegWriteSrc = 2'bXX;
                RegWrite = 1'b0;
                MemWrite = 1'b1;
                Branch = 3'b011;
                ALUOP = 3'b000;
                Jump = 1'b0;
            end
            7'b1100011: begin//B-Type
                ALUSrc = 1'b0;
                RegWriteSrc = 2'bXX;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                Branch = branch_type;
                ALUOP = 3'b001;
                Jump = 1'b0;
            end
            7'b1101111: begin//jal
                ALUSrc = 1'bX;
                RegWriteSrc = 2'b10;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 3'b010;
                ALUOP = 3'b000;
                Jump = 1'b1;
            end
            7'b1100111: begin//jalr
                ALUSrc = 1'b1;
                RegWriteSrc = 2'b10;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 3'b011;
                ALUOP = 3'b000;
                Jump = 1'b1;
            end
            7'b0110111: begin//lui
                ALUSrc = 1'b1;
                RegWriteSrc = 2'b00;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 3'b011;
                ALUOP = 3'b101;
                Jump = 1'b0;
            end
            7'b0010111: begin//auipc
                ALUSrc = 1'b1;
                RegWriteSrc = 2'b00;
                RegWrite = 1'b1;
                MemWrite = 1'b0;
                Branch = 3'b011;
                ALUOP = 3'b000;
                Jump = 1'b0;
            end
            default: begin
                ALUSrc = 1'b0;
                RegWriteSrc = 2'b00;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                Branch = 3'b011;
                ALUOP = 3'b000;
                Jump = 1'b0;
            end
        endcase
    end
endmodule

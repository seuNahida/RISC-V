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
    input logic [2:0] ALUOP,
    output logic [3:0] ALUControl
    );

    always_comb begin
        case(ALUOP)
            3'b000: ALUControl = 2'b0000;
            3'b001: ALUControl = 2'b0001;
            3'b010: begin
                case(funct)
                    4'b0000: ALUControl = 4'b0000;
                    4'b1000: ALUControl = 4'b0001;
                    4'b0111: ALUControl = 4'b0010;
                    4'b0110: ALUControl = 4'b0011;
                    4'b0100: ALUControl = 4'b0100;
                    4'b0001: ALUControl = 4'b0101;
                    4'b0101: ALUControl = 4'b0110;
                    4'b1101: ALUControl = 4'b0111;
                    4'b0010: ALUControl = 4'b1000;
                    4'b0011: ALUControl = 4'b1001;
                    default: ALUControl = 4'b0000;
                endcase
            end
            3'b011: begin
                case(funct)
                    4'bX000: ALUControl = 4'b0000;
                    4'bX111: ALUControl = 4'b0010;
                    4'bX110: ALUControl = 4'b0011;
                    4'bX100: ALUControl = 4'b0100;
                    4'bX010: ALUControl = 4'b1000;
                    4'bX011: ALUControl = 4'b1001;
                    4'b0001: ALUControl = 4'b0101;
                    4'b0101: ALUControl = 4'b0110;
                    4'b1101: ALUControl = 4'b0111;
                    default: ALUControl = 4'b000;
                endcase
            end
            3'b101: ALUControl = 4'b1010;
            default: ALUControl = 4'b00;
        endcase
    end
endmodule

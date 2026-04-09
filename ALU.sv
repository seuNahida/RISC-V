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
    input logic[3:0] Control,
    output logic[DATAWIDTH-1: 0] result,
    output logic N,
    output logic V,
    output logic Z,
    output logic C //borrow
    );

    typedef enum logic[3 : 0] {
        ALU_ADD = 4'b0000, 
        ALU_SUB = 4'b0001,
        ALU_AND = 4'b0010,
        ALU_OR  = 4'b0011,
        ALU_XOR = 4'b0100,
        ALU_SLL = 4'b0101,
        ALU_SRL = 4'b0110,
        ALU_SRA = 4'b0111,
        ALU_SLT = 4'b1000,
        ALU_SLTU = 4'b1001,
        ALU_PassB = 4'b1010
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
        ALU_XOR: begin
            result = a ^ b;
        end
        ALU_SLL: begin
            result = a << b[4:0];
        end
        ALU_SRL: begin
            result = a >> b[4:0];
        end
        ALU_SRA: begin
            result = $signed(a) >>> b[4:0];
        end
        ALU_SLT: begin
            if(a[DATAWIDTH-1] == b[DATAWIDTH-1]) begin
                result = a[DATAWIDTH-2:0] < b[DATAWIDTH-2:0] ? 1 : 0;
            end else result = a[DATAWIDTH-1] ? 1 : 0;
        end
        ALU_SLTU: begin
            result = a < b ? 1 : 0;
        end
        ALU_PassB: begin
            result = b;
        end
        default: result = '0;
    endcase

    N = result[DATAWIDTH - 1];
    Z = result == '0 ? 1'b1 : 1'b0;

    end

endmodule

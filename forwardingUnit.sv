`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/11 17:25:49
// Design Name: 
// Module Name: forwardingUnit
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


module forwardingUnit #(
    parameter DATAWIDTH = 32
)(
    input logic [4:0] id_ex_r1addr,
    input logic [4:0] id_ex_r2addr,
    input logic ex_mem_RegWrite,
    input logic [4:0] ex_mem_rd,
    input logic mem_wb_RegWrite,
    input logic [4:0] mem_wb_rd,
    output logic[1:0] r1_forward_flag,
    output logic [1:0] r2_forward_flag
);

    always_comb begin
        if(ex_mem_RegWrite && ex_mem_rd ==id_ex_r1addr && ex_mem_rd != 5'b0) r1_forward_flag = 2'b10;
        else if(mem_wb_RegWrite && mem_wb_rd == id_ex_r1addr && mem_wb_rd != 5'b0) r1_forward_flag = 2'b01;
        else r1_forward_flag = 2'b00;
    end
    always_comb begin
        if(ex_mem_RegWrite && ex_mem_rd ==id_ex_r2addr && ex_mem_rd != 5'b0) r2_forward_flag = 2'b10;
        else if(mem_wb_RegWrite && mem_wb_rd == id_ex_r2addr && mem_wb_rd != 5'b0) r2_forward_flag = 2'b01;
        else r2_forward_flag = 2'b00;
    end
endmodule

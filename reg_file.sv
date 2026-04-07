`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 16:15:44
// Design Name: 
// Module Name: reg_file#
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


module reg_file#(
    parameter ADDR_WIDTH = 5,
    parameter DATAWIDTH = 32
)(
    input logic clk,
    input logic rst,

    input logic wr_reg_en,
    input logic [ADDR_WIDTH - 1 : 0] wr_reg_addr,
    input logic [DATAWIDTH - 1 : 0] wr_wdata,

    input logic [ADDR_WIDTH - 1 : 0] rs_reg1_addr,
    input logic [ADDR_WIDTH - 1 : 0] rs_reg2_addr,

    output logic [DATAWIDTH - 1 : 0] rs_reg1_rdata,
    output logic [DATAWIDTH - 1 : 0] rs_reg2_rdata
);

    logic [DATAWIDTH - 1 : 0] reg_bank [31:0];

    always_ff @( posedge clk or posedge rst ) begin
        if(rst) begin
            for(int i = 0; i < (1 << ADDR_WIDTH); i++) reg_bank[i] <= 0;
        end else begin
            if(wr_reg_en && (wr_reg_addr != '0)) reg_bank[wr_reg_addr] <= wr_wdata;
        end
    end

    always_comb begin
        rs_reg1_rdata = reg_bank[rs_reg1_addr];
        rs_reg2_rdata = reg_bank[rs_reg2_addr];
    end
endmodule

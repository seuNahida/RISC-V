`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 17:17:52
// Design Name: 
// Module Name: data_ram#
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


module data_ram#(
    parameter DATAWIDTH = 32,
    parameter RAMWIDTH = 8,
    parameter RAMDEPTH = 8
)(
    input logic clk,
    input logic rst,
    input logic ena,
    input logic wen,
    input logic [3:0] we,
    input logic [DATAWIDTH - 1 : 0] din,
    input logic [DATAWIDTH - 1 : 0] daddr,
    output logic [DATAWIDTH - 1 : 0] dout
);

    reg [RAMWIDTH - 1 : 0] ram [2**(RAMDEPTH) - 1 : 0];

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
        end else if(ena && wen) begin
            if(we[0]) ram[daddr] <= din[7:0];
            if(we[1]) ram[daddr+1] <= din[15:8];
            if(we[2]) ram[daddr+2] <= din[23:16];
            if(we[3]) ram[daddr+3] <= din[31:24];
        end
    end

    always_comb begin
        dout = '0;
        if(ena) begin
            dout = {ram[daddr+3],ram[daddr+2],ram[daddr+1],ram[daddr]};
        end
    end
endmodule

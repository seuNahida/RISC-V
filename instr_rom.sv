`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 16:44:52
// Design Name: 
// Module Name: instr_rom#
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


module instr_rom#(
    parameter DATAWIDTH = 32,
    parameter RAMWIDTH = 8,
    parameter RAMDEPTH = 8
)(
    input logic ena,
    input logic [DATAWIDTH - 1 : 0] daddr,
    output logic [DATAWIDTH - 1 : 0] dout
);

    reg [RAMWIDTH - 1:0] rom [2**(RAMDEPTH) -1 :0];

    always_comb begin
        if(ena) begin
            dout = {rom[daddr+3],rom[daddr+2],rom[daddr+1],rom[daddr]};
        end else begin 
            dout = '0;
        end  
    end
endmodule

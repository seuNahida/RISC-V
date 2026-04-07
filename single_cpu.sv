`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 20:31:38
// Design Name: 
// Module Name: single_cpu
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


module single_cpu #(
    parameter DATAWIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic ena,
    output logic [DATAWIDTH-1:0] pc_out
    );

    logic [DATAWIDTH-1:0] npc;
    pc pc_inst(.npc(npc), .pc_out(pc_out), .clk(clk), .rst(rst));

    logic [DATAWIDTH-1:0] instr;
    instr_rom instr_rom_inst(.ena(ena), .daddr(pc_out), .dout(instr));

    logic Branch, MemToReg, MemWrite, ALUSrc, Regwrite;
    logic [1:0] ALUOP;
    control col(.opcode(instr[6:0]), .Branch(Branch), .MemToReg(MemToReg), .MemWrite(MemWrite), .ALUOP(ALUOP), .ALUSrc(ALUSrc), .RegWrite(Regwrite));

    logic [DATAWIDTH-1:0] r1data, r2data, wrdata;
    reg_file reg_file_inst(.clk(clk), .rst(rst), .wr_reg_en(Regwrite), .wr_reg_addr(instr[11:7]), .wr_wdata(wrdata), .rs_reg1_addr(instr[19:15]), .rs_reg2_addr(instr[24:20]), .rs_reg1_rdata(r1data), .rs_reg2_rdata(r2data));

    logic [DATAWIDTH-1:0] imm;
    imm_gen immgen(.instr(instr[31:0]), .imm(imm));

    logic [1:0] alucontrolflag;
    ALU_controller alucontrol(.funct({instr[30],instr[14:12]}), .ALUOP(ALUOP), .ALUControl(alucontrolflag));

    logic [DATAWIDTH-1:0] aluinputb;
    mux mux1(.A(r2data), .B(imm), .control(ALUSrc), .Result(aluinputb));

    logic [DATAWIDTH-1:0] aluresult;
    logic N, V, Z, C;
    ALU ALU(.a(r1data), .b(aluinputb), .Control(alucontrolflag), .result(aluresult), .N(N), .V(V), .Z(Z), .C(C));

    logic [DATAWIDTH-1:0] dmdata;
    data_ram data_ram_inst(.clk(clk), .rst(rst), .ena(ena), .wen(MemWrite), .din(r2data), .daddr(aluresult), .dout(dmdata));

    mux mux2(.A(aluresult), .B(dmdata), .control(MemToReg), .Result(wrdata));

    logic [DATAWIDTH-1:0] npc1,npc2;
    adder adder1(.A(pc_out), .B(4), .Result(npc1));
    adder adder2(.A(pc_out), .B(imm), .Result(npc2));

    assign npc = (Branch && Z) ? npc2 : npc1;

endmodule

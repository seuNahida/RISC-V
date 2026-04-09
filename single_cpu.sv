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
    output logic [DATAWIDTH-1:0] pc_out
    );
    
    logic ena;
    assign ena = 1;
    
    logic [DATAWIDTH-1:0] npc;
    pc pc_inst(.npc(npc), .pc_out(pc_out), .clk(clk), .rst(rst));

    logic [DATAWIDTH-1:0] instr;
    instr_rom instr_rom_inst(.ena(ena), .daddr(pc_out), .dout(instr));

    logic [2:0] Branch;
    logic MemWrite, ALUSrc, Regwrite, Jump;
    logic [1:0] RegWriteSrc;
    logic [2:0] ALUOP;
    control col(.opcode(instr[6:0]), 
                .branch_type(instr[14:12]), 
                .Branch(Branch), 
                .RegWriteSrc(RegWriteSrc), 
                .MemWrite(MemWrite), 
                .ALUOP(ALUOP), 
                .ALUSrc(ALUSrc), 
                .RegWrite(Regwrite),
                .Jump(Jump));

    logic [DATAWIDTH-1:0] r1data, r2data;
    reg_file reg_file_inst(.clk(clk), .rst(rst), .wr_reg_en(Regwrite), .wr_reg_addr(instr[11:7]), .wr_wdata(torf_result), .rs_reg1_addr(instr[19:15]), .rs_reg2_addr(instr[24:20]), .rs_reg1_rdata(r1data), .rs_reg2_rdata(r2data));

    logic [DATAWIDTH-1:0] imm;
    imm_gen immgen(.instr(instr[31:0]), .imm(imm));

    logic [3:0] alucontrolflag;
    ALU_controller alucontrol(.funct({instr[30],instr[14:12]}), .ALUOP(ALUOP), .ALUControl(alucontrolflag));

    logic [DATAWIDTH-1:0] aluinputb;
    mux mux1(.A(r2data), .B(imm), .control(ALUSrc), .Result(aluinputb));

    //temp
    logic [DATAWIDTH-1:0] alur1;
    mux mux2(.A(r1data), .B(pc_out), .control(instr[6:0]==7'h17), .Result(alur1));

    logic [DATAWIDTH-1:0] aluresult;
    logic N, V, Z, C;
    ALU ALU(.a(alur1), .b(aluinputb), .Control(alucontrolflag), .result(aluresult), .N(N), .V(V), .Z(Z), .C(C));

    logic [3:0] we;
    logic [31:0] din;
    store_ex storeEx(.funct(instr[14:12]), .out_temp(r2data), .out(din), .we(we));

    logic [DATAWIDTH-1:0] dmdata_temp, dmdata;
    data_ram data_ram_inst(.clk(clk), .rst(rst), .ena(ena), .wen(MemWrite), .we(we), .din(din), .daddr(aluresult), .dout(dmdata_temp));

    word_ex wordEx(.funct(instr[14:12]), .out_temp(dmdata_temp), .out(dmdata));

    logic [DATAWIDTH-1:0] torf_result; 
    toRF RFback(.RegWriteSrc(RegWriteSrc), .npc_n(npc1), .alu_result(aluresult), .dm_result(dmdata), .imm(imm), .result(torf_result));

    logic branch_flag;
    branch_control bc(.branch(Branch), .N(N), .V(V), .Z(Z), .C(C), .branch_flag(branch_flag));

    logic [DATAWIDTH-1:0] npc1, npc2, npc3;
    adder adder1(.A(pc_out), .B(4), .Result(npc1));
    adder adder2(.A(pc_out), .B(imm), .Result(npc2));
    assign npc3 = {aluresult[DATAWIDTH-1:1], 0};
    pc_control pc_c(.npc_b(npc2), .npc_n(npc1), .npc_j(npc3), .pcflag({branch_flag, Jump}), .npc(npc));

endmodule

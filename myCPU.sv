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


module myCPU #(
    parameter DATAWIDTH = 32
)(
    input  logic         cpu_rst,
    input  logic         cpu_clk,

    output logic [31:0]  irom_addr,
    input  logic [31:0]  irom_data,
    
    output logic [31:0]  perip_addr,
    output logic         perip_wen,
	output logic [ 1:0]  perip_mask,
    output logic [31:0]  perip_wdata,
    input  logic [31:0]  perip_rdata
    );

    logic flush, load_use_stall;

    logic [DATAWIDTH-1:0] if_id_pc, if_id_instr;

    logic [DATAWIDTH-1:0] id_ex_pc;
    logic [DATAWIDTH-1:0] id_ex_r1data, id_ex_r2data, id_ex_imm;
    logic [4:0] id_ex_rd;
    logic [6:0] id_ex_opcode;
    logic [2:0] id_ex_funct3, id_ex_Branch;
    logic [3:0] id_ex_aluCtrl;
    logic [1:0] id_ex_RegWriteSrc;
    logic id_ex_RegWrite, id_ex_MemWrite, id_ex_ALUSrc, id_ex_Jump;
    logic [4:0] id_ex_r1addr, id_ex_r2addr;

    logic [DATAWIDTH-1:0] ex_mem_pc;
    logic [DATAWIDTH-1:0] ex_mem_alu_result, ex_mem_r2data, ex_mem_imm;
    logic [4:0] ex_mem_rd;
    logic [2:0] ex_mem_funct3;
    logic [1:0] ex_mem_RegWriteSrc;
    logic ex_mem_RegWrite, ex_mem_MemWrite;

    logic [DATAWIDTH-1:0] mem_wb_pc;
    logic [DATAWIDTH-1:0] mem_wb_alu_result, mem_wb_dmdata, mem_wb_imm;
    logic [4:0] mem_wb_rd;
    logic [1:0] mem_wb_RegWriteSrc;
    logic mem_wb_RegWrite;
    logic [DATAWIDTH-1:0] torf_result;


    logic [31:0] pc_out, next_pc;//IF
    pc pc_inst(
        .npc(next_pc), 
        .pc_out(pc_out), 
        .clk(cpu_clk), 
        .rst(cpu_rst), 
        .ena(flush | !load_use_stall)
        );
    assign irom_addr = pc_out;
    always_ff @( posedge cpu_clk ) begin
        if(cpu_rst) begin
            if_id_instr <= 32'h00000013;
            if_id_pc <= 32'h80000000;
        end else if(!load_use_stall) begin
            if(flush) begin
                if_id_instr <= 32'h00000013;
                if_id_pc <= 32'h80000000;
            end else begin
                if_id_instr <= irom_data;
                if_id_pc <= pc_out;
            end
        end  
    end

    logic [2:0] Branch;//ID
    logic MemWrite, ALUSrc, Regwrite, Jump;
    logic [1:0] RegWriteSrc;
    logic [2:0] ALUOP;
    logic [DATAWIDTH-1:0] r1data, r2data;
    logic [DATAWIDTH-1:0] imm;
    logic [3:0] alucontrolflag;
    control col(.opcode(if_id_instr[6:0]), 
                .branch_type(if_id_instr[14:12]), 
                .Branch(Branch), 
                .RegWriteSrc(RegWriteSrc), 
                .MemWrite(MemWrite), 
                .ALUOP(ALUOP), 
                .ALUSrc(ALUSrc), 
                .RegWrite(Regwrite),
                .Jump(Jump));
    imm_gen immgen(
        .instr(if_id_instr[31:0]),
        .imm(imm));
    ALU_controller alucontrol(
        .funct({if_id_instr[30],if_id_instr[14:12]}), 
        .ALUOP(ALUOP), 
        .ALUControl(alucontrolflag));
    reg_file reg_file_inst(
        .clk(cpu_clk), 
        .rst(cpu_rst), 
        .wr_reg_en(mem_wb_RegWrite), 
        .wr_reg_addr(mem_wb_rd), 
        .wr_wdata(torf_result), 
        .rs_reg1_addr(if_id_instr[19:15]), 
        .rs_reg2_addr(if_id_instr[24:20]), 
        .rs_reg1_rdata(r1data), 
        .rs_reg2_rdata(r2data));

    always_comb begin
        if(id_ex_RegWriteSrc==2'b01 && (id_ex_rd != 5'b0) && ((id_ex_rd == if_id_instr[19:15]) || (id_ex_rd == if_id_instr[24:20])))
            load_use_stall = 1'b1; else load_use_stall = 1'b0;
    end

    always_ff @( posedge cpu_clk ) begin
            if(cpu_rst) begin
                id_ex_RegWrite <= 1'b0;
                id_ex_MemWrite <= 1'b0;
                id_ex_Branch <= 3'b011;
                id_ex_Jump <= 1'b0;
            end else if(flush || load_use_stall) begin
                    id_ex_RegWrite <= 1'b0;
                    id_ex_MemWrite <= 1'b0;
                    id_ex_Branch <= 3'b011;
                    id_ex_Jump <= 1'b0;
                    id_ex_RegWriteSrc <= 2'b00; 
                    id_ex_rd <= 5'b0;
                end else begin
                    id_ex_r1addr <= if_id_instr[19:15];
                    id_ex_r2addr <= if_id_instr[24:20];
                    id_ex_pc <= if_id_pc;
                    id_ex_r1data <= r1data;
                    id_ex_r2data <= r2data;
                    id_ex_rd <= if_id_instr[11:7];
                    id_ex_RegWrite <= Regwrite;
                    id_ex_MemWrite <= MemWrite;
                    id_ex_Jump <= Jump;
                    id_ex_imm <= imm;
                    id_ex_funct3 <= if_id_instr[14:12];
                    id_ex_Branch <= Branch;
                    id_ex_ALUSrc <= ALUSrc;
                    id_ex_aluCtrl <= alucontrolflag;
                    id_ex_RegWriteSrc <= RegWriteSrc;
                    id_ex_opcode <= if_id_instr[6:0];
                end
        end

    logic [DATAWIDTH-1:0] aluinputb;//EX
    logic [DATAWIDTH-1:0] alur1;
    logic [DATAWIDTH-1:0] aluresult;
    logic N, V, Z, C;
    logic branch_flag;
    logic [1:0] r1_fg, r2_fg;
    logic [DATAWIDTH-1:0] bypass1, bypass2;
    forwardingUnit forward(
        .id_ex_r1addr(id_ex_r1addr),
        .id_ex_r2addr(id_ex_r2addr),
        .ex_mem_RegWrite(ex_mem_RegWrite),
        .ex_mem_rd(ex_mem_rd),
        .mem_wb_RegWrite(mem_wb_RegWrite),
        .mem_wb_rd(mem_wb_rd),
        .r1_forward_flag(r1_fg),
        .r2_forward_flag(r2_fg)
    );
    always_comb begin
        case(r1_fg)
            2'b10: bypass1 = (ex_mem_RegWriteSrc == 2'b10) ? (ex_mem_pc + 4) : (ex_mem_alu_result);
            2'b01: bypass1 = torf_result;
            default: bypass1 = id_ex_r1data;
        endcase 
    end
    always_comb begin
        case(r2_fg)
            2'b10: bypass2 = (ex_mem_RegWriteSrc == 2'b10) ? (ex_mem_pc + 4) : (ex_mem_alu_result);
            2'b01: bypass2 = torf_result;
            default: bypass2 = id_ex_r2data;
        endcase 
    end
    mux mux1(
        .A(bypass2), 
        .B(id_ex_imm), 
        .control(id_ex_ALUSrc), 
        .Result(aluinputb));
    mux mux2(
        .A(bypass1), .B(id_ex_pc), 
        .control(id_ex_opcode==7'h17), .Result(alur1));
    ALU ALU(.a(alur1), .b(aluinputb), 
        .Control(id_ex_aluCtrl), .result(aluresult), .N(N), .V(V), .Z(Z), .C(C));
    branch_control bc(
        .branch(id_ex_Branch), 
        .N(N), .V(V), .Z(Z), .C(C), 
        .branch_flag(branch_flag));
    logic [DATAWIDTH-1:0] npc1, npc2, npc3;
    adder adder1(.A(pc_out), .B(4), .Result(npc1));
    adder adder2(.A(id_ex_pc), .B(id_ex_imm), .Result(npc2));
    assign npc3 = {aluresult[DATAWIDTH-1:1], 1'b0};
    pc_control pc_c(
        .npc_b(npc2), .npc_n(npc1), .npc_j(npc3), 
        .pcflag({branch_flag, id_ex_Jump}), .npc(next_pc));
    assign flush = branch_flag || id_ex_Jump;
    always_ff @( posedge cpu_clk ) begin
        if(cpu_rst) begin
            ex_mem_RegWrite <= 1'b0;
            ex_mem_MemWrite <= 1'b0;
        end else begin
            ex_mem_alu_result <= aluresult;
            ex_mem_funct3 <= id_ex_funct3;
            ex_mem_MemWrite <= id_ex_MemWrite;
            ex_mem_pc <= id_ex_pc;
            ex_mem_r2data <= bypass2;
            ex_mem_rd <= id_ex_rd;
            ex_mem_RegWrite <= id_ex_RegWrite;
            ex_mem_RegWriteSrc <= id_ex_RegWriteSrc;
            ex_mem_imm <= id_ex_imm;
        end
    end

    logic [1:0] we;//MEM
    logic [DATAWIDTH-1:0] din;
    logic [DATAWIDTH-1:0] dmdata;
    logic is_load_instr;
    store_ex storeEx(
        .funct(ex_mem_funct3), 
        .out_temp(ex_mem_r2data), 
        .out(din), 
        .we(we));
    assign perip_wen = ex_mem_MemWrite;
    assign perip_addr = ex_mem_alu_result;
    assign perip_wdata = din;
    assign perip_mask = we;
    word_ex wordEx(
        .funct(ex_mem_funct3), 
        .out_temp(perip_rdata), 
        .out(dmdata));
    always_ff @( posedge cpu_clk ) begin
        if(cpu_rst) begin
            mem_wb_RegWrite <= 1'b0;
        end else  begin
            mem_wb_alu_result <= ex_mem_alu_result;
            mem_wb_dmdata <= dmdata;
            mem_wb_imm <= ex_mem_imm;
            mem_wb_pc <= ex_mem_pc;
            mem_wb_rd <= ex_mem_rd;
            mem_wb_RegWrite <= ex_mem_RegWrite;
            mem_wb_RegWriteSrc <= ex_mem_RegWriteSrc;
        end
    end

    logic [DATAWIDTH-1:0] pcval;//WB
    assign pcval = mem_wb_pc + 4;
    toRF RFback(
        .RegWriteSrc(mem_wb_RegWriteSrc), 
        .npc_n(pcval), 
        .alu_result(mem_wb_alu_result),
        .dm_result(mem_wb_dmdata), 
        .imm(mem_wb_imm), 
        .result(torf_result));

endmodule

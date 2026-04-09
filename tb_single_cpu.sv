`timescale 1ns / 1ps

module tb_single_cpu();

    parameter DATAWIDTH = 32;
    logic clk;
    logic rst;
    logic [DATAWIDTH-1:0] pc_out;

    single_cpu #(
        .DATAWIDTH(DATAWIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $readmemh("instr.hex", uut.instr_rom_inst.rom);
        

        $display("======= Simulation Started =======");

        rst = 1;
        #20;    
        rst = 0; 

        #1000;
        $display("Timeout! Simulation Stopped.");
        $finish;
    end

    always @(posedge clk) begin
        if (!rst) begin
            $display("Time: %0t | PC = %h | Instr = %h", $time, pc_out, uut.instr);


            if (uut.instr == 32'h0000006f) begin
                $display("======= Program Reached END (jal x0, 0) =======");

    $display("--- 运算逻辑验收 ---");
    $display("x1 (F_4)          = %d (Expected: 5)", uut.reg_file_inst.reg_bank[1]);
    $display("x2 (F_5)          = %d (Expected: 8)", uut.reg_file_inst.reg_bank[2]);
$display("x3 (Loop Counter) = %d (Expected: 0)", uut.reg_file_inst.reg_bank[3]);
$display("x4 (Mem Pointer)  = %d (Expected: 20)", uut.reg_file_inst.reg_bank[4]);
$display("x5 (Total Sum)    = %d (Expected: 12)", uut.reg_file_inst.reg_bank[5]);

$display("--- 内存总线验收 ---");
// 检查生成的斐波那契数组：1, 1, 2, 3, 5
$display("MEM[0]  = %d (Expected: 1)", uut.data_ram_inst.ram[0]); 
$display("MEM[4]  = %d (Expected: 1)", uut.data_ram_inst.ram[4]); 
$display("MEM[8]  = %d (Expected: 2)", uut.data_ram_inst.ram[8]); 
$display("MEM[12] = %d (Expected: 3)", uut.data_ram_inst.ram[12]); 
$display("MEM[16] = %d (Expected: 5)", uut.data_ram_inst.ram[16]); 

$finish;
            end
        end
    end

endmodule
`timescale 1ns / 100ps

module pc_tb;

    reg clk, reset;
    reg [31:0] next_pc;
    wire [31:0] pc;

    // 例化 PC 模組
    ProgramCounter uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // 產生時脈訊號
    always #5 clk = ~clk;

    initial begin

        // 初始化
        clk = 0;
        reset = 1;
        next_pc = 32'h00000004;
        $dumpfile("testbench.vcd"); // 產生 VCD 檔案
        $dumpvars(0);    // 記錄所有訊號
        #10 reset = 0;  // 解除 reset，PC 應更新為 next_pc

        #10 next_pc = 32'h00000008;
        #10 next_pc = 32'h0000000C;
        #10 next_pc = 32'h00000010;

        #20 $finish;
    end

    initial begin
        $monitor("Time=%0t | Reset=%b | PC=%h | Next_PC=%h", $time, reset, pc, next_pc);
    end

endmodule

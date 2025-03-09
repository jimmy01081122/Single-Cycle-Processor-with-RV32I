`timescale 1ns / 100ps

module instruction_memory_tb;

    reg [31:0] addr;
    wire [31:0] instr;

    // 例化 Instruction Memory
    InstructionMemory uut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
    $dumpfile("testbench.vcd"); // 產生 VCD 檔案
    $dumpvars(0);    // 記錄所有訊號

        $readmemh("instructions.mem", uut.memory);  // 載入機器碼

        // 測試不同指令地址
        addr = 32'h00000000; #10;
        addr = 32'h00000004; #10;
        addr = 32'h00000008; #10;
        addr = 32'h0000000C; #10;
        addr = 32'h00000010; #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | Addr=%h | Instr=%h", $time, addr, instr);
    end

endmodule

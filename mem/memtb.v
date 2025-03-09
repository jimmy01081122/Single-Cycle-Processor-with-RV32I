`timescale 1ns / 100ps

module data_memory_tb;

    reg clk;
    reg MemRead, MemWrite;
    reg [31:0] addr, write_data;
    wire [31:0] read_data;

    // 例化 Data Memory
    DataMemory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // 產生時脈
    always #5 clk = ~clk;

    initial begin
        clk = 0;

        // 測試 SW（寫入記憶體）
        MemWrite = 1; MemRead = 0;
        addr = 32'h00000008; write_data = 32'hDEADBEEF; #10;
        addr = 32'h0000000C; write_data = 32'h12345678; #10;

        // 測試 LW（讀取記憶體）
        MemWrite = 0; MemRead = 1;
        addr = 32'h00000008; #10;
        addr = 32'h0000000C; #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | Addr=%h | WriteData=%h | ReadData=%h | MemRead=%b | MemWrite=%b",
                 $time, addr, write_data, read_data, MemRead, MemWrite);
    end

endmodule

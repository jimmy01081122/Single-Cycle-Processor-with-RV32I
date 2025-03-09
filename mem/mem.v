module DataMemory (
    input wire clk,
    input wire MemRead, MemWrite,  // 讀取或寫入信號
    input wire [31:0] addr,        // 記憶體地址
    input wire [31:0] write_data,  // 要寫入的數據
    output reg [31:0] read_data    // 讀取的數據
);

reg [31:0] memory [0:255]; // 256 x 32-bit 記憶體

always @(posedge clk) begin
    if (MemWrite) begin
        memory[addr[9:2]] <= write_data; // 以 word (4 Bytes) 為單位寫入
    end
end

always @(*) begin
    if (MemRead) begin
        read_data = memory[addr[9:2]]; // 以 word (4 Bytes) 為單位讀取
    end else begin
        read_data = 32'b0;
    end
end

endmodule

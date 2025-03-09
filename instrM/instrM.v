/*
 * Instruction Memory
 *  - 指令記憶體模組
 *  - 從檔案載入指令
 *  - 以 word (4 Bytes) 為單位讀取指令
 */
module InstructionMemory (
    input wire [31:0] addr,          // 指令地址 (來自 PC)
    output wire [31:0] instr         // 指令輸出
);

reg [31:0] memory [0:255];  // 256 x 32-bit 指令記憶體

initial begin
    $readmemh("instructions.mem", memory);  // 從檔案載入指令
end

assign instr = memory[addr[9:2]];  // 以 word (4 Bytes) 為單位讀取指令

endmodule

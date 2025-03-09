module InstructionMemory (
    input wire [31:0] addr,
    output wire [31:0] instr
);

    reg [31:0] memory [0:255]; // 256 x 32-bit 指令記憶體
    integer i;
    initial begin
        $readmemh("instructions.mem", memory);
        
        for (i = 0; i < 10; i = i + 1) begin
            $display("InstructionMemory[%0d] = %h", i, memory[i]);
        end
    end

    assign instr = memory[addr[9:2]]; // 4-byte 對齊讀取指令

endmodule

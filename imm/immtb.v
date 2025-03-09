`timescale 1ns / 100ps

module immediate_generator_tb;

    reg [31:0] instr;
    wire [31:0] imm_out;

    // 例化 Immediate Generator
    ImmediateGenerator uut (
        .instr(instr),
        .imm_out(imm_out)
    );

    initial begin
        // 測試 I-type: ADDI x1, x2, 5 -> opcode = 0010011
        instr = 32'b000000000101_00010_000_00001_0010011; #10;
        // 測試 S-type: SW x1, 20(x2) -> opcode = 0100011
        instr = 32'b0000000_00001_00010_010_10100_0100011; #10;
        // 測試 B-type: BEQ x1, x2, 8 -> opcode = 1100011
        instr = 32'b0000000_00001_00010_000_00001_1100011; #10;
        // 測試 U-type: LUI x1, 0x12345 -> opcode = 0110111
        instr = 32'b00010010001101000101_00001_0110111; #10;
        // 測試 J-type: JAL x1, 1024 -> opcode = 1101111
        instr = 32'b00000000010000000000_00001_1101111; #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | Instr=%b | Imm_Out=%h", $time, instr, imm_out);
    end

endmodule

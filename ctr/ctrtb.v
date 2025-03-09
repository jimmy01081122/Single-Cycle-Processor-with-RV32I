`timescale 1ns / 1ps

module control_unit_tb;

    reg [6:0] opcode;
    wire RegWrite, ALUSrc, MemRead, MemWrite, Branch, MemToReg;
    wire [1:0] ALUOp;

    // 例化 Control Unit
    ControlUnit uut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp)
    );

    initial begin
        // 測試 R-type (ADD)
        opcode = 7'b0110011; #10;
        // 測試 I-type (ADDI)
        opcode = 7'b0010011; #10;
        // 測試 Load (LW)
        opcode = 7'b0000011; #10;
        // 測試 Store (SW)
        opcode = 7'b0100011; #10;
        // 測試 Branch (BEQ)
        opcode = 7'b1100011; #10;
        // 測試 LUI
        opcode = 7'b0110111; #10;
        // 測試 JAL
        opcode = 7'b1101111; #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | Opcode=%b | RegWrite=%b | ALUSrc=%b | MemRead=%b | MemWrite=%b | Branch=%b | MemToReg=%b | ALUOp=%b",
                 $time, opcode, RegWrite, ALUSrc, MemRead, MemWrite, Branch, MemToReg, ALUOp);
    end

endmodule

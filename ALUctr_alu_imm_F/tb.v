`timescale 1ns / 100ps

module ALU_ALUctr_ImmGen_tb;
    reg [31:0] A;
    reg [31:0] instr; // 指令
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [4:0] ALUop;
    wire [31:0] imm_out;
    wire [31:0] Y;
    wire zero;

    // 立即數生成器 (ImmGen) 實例化
    ImmGen imm_gen (
        .instr(instr),
        .imm_out(imm_out)
    );

    // ALU 控制單元 (ALUctr) 實例化
    ALUctr alu_ctrl (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop)
    );

    // ALU 實例化
    ALU alu (
        .A(A),
        .B(imm_out), // 改用立即數
        .ALUop(ALUop),
        .Y(Y),
        .zero(zero)
    );

    // 測試程序
    initial begin
        $display("ALU + ALUctr + ImmGen: Testbench");
        $dumpfile("ALU_ALUctr_ImmGen_tb.vcd");  // VCD 波形輸出
        $dumpvars(0, ALU_ALUctr_ImmGen_tb);

        $display("------------------I-type 指令-------------------");
        opcode = 7'b0010011; // I-type 指令
        
        // 測試 ADDI (000 funct3) (A + imm)
        instr = 32'h00208213; // ADDI x4, x1, 2 (x4 = x1 + 2)
        $display("Instr: %b", instr);
        //you can just check the first 3 bits of the instruction to determine the constant you need to add to the register
        A = 32'h00000010;
        funct3 = 3'b000;
        #10;
        $display("ADDI: A=%h, imm=%h, Y=%h (Expect 12)", A, imm_out, Y);

        // 測試 SLTI (010 funct3) (有符號比較)
        instr = 32'h00308293; // SLTI x5, x1, 3 (x5 = (x1 < 3) ? 1 : 0)
        A = 32'hFFFFFFF0;
        funct3 = 3'b010;
        #10;
        $display("SLTI: A=%h, imm=%h, Y=%h (Expect 1)", A, imm_out, Y);

        // 測試 SLTIU (011 funct3) (無符號比較)
        instr = 32'h00309313; // SLTIU x6, x1, 3 (x6 = (x1 < 3) ? 1 : 0)
        A = 32'h00000010;
        funct3 = 3'b011;
        #10;
        $display("SLTIU: A=%h, imm=%h, Y=%h (Expect 0)", A, imm_out, Y);

        // 測試 XORI (100 funct3) (XOR)
        instr = 32'hF0F0F0F3; // XORI x7, x1, 0xF0F0F0F
        A = 32'h0000000F;
        funct3 = 3'b100;
        #10;
        $display("XORI: A=%h, imm=%h, Y=%h (Expect 0xF)", A, imm_out, Y);

        // 測試 ORI (110 funct3) (OR)
        instr = 32'hF0F0F0F3; // ORI x8, x1, 0xF0F0F0F
        A = 32'h0000F0F0;
        funct3 = 3'b110;
        #10;
        $display("ORI: A=%h, imm=%h, Y=%h (Expect 0x0F0F)", A, imm_out, Y);

        // 測試 ANDI (111 funct3) (AND)
        instr = 32'hF0F0F0F3; // ANDI x9, x1, 0xF0F0F0F
        A = 32'h0000F0F0;
        funct3 = 3'b111;
        #10;
        $display("ANDI: A=%h, imm=%h, Y=%h (Expect 00F000F0)", A, imm_out, Y);

        $display("------------------B-type 指令-------------------");
        opcode = 7'b1100011; // B-type 指令

        // 測試 BEQ (000 funct3) (A == B)
        instr = 32'h00050663; // BEQ x10, x0, offset
        A = 32'h00000010;
        funct3 = 3'b000;
        #10;
        $display("BEQ: A=%h, imm=%h, Y=%b (Expect 1)", A, imm_out, Y);

        // 測試 BNE (001 funct3) (A != B)
        instr = 32'h00051663; // BNE x10, x0, offset
        A = 32'h00000010;
        funct3 = 3'b001;
        #10;
        $display("BNE: A=%h, imm=%h, Y=%b (Expect 1)", A, imm_out, Y);

        // 測試 BLT (100 funct3) (A < B, 有號)
        instr = 32'h00054663; // BLT x10, x0, offset
        A = 32'hFFFFFFF0;
        funct3 = 3'b100;
        #10;
        $display("BLT: A=%h, imm=%h, Y=%b (Expect 1)", A, imm_out, Y);

        // 測試 BGE (101 funct3) (A >= B, 有號)
        instr = 32'h00055663; // BGE x10, x0, offset
        A = 32'h00000010;
        funct3 = 3'b101;
        #10;
        $display("BGE: A=%h, imm=%h, Y=%b (Expect 1)", A, imm_out, Y);

        // 測試 BLTU (110 funct3) (A < B, 無號)
        instr = 32'h00056663; // BLTU x10, x0, offset
        A = 32'h00000010;
        funct3 = 3'b110;
        #10;
        $display("BLTU: A=%h, imm=%h, Y=%b (Expect 1)", A, imm_out, Y);

        // 測試 BGEU (111 funct3) (A >= B, 無號)
        instr = 32'h00057663; // BGEU x10, x0, offset
        A = 32'hFFFFFFF0;
        funct3 = 3'b111;
        #10;
        $display("BGEU: A=%h, imm=%h, Y=%b (Expect 1)", A, imm_out, Y);

        $finish;
    end
endmodule

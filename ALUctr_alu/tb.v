`timescale 1ns / 100ps
/*
          ┌──────────────────────────────────────────────────┐
          │                     ALUctr                      │
          ├──────────────────────────────────────────────────┤
          │ opcode [6:0]  ─────────► │                      │
          │ funct3 [2:0]  ─────────► │                      │
          │ funct7 [6:0]  ─────────► │   ALU 操作碼產生     │
          │                          │                      │
          │       ALUop [4:0]  ◄─────│                      │
          └──────────────────────────────────────────────────┘
                               │
                               ▼
          ┌──────────────────────────────────────────────────┐
          │                     ALU                         │
          ├──────────────────────────────────────────────────┤
          │ A [31:0]    ─────────────────────────────────►   │
          │ B [31:0]    ─────────────────────────────────►   │
          │ ALUop [4:0] ────────────────────────────────►   │
          │                                                 │
          │      (ALU 運算: ADD, SUB, SLL, SLT, AND, OR...)  │
          │                                                 │
          │    Y [31:0]   ◄───────────────────────────────  │
          │    zero       ◄───────────────────────────────  │
          └──────────────────────────────────────────────────┘
*/
module ALU_ALUctr_tb;
    reg [31:0] A, B;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [4:0] ALUop;
    wire [31:0] Y;
    wire zero;

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
        .B(B),
        .ALUop(ALUop),
        .Y(Y),
        .zero(zero)
    );

    // 測試程序
    initial begin
        $display("ALU+aluctr : Testbench");
        $dumpfile("ALU_ALUctr_tb.vcd");  // VCD 波形輸出
        $dumpvars(0, ALU_ALUctr_tb);
        /*
        $display("------------------R-type 指令-------------------");
        // 測試 R-type 指令
        opcode = 7'b0110011; // R-type 指令

        // 測試 ADD (0000000 funct7, 000 funct3)
        A = 32'h00000010; B = 32'h00000020; funct3 = 3'b000; funct7 = 7'b0000000;
        #10;
        $display("ADD: A=%h, B=%h, Y=%h (Expect 30)", A, B, Y);

        // 測試 SUB (0100000 funct7, 000 funct3)
        A = 32'h00000030; B = 32'h00000010; funct3 = 3'b000; funct7 = 7'b0100000;
        #10;
        $display("SUB: A=%h, B=%h, Y=%h (Expect 20)", A, B, Y);

        // 測試 SLL (0000000 funct7, 001 funct3)
        A = 32'h00000001; B = 32'h00000002; funct3 = 3'b001; funct7 = 7'b0000000;
        #10;
        $display("SLL: A=%h, B=%h, Y=%h (Expect 4)", A, B, Y);

        // 測試 SLT (0000000 funct7, 010 funct3) (有號比較)
        A = 32'hFFFFFFF0; B = 32'h00000010; funct3 = 3'b010; funct7 = 7'b0000000;
        #10;
        $display("SLT: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 SLTU (0000000 funct7, 011 funct3) (無號比較)
        A = 32'h00000010; B = 32'hFFFFFFF0; funct3 = 3'b011; funct7 = 7'b0000000;
        #10;
        $display("SLTU: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 XOR (0000000 funct7, 100 funct3)
        A = 32'h0000000F; B = 32'h000000F0; funct3 = 3'b100; funct7 = 7'b0000000;
        #10;
        $display("XOR: A=%h, B=%h, Y=%h (Expect 0xFF)", A, B, Y);

        // 測試 SRL (0000000 funct7, 101 funct3)
        // 00000010 >> 2 = 00000004
        A = 32'h00000010; B = 32'h00000002; funct3 = 3'b101; funct7 = 7'b0000000;
        #10;
        $display("SRL: A=%h, B=%h, Y=%h (Expect 4)", A, B, Y);

        // 測試 SRA (0100000 funct7, 101 funct3)
        // 80000000 >> 2 = E0000000
        A = 32'h80000000; B = 32'h00000002; funct3 = 3'b101; funct7 = 7'b0100000;
        #10;
        $display("SRA: A=%h, B=%h, Y=%h (Expect E0000000)", A, B, Y);

        // 測試 OR (0000000 funct7, 110 funct3)
        // 0000F0F0 | 00F000F0 = 00F0F0F0
        A = 32'h0000F0F0; B = 32'h00F000F0; funct3 = 3'b110; funct7 = 7'b0000000;
        #10;
        $display("OR: A=%h, B=%h, Y=%h (Expect 00F0F0F0)", A, B, Y);

        // 測試 AND (0000000 funct7, 111 funct3)
        A = 32'h0000F0F0; B = 32'h00F000F0; funct3 = 3'b111; funct7 = 7'b0000000;
        #10;
        $display("AND: A=%h, B=%h, Y=%h (Expect 00F000F0)", A, B, Y);

        $display("------------------I-type 指令-------------------");
        // 測試 I-type 指令 基本差別在有沒有牽扯到imm
        opcode = 7'b0010011; // I-type 指令

        // 測試 ADDI (000 funct3)
        A = 32'h00000010; B = 32'h00000010; funct3 = 3'b000; funct7 = 7'b0000000;
        #10;
        $display("ADDI: A=%h, B=%h, Y=%h (Expect 20)", A, B, Y);
        //SLTI rd, rs1, imm  // rd = (rs1 < imm) ? 1 : 0 （有符號比較）
        // 測試 SLTI (010 funct3)
        //SLTI x5, x1, 
        //比較 -5 < 3（成立），因此 x5 = 1。
        A = 32'hFFFFFFF0; B = 32'h00000010; funct3 = 3'b010; funct7 = 7'b0000000;
        #10;
        $display("SLTI: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);
        //無符號比較
        // LTI x5, x1, 
        // 比較 |-5| < 3（不盛成立），因此 x5 = 0
        // 測試 SLTIU (011 funct3)
        A = 32'h00000010; B = 32'hFFFFFFF0; funct3 = 3'b011; funct7 = 7'b0000000;
        #10;
        $display("SLTIU: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 XORI (100 funct3)
        // 與常數immXOR
        A = 32'h0000000F; B = 32'h000000F0; funct3 = 3'b100; funct7 = 7'b0000000;
        #10;
        $display("XORI: A=%h, B=%h, Y=%h (Expect FFF)", A, B, Y);

        // 測試 ORI (110 funct3)
        A = 32'h0000F0F0; B = 32'h00F000F0; funct3 = 3'b110; funct7 = 7'b0000000;
        #10;
        $display("ORI: A=%h, B=%h, Y=%h (Expect F0F0F0F0)", A, B, Y);

        // 測試 ANDI (111 funct3)
        A = 32'h0000F0F0; B = 32'h00F000F0; funct3 = 3'b111; funct7 = 7'b0000000;
        #10;
        $display("ANDI: A=%h, B=%h, Y=%h (Expect 00F000F0)", A, B, Y);

        // 測試 zero flag
        A = 32'h00000010; B = 32'h00000010; funct3 = 3'b000; funct7 = 7'b0100000;
        #10;
        $display("Zero Flag: A=%h, B=%h, Y=%h, Zero=%b (Expect Zero=1)", A, B, Y, zero);
        #10
        */
        $display("------------------B-type 指令-------------------");
        opcode = 7'b1100011; // B-type 指令
        $display("op : %b", opcode);
        // 測試 BEQ (A == B)
        A = 32'h00000010; B = 32'h00000010; funct3 = 3'b000;
        #10;
        $display("BEQ: A=%h, B=%h, Y=%b (Expect 1)", A, B, Y);

        // 測試 BNE (A != B)
        A = 32'h00000010; B = 32'h00000020; funct3 = 3'b001;
        #10;
        $display("BNE: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 BLT (A < B, 有號)
        A = 32'hFFFFFFF0; B = 32'h00000010; funct3 = 3'b100;
        #10;
        $display("BLT: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 BGE (A >= B, 有號)
        A = 32'h00000010; B = 32'hFFFFFFF0; funct3 = 3'b101;
        #10;
        $display("BGE: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 BLTU (A < B, 無號)
        A = 32'h00000010; B = 32'hFFFFFFF0; funct3 = 3'b110;
        #10;
        $display("BLTU: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 BGEU (A >= B, 無號)
        A = 32'hFFFFFFF0; B = 32'h00000010; funct3 = 3'b111;
        #10;
        $display("BGEU: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);


        $finish;
    end
endmodule

`timescale 1ns / 1ps

module ALU_tb;
    reg [31:0] A, B;
    reg [4:0] ALUop;
    wire [31:0] Y;
    wire zero;

    // ALU 實例化
    ALU uut (
        .A(A),
        .B(B),
        .ALUop(ALUop),
        .Y(Y),
        .zero(zero)
    );

    // 測試程序
    initial begin
        $dumpfile("ALU_tb.vcd");  // VCD 波形輸出
        $dumpvars(0, ALU_tb);

        // 測試 ADD (00000)
        A = 32'h00000010; B = 32'h00000020; ALUop = 5'b00000;
        #10;
        $display("ADD: A=%h, B=%h, Y=%h (Expect 30)", A, B, Y);

        // 測試 SUB (00001)
        A = 32'h00000030; B = 32'h00000010; ALUop = 5'b00001;
        #10;
        $display("SUB: A=%h, B=%h, Y=%h (Expect 20)", A, B, Y);

        // 測試 SLL (00010)
        A = 32'h00000001; B = 32'h00000002; ALUop = 5'b00010;
        #10;
        $display("SLL: A=%h, B=%h, Y=%h (Expect 4)", A, B, Y);

        // 測試 SLT (00011) (有號比較)
        A = 32'hFFFFFFF0; B = 32'h00000010; ALUop = 5'b00011;
        #10;
        $display("SLT: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 SLTU (00100) (無號比較)
        A = 32'h00000010; B = 32'hFFFFFFF0; ALUop = 5'b00100;
        #10;
        $display("SLTU: A=%h, B=%h, Y=%h (Expect 1)", A, B, Y);

        // 測試 XOR (00101)
        A = 32'h0000000F; B = 32'h000000F0; ALUop = 5'b00101;
        #10;
        $display("XOR: A=%h, B=%h, Y=%h (Expect 0xFF)", A, B, Y);

        // 測試 SRL (00110)
        A = 32'h00000010; B = 32'h00000002; ALUop = 5'b00110;
        #10;
        $display("SRL: A=%h, B=%h, Y=%h (Expect 4)", A, B, Y);

        // 測試 SRA (00111)
        A = 32'h80000000; B = 32'h00000002; ALUop = 5'b00111;
        #10;
        $display("SRA: A=%h, B=%h, Y=%h (Expect E0000000)", A, B, Y);

        // 測試 OR (01000)
        A = 32'h0000F0F0; B = 32'h00F000F0; ALUop = 5'b01000;
        #10;
        $display("OR: A=%h, B=%h, Y=%h (Expect 00F0F0F0)", A, B, Y);

        // 測試 AND (01001)
        A = 32'h0000F0F0; B = 32'h00F000F0; ALUop = 5'b01001;
        #10;
        $display("AND: A=%h, B=%h, Y=%h (Expect 000000F0)", A, B, Y);

        // 測試 zero flag
        A = 32'h00000010; B = 32'h00000010; ALUop = 5'b00001;
        #10;
        $display("Zero Flag: A=%h, B=%h, Y=%h, Zero=%b (Expect Zero=1)", A, B, Y, zero);

        $finish;
    end
endmodule

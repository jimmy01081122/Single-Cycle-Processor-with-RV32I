`timescale 1ns / 100ps

module alu_tb;

    reg [31:0] A, B;
    reg [3:0] ALUOp;
    wire [31:0] Result;
    wire Zero;

    // 例化 ALU
    ALU uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin
        // 測試 ADD
        $display("ADD");
        A = 32'd10; B = 32'd5; ALUOp = 4'b0000; #10;
        // 測試 SUB
        $display("SUB");
        A = 32'd10; B = 32'd10; ALUOp = 4'b0001; #10;
        // 測試 AND
        $display("AND");
        A = 32'hFFFFFFFF; B = 32'h0000FFFF; ALUOp = 4'b0010; #10;
        // 測試 OR
        $display("OR");
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUOp = 4'b0011; #10;
        // 測試 XOR
        $display("XOR");
        A = 32'h12345678; B = 32'h87654321; ALUOp = 4'b0100; #10;
        // 測試 SLL
        $display("SLL");
        A = 32'd1; B = 32'd3; ALUOp = 4'b0101; #10;
        // 測試 SRL
        $display("SRL");
        A = 32'h80000000; B = 32'd3; ALUOp = 4'b0110; #10;
        // 測試 SRA
        $display("SRA");
        A = 32'h80000000; B = 32'd3; ALUOp = 4'b0111; #10;
        // 測試 SLT
        $display("SLT");
        A = 32'd10; B = 32'd20; ALUOp = 4'b1000; #10;
        // 測試 SLTU
        $display("SLTU");
        A = 32'hFFFFFFFF; B = 32'd1; ALUOp = 4'b1001; #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | A=%h | B=%h | ALUOp=%b | Result=%h | Zero=%b", 
                 $time, A, B, ALUOp, Result, Zero);
    end

endmodule

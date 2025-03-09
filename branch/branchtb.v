`timescale 1ns / 1ps

module branch_comparator_tb;

    reg [31:0] rs1, rs2;
    reg [2:0] funct3;
    wire BranchTaken;

    // 例化 Branch Comparator
    BranchComparator uut (
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .BranchTaken(BranchTaken)
    );

    initial begin
        // 測試 BEQ (相等)
        rs1 = 32'd10; rs2 = 32'd10; funct3 = 3'b000; #10;
        // 測試 BNE (不等)
        rs1 = 32'd10; rs2 = 32'd5; funct3 = 3'b001; #10;
        // 測試 BLT (小於)
        rs1 = 32'd5; rs2 = 32'd10; funct3 = 3'b100; #10;
        // 測試 BGE (大於等於)
        rs1 = 32'd10; rs2 = 32'd5; funct3 = 3'b101; #10;
        // 測試 BGE (相等)
        rs1 = 32'd10; rs2 = 32'd10; funct3 = 3'b101; #10;
        // 測試 BLT (不小於)
        rs1 = 32'd10; rs2 = 32'd5; funct3 = 3'b100; #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | RS1=%d | RS2=%d | Funct3=%b | BranchTaken=%b",
                 $time, rs1, rs2, funct3, BranchTaken);
    end

endmodule

`timescale 1ns / 100ps

module alu_control_tb;

    reg [1:0] ALUOp;
    reg [2:0] Funct3;
    reg [6:0] Funct7;
    wire [3:0] ALUControl;

    // 例化 ALUControl
    ALUControl uut (
        .ALUOp(ALUOp),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .ALUControl(ALUControl)
    );

    initial begin
        // 測試 LW（ALU 應執行 ADD）
        ALUOp = 2'b00; Funct3 = 3'b000; Funct7 = 7'b0000000; #10;
        // 測試 BEQ（ALU 應執行 SUB）
        ALUOp = 2'b01; Funct3 = 3'b000; Funct7 = 7'b0000000; #10;
        // 測試 R-type ADD（Funct7=0）
        ALUOp = 2'b10; Funct3 = 3'b000; Funct7 = 7'b0000000; #10;
        // 測試 R-type SUB（Funct7=1）
        ALUOp = 2'b10; Funct3 = 3'b000; Funct7 = 7'b0100000; #10;
        // 測試 R-type OR
        ALUOp = 2'b10; Funct3 = 3'b110; Funct7 = 7'b0000000; #10;
        // 測試 R-type SRA
        ALUOp = 2'b10; Funct3 = 3'b101; Funct7 = 7'b0100000; #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | ALUOp=%b | Funct3=%b | Funct7=%b | ALUControl=%b",
                 $time, ALUOp, Funct3, Funct7, ALUControl);
    end

endmodule

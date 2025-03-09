module ALU (
    input wire [31:0] A, B,   // ALU 兩個輸入值
    input wire [3:0] ALUOp,   // ALU 控制信號
    output reg [31:0] Result, // 計算結果
    output reg Zero          // Zero flag (當 Result == 0)
);

always @(*) begin
    case (ALUOp)
        4'b0000: Result = A + B;  // ADD
        4'b0001: Result = A - B;  // SUB
        4'b0010: Result = A & B;  // AND
        4'b0011: Result = A | B;  // OR
        4'b0100: Result = A ^ B;  // XOR
        4'b0101: Result = A << B[4:0];  // SLL
        4'b0110: Result = A >> B[4:0];  // SRL
        4'b0111: Result = $signed(A) >>> B[4:0];  // SRA
        4'b1000: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;  // SLT (signed)
        4'b1001: Result = (A < B) ? 32'b1 : 32'b0;  // SLTU (unsigned)
        default: Result = 32'b0;
    endcase
    
    // Zero flag
    Zero = (Result == 32'b0) ? 1'b1 : 1'b0;
end

endmodule

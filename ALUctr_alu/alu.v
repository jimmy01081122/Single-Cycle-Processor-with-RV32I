
//----------------------------- ALU 模組 -----------------------------
module ALU (
    input  [31:0] A,       // 來源操作數1
    input  [31:0] B,       // 來源操作數2
    input  [4:0]  ALUop,   // 由 ALUctr 輸入的操作碼
    output reg [31:0] Y,   // 計算結果
    output zero            // 結果是否為 0
);

    wire [31:0] sub_temp;
    assign sub_temp = A - B;

    always @(*) begin
        case (ALUop)
        //ALUop為自訂義，不是ISA來的
        //R-type
            5'b00000: Y = A + B;                  // ALU_ADD
            5'b00001: Y = A - B;                  // ALU_SUB
            5'b00010: Y = A << B[4:0];            // ALU_SLL
            5'b00011: Y = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;  // ALU_SLT (有號比較)
            5'b00100: Y = (A < B) ? 32'b1 : 32'b0; // ALU_SLTU (無號比較)
            5'b00101: Y = A ^ B;                  // ALU_XOR
            5'b00110: Y = A >> B[4:0];            // ALU_SRL (邏輯右移)
            5'b00111: Y = $signed(A) >>> B;  // ALU_SRA (算術右移)
            5'b01000: Y = A | B;                  // ALU_OR
            5'b01001: Y = A & B;                  // ALU_AND
            default:  Y = 32'b0;
        //B-type
        // B-type 比較指令
            5'b01010: Y = (A - B) ? 32'b1 : 32'b0; // BEQ
            5'b01011: Y = (A != B) ? 32'b1 : 32'b0; // BNE
            5'b01100: Y = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;  // BLT (有號)
            5'b01101: Y = ($signed(A) >= $signed(B)) ? 32'b1 : 32'b0; // BGE (有號)
            5'b01110: Y = (A < B) ? 32'b1 : 32'b0;  // BLTU (無號)
            5'b01111: Y = (A >= B) ? 32'b1 : 32'b0; // BGEU (無號)

        endcase
    end

    // zero flag：當計算結果為0時拉高
    assign zero = (Y == 32'b0) ? 1'b1 : 1'b0;

endmodule

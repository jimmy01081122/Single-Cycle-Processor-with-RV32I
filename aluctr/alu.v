module ALU (
    input  [31:0] A,       
    input  [31:0] B,       
    input  [4:0]  ALUop,   
    output reg [31:0] Y,   
    output zero            
);

    always @(*) begin
        case (ALUop)
        // R-type
            5'b00000: Y = A + B;                   // ADD
            5'b00001: Y = A - B;                   // SUB
            5'b00010: Y = A << B[4:0];             // SLL
            5'b00011: Y = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;  // SLT
            5'b00100: Y = (A < B) ? 32'd1 : 32'd0;  // SLTU
            5'b00101: Y = A ^ B;                   // XOR
            5'b00110: Y = A >> B[4:0];             // SRL
            5'b00111: Y = $signed(A) >>> B[4:0];   // SRA
            5'b01000: Y = A | B;                   // OR
            5'b01001: Y = A & B;                   // AND

        // B-type
            5'b01010: Y = (A == B) ? 32'd1 : 32'd0; // BEQ
            5'b01011: Y = (A != B) ? 32'd1 : 32'd0; // BNE
            5'b01100: Y = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;  // BLT
            5'b01101: Y = ($signed(A) >= $signed(B)) ? 32'd1 : 32'd0; // BGE
            5'b01110: Y = (A < B) ? 32'd1 : 32'd0;   // BLTU
            5'b01111: Y = (A >= B) ? 32'd1 : 32'd0;  // BGEU

        default:  Y = 32'd0; // 沒定義到的就給 0
        endcase
    end

    assign zero = (Y == 32'd0);

endmodule

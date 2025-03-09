module ALUControl (
    input wire [1:0] ALUOp,  // 來自控制單元的 ALU 操作碼
    input wire [2:0] Funct3, // 來自指令的 funct3
    input wire [6:0] Funct7, // 來自指令的 funct7
    output reg [3:0] ALUControl // 輸出 ALU 控制訊號
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000; // LW, SW, ADDI -> ADD
        2'b01: ALUControl = 4'b0001; // BEQ, BNE -> SUB
        2'b10: begin // R-type 指令
            case (Funct3)
                3'b000: ALUControl = (Funct7 == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB or ADD
                3'b001: ALUControl = 4'b0010; // SLL
                3'b010: ALUControl = 4'b0011; // SLT
                3'b011: ALUControl = 4'b0100; // SLTU
                3'b100: ALUControl = 4'b0101; // XOR
                3'b101: ALUControl = (Funct7 == 7'b0100000) ? 4'b0111 : 4'b0110; // SRA or SRL
                3'b110: ALUControl = 4'b1000; // OR
                3'b111: ALUControl = 4'b1001; // AND
                default: ALUControl = 4'b0000; // 預設為 ADD
            endcase
        end
        default: ALUControl = 4'b0000; // 預設為 ADD
    endcase
    $display("ALUOp = %b, Funct3 = %b, Funct7 = %b, ALUControl = %b", ALUOp, Funct3, Funct7, ALUControl);
end

endmodule

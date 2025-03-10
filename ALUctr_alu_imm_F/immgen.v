//------------------------- Immediate Generator (ImmGen) 模組 -------------------------
/*
 ┌─────────── 32-bit 指令格式 ───────────┐
 │  imm[11:0]  |  rs1  | funct3 |  rd  | opcode |
 │  31:20      | 19:15 | 14:12  | 11:7 | 6:0    |
 └──────────────────────────────────────┘
*/
module ImmGen (
    input  [31:0] instr,     // 指令
    output reg [31:0] imm_out // 立即數輸出
);

    always @(*) begin
        case (instr[6:0]) 
            7'b0010011: // I-type (ADDI, ORI, ANDI, SLTI, ...)
                imm_out = {{20{instr[31]}}, instr[31:20]}; // 符號擴展
            7'b1100011: // B-type (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // Branch offset
            default:
                imm_out = 32'b0;
        endcase
    end
endmodule

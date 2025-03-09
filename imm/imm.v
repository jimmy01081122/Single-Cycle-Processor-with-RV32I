/*
 * imm.v
 * 
 * 產生指令的立即數
 *
 */
module ImmediateGenerator (
    input wire [31:0] instr,   // 32-bit 指令
    output reg [31:0] imm_out  // 立即數輸出
);

wire [6:0] opcode = instr[6:0]; // 取出 opcode

always @(*) begin
    case (opcode)
        7'b0010011, // I-type (ADDI, ANDI, ORI, etc.)
        7'b0000011, // I-type (LW)
        7'b1100111: // I-type (JALR)
            imm_out = {{20{instr[31]}}, instr[31:20]}; // 符號擴展
        
        7'b0100011: // S-type (SW)
            imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // 符號擴展
        
        7'b1100011: // B-type (BEQ, BNE, BLT, BGE)
            imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // 符號擴展
        
        7'b0110111, // U-type (LUI)
        7'b0010111: // U-type (AUIPC)
            imm_out = {instr[31:12], 12'b0}; // 左移 12 位
        
        7'b1101111: // J-type (JAL)
            imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // 符號擴展
        
        default:
            imm_out = 32'b0; // 預設 0
    endcase
end

endmodule

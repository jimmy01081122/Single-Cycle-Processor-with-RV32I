/*
******************************************************************************
* RISC-V RV32I Instruction Set (ALU 相關指令) 簡要表格
* ----------------------------------------------------------------------------
* 以下列出部分和 ALU 有關之指令 (R 類型與 I 類型)，實際上 RV32I 還包含
* load/store、branch、jump、system 等其他指令，請自行參閱官方文件。
*
* R-type (opcode = 0110011):
* ----------------------------------------------------------------------------
* 指令   | funct7   | funct3  | opcode   | 功能說明
* ----------------------------------------------------------------------------
* ADD    | 0000000  | 000     | 0110011  | Rd = Rs1 + Rs2
* SUB    | 0100000  | 000     | 0110011  | Rd = Rs1 - Rs2
* SLL    | 0000000  | 001     | 0110011  | Rd = Rs1 << (Rs2[4:0])
* SLT    | 0000000  | 010     | 0110011  | Rd = (Rs1 < Rs2) ? 1 : 0 (有號比較)
* SLTU   | 0000000  | 011     | 0110011  | Rd = (Rs1 < Rs2) ? 1 : 0 (無號比較)
* XOR    | 0000000  | 100     | 0110011  | Rd = Rs1 ^ Rs2
* SRL    | 0000000  | 101     | 0110011  | Rd = Rs1 >> (Rs2[4:0]) (邏輯右移)
* SRA    | 0100000  | 101     | 0110011  | Rd = Rs1 >> (Rs2[4:0]) (算術右移)
* OR     | 0000000  | 110     | 0110011  | Rd = Rs1 | Rs2
* AND    | 0000000  | 111     | 0110011  | Rd = Rs1 & Rs2
*
* I-type (opcode = 0010011)：
* ----------------------------------------------------------------------------
* 指令    | funct7(部分用於移位) | funct3  | opcode   | 功能說明
* ----------------------------------------------------------------------------
* ADDI    |    -    | 000     | 0010011  | Rd = Rs1 + sign_ext(imm)
* SLTI    |    -    | 010     | 0010011  | Rd = (Rs1 < imm) ? 1 : 0
* SLTIU   |    -    | 011     | 0010011  | Rd = (Rs1 < imm) ? 1 : 0 (無號)
* XORI    |    -    | 100     | 0010011  | Rd = Rs1 ^ imm
* ORI     |    -    | 110     | 0010011  | Rd = Rs1 | imm
* ANDI    |    -    | 111     | 0010011  | Rd = Rs1 & imm
* SLLI    | 0000000 | 001     | 0010011  | Rd = Rs1 << shamt
* SRLI    | 0000000 | 101     | 0010011  | Rd = Rs1 >> shamt (邏輯)
* SRAI    | 0100000 | 101     | 0010011  | Rd = Rs1 >> shamt (算術)
*
******************************************************************************
*/

//------------------------- ALU Control 模組 -------------------------
module ALUctr (
    input  [6:0] opcode,      // 指令的 opcode (例如 0110011, 0010011 等)
    input  [2:0] funct3,      // 指令的 funct3 欄位
    input  [6:0] funct7,      // 指令的 funct7 欄位 (只需部分 bit 區分 ADD/SUB, SRL/SRA)
    output reg [4:0] ALUop     // ALU 操作碼 (可依實際需求擴增位數)
);

    // 定義 ALUop 常數 (依據自己的設計需求而定)
    localparam ALU_ADD  = 5'b00000;
    localparam ALU_SUB  = 5'b00001;
    localparam ALU_SLL  = 5'b00010;
    localparam ALU_SLT  = 5'b00011;
    localparam ALU_SLTU = 5'b00100;
    localparam ALU_XOR  = 5'b00101;
    localparam ALU_SRL  = 5'b00110;
    localparam ALU_SRA  = 5'b00111;
    localparam ALU_OR   = 5'b01000;
    localparam ALU_AND  = 5'b01001;
    // 如果要支援立即數或其他運算，可再擴增

    always @(*) begin
        case (opcode)
            7'b0110011: // R-type
                begin
                    case (funct3)
    //ref : https://velog.io/@taegon1998/2.2-2-Basic-of-RISC-V
                        3'b000: // ADD / SUB
                            ALUop = (funct7[5] == 1'b1) ? ALU_SUB : ALU_ADD;
                        3'b001: ALUop = ALU_SLL; //SLL
                        3'b010: ALUop = ALU_SLT; //SLT
                        3'b011: ALUop = ALU_SLTU; //SLTU
                        3'b100: ALUop = ALU_XOR; //XOR
                        //---------------same funct3-------------------------
                        3'b101: // SRL / SRA
                            ALUop = (funct7[5] == 1'b1) ? ALU_SRA : ALU_SRL;
                        //---------------------------------------------------
                        3'b110: ALUop = ALU_OR;
                        3'b111: ALUop = ALU_AND;
                        default: ALUop = ALU_ADD;  // 預設給個安全值
                    endcase
                end
            7'b0010011: // I-type (ADDI, SLTI, XORI, ORI, ANDI, SLLI, SRLI, SRAI ...)
                begin
    //ref : https://www.chegg.com/homework-help/questions-and-answers/risc-v-instruction-show-value-opcode-op-source-register-rsl-destination-register-id-fields-q85052084
                    case (funct3)
                        3'b000: ALUop = ALU_ADD;   // ADDI
                        3'b010: ALUop = ALU_SLT;   // SLTI
                        3'b011: ALUop = ALU_SLTU;  // SLTIU
                        3'b100: ALUop = ALU_XOR;   // XORI
                        3'b110: ALUop = ALU_OR;    // ORI
                        3'b111: ALUop = ALU_AND;   // ANDI
                        3'b001: ALUop = ALU_SLL;   // SLLI
                        3'b101: // SRLI / SRAI
                            ALUop = (funct7[5] == 1'b1) ? ALU_SRA : ALU_SRL;
                        default: ALUop = ALU_ADD; 
                    endcase
                end
            default:
                ALUop = ALU_ADD; // 其他暫時預設成 ADD
        endcase
    end

endmodule

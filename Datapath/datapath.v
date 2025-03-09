module Datapath (
    input wire clk, reset
);

    // 定義內部信號
    wire [31:0] pc, next_pc, instr, imm, rd1, rd2, alu_result, mem_read_data;
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1 = instr[19:15], rs2 = instr[24:20], rd = instr[11:7];
    wire [3:0] alu_control;
    wire [1:0] alu_op;
    wire branch_taken, reg_write, alu_src, mem_read, mem_write, mem_to_reg;
    wire [31:0] alu_src_b, write_data;
    
    // 例化 PC
    ProgramCounter pc_module (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // 例化指令記憶體
    InstructionMemory instr_mem (
        .addr(pc),
        .instr(instr)
    );

    // 例化控制單元
    ControlUnit control_unit (
        .opcode(opcode),
        .RegWrite(reg_write),
        .ALUSrc(alu_src),
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .Branch(branch_taken),
        .MemToReg(mem_to_reg),
        .ALUOp(alu_op)
    );

    // 例化立即數生成器
    ImmediateGenerator imm_gen (
        .instr(instr),
        .imm_out(imm)
    );

    // 例化暫存器檔案
    RegisterFile reg_file (
        .clk(clk),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_data),
        .rd1(rd1),
        .rd2(rd2)
    );

    // ALU 的第二個輸入來源（rs2 or Immediate）
    assign alu_src_b = alu_src ? imm : rd2;

    // 例化 ALU
    ALU alu (
        .A(rd1),
        .B(alu_src_b),
        .ALUOp(alu_control),
        .Result(alu_result),
        .Zero()
    );

    // 例化 ALU 控制單元
    ALUControl alu_control_unit (
        .ALUOp(alu_op),
        .Funct3(funct3),
        .ALUControl(alu_control)
    );

    // 例化數據記憶體
    DataMemory data_mem (
        .clk(clk),
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .addr(alu_result),
        .write_data(rd2),
        .read_data(mem_read_data)
    );

    // 例化分支比較單元
    BranchComparator branch_comp (
        .rs1(rd1),
        .rs2(rd2),
        .funct3(funct3),
        .BranchTaken(branch_taken)
    );

    // 決定是否要改變 PC
    assign next_pc = (branch_taken === 1'b1)  ? (pc + (imm << 1)) : (pc + 4);

    // 決定寫回暫存器的值
    assign write_data = mem_to_reg ? mem_read_data : alu_result;
/*/-------------------------------------------------------------------------
    //debug pc
    always @(*) begin
    $display("PC=%h | Instr=%h", pc, instr);
end
    //debug next pc
    always @(*) begin
    $display("Time=%0t | PC=%h | next_PC=%h | BranchTaken=%b | Instr=%h", 
              $time, pc, next_pc, branch_taken, instr);
end
   //debug for imm
    always @(*) begin
    $display("Time=%0t | Instr=%h | Imm=%h", $time, instr, imm);
end
    always @(*) begin
    $display("BranchCheck: rs1=%h | rs2=%h | funct3=%b | BranchTaken=%b", 
             rs1, rs2, funct3, branch_taken);
end
    //debug for reg
    always @(*) begin
    $display("RegFile: rs1=%h | rd1=%h | rs2=%h | rd2=%h | rd=%h | wd=%h | we=%b",
              rs1, rd1, rs2, rd2, rd, write_data, reg_write);
end
    //debug for branch
    always @(*) begin
    $display("BranchCheck: rs1=%h | rs2=%h | funct3=%b | BranchTaken=%b", 
             rs1, rs2, funct3, branch_taken);
end
    //debug for alu
    always @(*) begin
    $display("ALU: A=%h | B=%h | ALUOp=%b | Result=%h ", 
              rd1, alu_src_b, alu_control, alu_result);
end
*/

endmodule

module BranchComparator (
    input wire [31:0] rs1, rs2,  // 來源暫存器數值
    input wire [2:0] funct3,     // 控制類型（來自指令）
    output reg BranchTaken       // 分支是否成立
);

always @(*) begin
  if (rs1 === 32'bx || rs2 === 32'bx)
        BranchTaken = 1'b0;  // **防止 `BranchTaken` 變成 `x`**
    else begin
    case (funct3)
        3'b000: BranchTaken = (rs1 == rs2);  // BEQ (相等則跳躍)
        3'b001: BranchTaken = (rs1 != rs2);  // BNE (不等則跳躍)
        3'b100: BranchTaken = ($signed(rs1) < $signed(rs2)); // BLT (小於則跳躍)
        3'b101: BranchTaken = ($signed(rs1) >= $signed(rs2)); // BGE (大於等於則跳躍)
        default: BranchTaken = 0;
    endcase
    end
end

endmodule

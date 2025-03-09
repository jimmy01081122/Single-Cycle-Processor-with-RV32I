module ControlUnit (
    input wire [6:0] opcode,
    output reg RegWrite, ALUSrc, MemRead, MemWrite, Branch, MemToReg,
    output reg [1:0] ALUOp
);

always @(*) begin
    case (opcode)
        7'b0110011: begin // R-type
            RegWrite = 1; ALUSrc = 0; MemRead = 0;
            MemWrite = 0; Branch = 0; MemToReg = 0; ALUOp = 2'b10;
        end
        7'b0010011, // I-type (ADDI, ANDI, ORI)
        7'b0000011: begin // LW
            RegWrite = 1; ALUSrc = 1; MemRead = (opcode == 7'b0000011);
            MemWrite = 0; Branch = 0; MemToReg = (opcode == 7'b0000011);
            ALUOp = 2'b00;
        end
        7'b0100011: begin // S-type (SW)
            RegWrite = 0; ALUSrc = 1; MemRead = 0;
            MemWrite = 1; Branch = 0; MemToReg = 0; ALUOp = 2'b00;
        end
        7'b1100011: begin // B-type (BEQ, BNE)
            RegWrite = 0; ALUSrc = 0; MemRead = 0;
            MemWrite = 0; Branch = 1; MemToReg = 0; ALUOp = 2'b01;
        end
        7'b0110111, // U-type (LUI)
        7'b0010111: begin // AUIPC
            RegWrite = 1; ALUSrc = 1; MemRead = 0;
            MemWrite = 0; Branch = 0; MemToReg = 0; ALUOp = 2'b11;
        end
        7'b1101111, // J-type (JAL)
        7'b1100111: begin // JALR
            RegWrite = 1; ALUSrc = 1; MemRead = 0;
            MemWrite = 0; Branch = 0; MemToReg = 0; ALUOp = 2'b00;
        end
        default: begin // 預設情況
            RegWrite = 0; ALUSrc = 0; MemRead = 0;
            MemWrite = 0; Branch = 0; MemToReg = 0; ALUOp = 2'b00;
        end
    endcase
    $display("Opcode = %b, RegWrite = %b, ALUSrc = %b, MemRead = %b, MemWrite = %b, Branch = %b, MemToReg = %b, ALUOp = %b", 
         opcode, RegWrite, ALUSrc, MemRead, MemWrite, Branch, MemToReg, ALUOp);
end

endmodule

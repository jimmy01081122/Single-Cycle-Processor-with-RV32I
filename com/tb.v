module testbench;

    // 測試變數
    reg [31:0] A, B, instr;
    reg [2:0] Funct3;
    reg [6:0] Funct7;
    wire [3:0] ALUControl;
    wire [31:0] Result, imm_out;
    wire Zero;
    wire RegWrite, ALUSrc, MemRead, MemWrite, Branch, MemToReg;
    wire [1:0] ALUOpCtrl;

    // 實例化 ALU 模組
    ALU alu (
        .A(A),
        .B(B),
        .ALUOp(ALUControl), // 來自 ALUControl 模組
        .Result(Result),
        .Zero(Zero)
    );

    // 實例化 ALUControl 模組
    ALUControl alu_ctrl (
        .ALUOp(ALUOpCtrl),  // 來自 ControlUnit
        .Funct3(Funct3),
        .Funct7(Funct7),
        .ALUControl(ALUControl)
    );

    // 實例化 ControlUnit 模組
    ControlUnit ctrl_unit (
        .opcode(instr[6:0]),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .MemToReg(MemToReg),
        .ALUOp(ALUOpCtrl) // 輸出是 wire
    );

    // 實例化 ImmediateGenerator 模組
    ImmediateGenerator imm_gen (
        .instr(instr),
        .imm_out(imm_out)
    );

    // 初始化
    initial begin

        
        #10 A = 32'h30; B = 32'h20; Funct3 = 3'b000; Funct7 = 7'b0100000; instr = 32'b01000000000000000000000000110011; // R-Type SUB
    
        #10 A = 32'h21; B = 32'h15; Funct3 = 3'b111; instr = 32'b00000000000000000000000000110011; // R-Type AND
        #10 A = 32'h10; B = 32'h20; Funct3 = 3'b000; Funct7 = 7'b0100000; instr = 32'b01000000000000000000000000110011;
        #10 A = 32'h21; B = 32'h15; Funct3 = 3'b111; instr = 32'b00000000000000000000000000110011; // R-Type AND
        #10 A = 32'h21; B = 32'h15; Funct3 = 3'b111; instr = 32'b00000000000000000000000000110011; // R-Type AND
        
    end

    // 模擬結束後
    initial begin
        $monitor("Time : %0t / TESTBENCH HERE : A = %h, B = %h, ALUOp = %b, ALUControl = %b, Result = %h, Zero = %b, Imm_Out = %h\n", 
                 $time, A, B, ALUOpCtrl, ALUControl, Result, Zero, imm_out);
        #100;
        $finish;
    end

endmodule

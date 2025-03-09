`timescale 1ns / 100ps
/*
 * Register File Testbench
 * 
 * Test the Register File module by writing and reading registers.
 * 
 * The testbench writes values to registers x1 and x2, then reads them back.
 * It also tries to write to register x0, which should not be allowed.
 */
module register_file_tb;

    reg clk, we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    // 例化 Register File
    RegisterFile uut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // 時脈產生
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        we = 1;  // 允許寫入
        
        // 寫入 x1 = 10
        rd = 5'd1;
        wd = 32'd10;
        #10;
        
        // 寫入 x2 = 20
        rd = 5'd2;
        wd = 32'd20;
        #10;

        // 讀取 x1, x2
        we = 0;
        rs1 = 5'd1;
        rs2 = 5'd2;
        #10;

        // 測試 x0 是否不可寫入
        we = 1;
        rd = 5'd0;
        wd = 32'd100;
        #10;

        // 讀取 x0
        we = 0;
        rs1 = 5'd0;
        #10;

        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t | WE=%b | RD=%d | WD=%d | RS1=%d | RS2=%d | RD1=%d | RD2=%d", 
                  $time, we, rd, wd, rs1, rs2, rd1, rd2);
    end

endmodule

`timescale 1ns / 100ps

module datapath_tb;

    reg clk, reset;

    // 例化 Datapath
    Datapath uut (
        .clk(clk),
        .reset(reset)
    );

    // 產生時脈
    always #5 clk = ~clk;

    initial begin
        // 初始化
        clk = 0; reset = 1;
        #10 reset = 0;  // 解除 reset，開始運行

        #20 $finish;  // 執行 200ns 停止
    end

    initial begin
        $monitor("Time=%0t | PC=%h", $time, uut.pc);
    end

endmodule

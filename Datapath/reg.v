/*
 * Register file
 * 32 registers, 32-bit each
 * x0 is hardwired to 0
 */
module RegisterFile (
    input wire clk, we,
    input wire [4:0] rs1, rs2, rd,
    input wire [31:0] wd,
    output wire [31:0] rd1, rd2
);

reg [31:0] registers [31:0];
integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;  // **確保初始化為 0，而不是 `x`**
        end
    end

always @(posedge clk) begin
    if (we && (rd != 5'b00000))  // x0 永遠為 0
        registers[rd] <= wd;
end

assign rd1 = registers[rs1];
assign rd2 = registers[rs2];

endmodule

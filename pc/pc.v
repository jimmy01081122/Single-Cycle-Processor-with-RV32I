/*
 * Program Counter
 * 
 * The program counter is a register that holds the address of the next instruction
 */
module ProgramCounter (
    input wire clk, reset,
    input wire [31:0] next_pc,
    output reg [31:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'b0;
    else
        pc <= next_pc;
end

endmodule

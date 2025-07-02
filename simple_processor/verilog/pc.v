/*
- Simple 4-bit program counter
- Increments every clock cycle
- Resets to 0 on reset
*/

module pc (
    input  wire       clk,
    input  wire       reset,
    output reg  [3:0] pc_out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 4'd0;
        else
            pc_out <= pc_out + 4'd1;
    end

endmodule

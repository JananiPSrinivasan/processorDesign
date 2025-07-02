/*
- ALU: Arithmetic Logic Unit for custom ML processor
- Supports operations: NOP, ADD, MUL, ACT (step function)
*/


module alu(
    input wire [7:0] op1,
    input wire [7:0] op2,
    input wire [2:0] alu_ctrl,
    output reg [7:0] result
);

    always @(*) begin
        case (alu_ctrl)
        3'b000: result = op1; // pass through
        3'b001: result = op1 + op2; // ADD 
        3'b010: result = op1 * op2; // MUL 
        3'b011: result = (op1>0) ? 8'd1 :8'd0 ;// ACT : outputs 1 if input > 0, else 0
        default: result =8'd0;
        endcase
    end
endmodule
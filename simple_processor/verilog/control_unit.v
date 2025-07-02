/*
The control unit is the part of the processor that interprets instructions and 
generates the necessary control signals to execute them.
It is essentially the decision-maker in your CPU.

- It decodes the opcode (0000, 0010 etc from the instruction memeory) 
- extracts the operand address (last 4 bits from the instruction memory on where to store what)
- Outputs the control (to ALU, register file, the data memory or the write back logic)
*/
/*
- control.v
- Decodes the 8-bit instruction and generates control signals
*/

module control (
    input  wire [7:0] instr,        // Full 8-bit instruction

    output wire [3:0] opcode,       // Upper 4 bits of instr
    output wire [3:0] operand,      // Lower 4 bits of instr

    output reg  [2:0] alu_ctrl,     // ALU operation selector
    output reg        reg_we,       // Register write enable
    output reg        mem_we        // Data memory write enable
    );

    // Split instruction into opcode and operand
    assign opcode  = instr[7:4];
    assign operand = instr[3:0];

    // Generate control signals based on opcode
    always @(*) begin
        // Default values
        alu_ctrl = 3'b000; // NOP
        reg_we   = 1'b0;
        mem_we   = 1'b0;

        case (instr[7:4])
            4'b0000: begin // LOAD
                alu_ctrl = 3'b000; // NOP / passthrough
                reg_we   = 1'b1;
            end

            4'b0001: begin // STORE
                alu_ctrl = 3'b000;
                mem_we   = 1'b1;
            end

            4'b0010: begin // MUL
                alu_ctrl = 3'b010;
                reg_we   = 1'b1;
            end

            4'b0100: begin // ADD
                alu_ctrl = 3'b001;
                reg_we   = 1'b1;
            end

            4'b0110: begin // ACT (step)
                alu_ctrl = 3'b011;
                reg_we   = 1'b1;
            end

            4'b1111: begin // NOP / HALT
                alu_ctrl = 3'b000;
            end

            default: begin
                alu_ctrl = 3'b000;
            end
        endcase
    end

endmodule

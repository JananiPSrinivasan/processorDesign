/*
- top.v
- Top-level processor module
- Integrates PC, instruction memory, control unit, and datapath
*/

module top (
    input wire clk,
    input wire reset,

    output wire [7:0] mem_read_data  // Final output (e.g., classification result)
);

    // 4-bit Program Counter (can address 16 instructions)
    wire [3:0] pc;

    // Instruction fetched from ROM
    wire [7:0] instr;

    // Decoded fields
    wire [3:0] opcode;
    wire [3:0] operand;

    // Control signals
    wire [2:0] alu_ctrl;
    wire       reg_we;
    wire       mem_we;

    // Instruction Memory
    instruction_memory imem (
        .addr(pc),
        .instruction(instr)
    );

    // Control Unit
    control cu (
        .instr(instr),
        .opcode(opcode),
        .operand(operand),
        .alu_ctrl(alu_ctrl),
        .reg_we(reg_we),
        .mem_we(mem_we)
    );

    // Datapath
    datapath dp (
        .clk(clk),
        .opcode(opcode),
        .operand(operand),
        .alu_ctrl(alu_ctrl),
        .reg_we(reg_we),
        .mem_we(mem_we),
        .mem_read_data(mem_read_data)
    );


    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_out(pc)
);


endmodule

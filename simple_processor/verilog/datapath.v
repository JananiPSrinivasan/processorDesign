/*
The datapath is used to
- Wires together register file, ALU, data memory
- Execute the operation specified by opcode + control signals

The datapath receives:
    -The instruction (split into opcode and operand)
    -The control signals (from the control unit)
    -Clock and reset signals

It manages:
    - Reading from registers
    - Performing ALU operations
    - Accessing data memory
    - Writing back results to registers or memory

*/

module datapath (
    input  wire        clk,
    input  wire [3:0]  opcode,
    input  wire [3:0]  operand,
    input  wire [2:0]  alu_ctrl,
    input  wire        reg_we,
    input  wire        mem_we,

    output wire [7:0]  mem_read_data  // for external observation
);

    // Split operand into subfields
    wire [2:0] rs1 = operand[3:2];  // source register 1
    wire [2:0] rs2 = operand[1:0];  // source register 2
    wire [2:0] rd  = operand[3:1];  // dest register (for example)

    // Register file wires
    wire [7:0] reg_out1;
    wire [7:0] reg_out2;
    wire [7:0] reg_write_data;

    // ALU output
    wire [7:0] alu_result;

    // Data memory output
    wire [7:0] data_out;

    // Instantiate Register File
    register_file regfile (
        .clk(clk),
        .we(reg_we),
        .wr_addr(rd),
        .wr_data(reg_write_data),
        .rd_addr1(rs1),
        .rd_addr2(rs2),
        .rd_data1(reg_out1),
        .rd_data2(reg_out2)
    );

    // Instantiate ALU
    alu alu_unit (
        .op1(reg_out1),
        .op2(reg_out2),
        .alu_ctrl(alu_ctrl),
        .result(alu_result)
    );

    // Instantiate Data Memory
    data_memory mem (
        .clk(clk),
        .write_en(mem_we),
        .addr(operand[3:0]),
        .write_data(reg_out1),
        .read_data(data_out)
    );

    // Result routing logic
    // For LOAD: use data memory output
    // For ALU ops: use alu_result
    assign reg_write_data = (opcode == 4'b0000) ? data_out : alu_result;
    assign mem_read_data  = data_out;

endmodule

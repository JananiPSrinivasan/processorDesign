/*
- Instruction memory stores the program that the processor will execute.
- To understand the working, we consider this as ROM 

- ROM - Read only memory
- ROM is not writable at runtime and is hardcoded during design.
- Instructions here are written as case statements

- For this ROM design, there is one input and one output
- Input is the 4bit address of where to pick the instruction
- Output is an 8bit instruction
    - The split up of 8-bit wide instructions will be as 
    - [7:4] - op code (instr. address)
    - [3:2] - destination registers 
    - [1:0] - source registers (memory address)

- The 16-word indicates that it can hold a maximum of 16 instructions
- Since the input address is 4 bit wide, the processer can access 2pow4 = 16 memory locations

To set up the instrcutions the opcode, the oprands, instruction and operation is as follows


| Opcode  | Binary | Hex | Operands Format  | Instruction         | Operation                           |
| ------- | ------ | --- | ---------------- | ------------------- | ----------------------------------- |
| `LOAD`  | `0000` | 0x0 | `[Reg, MemAddr]` | `LOAD Rr, [Maddr]`  | `Rr ← MEM[Maddr]`                   |
| `STORE` | `0001` | 0x1 | `[Reg, MemAddr]` | `STORE Rr, [Maddr]` | `MEM[Maddr] ← Rr`                   |
| `MUL`   | `0010` | 0x2 | `[Rd, Rs]`       | `MUL Rd, Rs`        | `Rd ← Rd × Rs`                      |
| `MAC`   | `0011` | 0x3 | `[Rd, Rs]`       | `MAC Rd, Rs`        | `Rd ← Rd + (Rd × Rs)` *(optional)*  |
| `ADD`   | `0100` | 0x4 | `[Rd, Rs]`       | `ADD Rd, Rs`        | `Rd ← Rd + Rs`                      |
| `SUB`   | `0101` | 0x5 | `[Rd, Rs]`       | `SUB Rd, Rs`        | `Rd ← Rd - Rs` *(optional)*         |
| `ACT`   | `0110` | 0x6 | `[Rd]`           | `ACT Rd`            | `Rd ← step(Rd)`                     |
| `CMP`   | `0111` | 0x7 | `[R1, R2]`       | `CMP R1, R2`        | `ZF ← (R1 == R2)` *(optional)*      |
| `JMP`   | `1000` | 0x8 | `[Addr]`         | `JMP Addr`          | `PC ← Addr` *(optional)*            |
| `BEQ`   | `1001` | 0x9 | `[Addr]`         | `BEQ Addr`          | `PC ← Addr if ZF == 1` *(optional)* |
| `NOP`   | `1110` | 0xE | —                | `NOP`               | No operation                        |
| `HALT`  | `1111` | 0xF | —                | `HALT`              | Stop execution                      |


*/


module instruction_memory(
    input wire [3:0] addr,
    output reg [7:0] instruction
);

    always @(*) begin
        case (addr)
            //addr : instruction = 8'b[Opcode + Operands];
            4'd0: instruction = 8'b00000000 ; // LOAD R0, MEM[0]
            4'd1: instruction = 8'b00000001 ; // LOAD R1, MEM[1]
            4'd2: instruction = 8'b01000001 ; // MUL R2= R0*R1 
            4'd3: instruction = 8'b00000010 ; // LOAD R0, MEM[2]
            4'd4: instruction = 8'b00000011 ; // LOAD R1, MEM[3]
            4'd5: instruction = 8'b00110001 ; // MUL R3 = R0*R1
            4'd6: instruction = 8'b01000110 ; // ADD R4 = R2 + R3
            4'd7: instruction = 8'b00000100; // LOAD R0, MEM[4]
            4'd8: instruction = 8'b01010000; // ADD R5 = R4 + R0
            4'd9: instruction = 8'b01100000; // ACT R6 = step(R5)
            4'd10: instruction = 8'b00011101; // STORE R6, MEM[13]
            default: instruction = 8'b11110000; // NOP or HALT
        endcase     
    end
endmodule
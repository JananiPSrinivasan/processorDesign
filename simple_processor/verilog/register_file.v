/*
- Register file is a small memory block used to store the intermidate values during execution.
- Registers are noting but a group of flipflops. 
- The registers designed here will be synthesised as D Flipflops as
    - it is written inside a synchronous always block
    - updated on clock edges
- !! Not to be confused with 'reg' in Verilog. 
- the 'reg' in verilog is just a variable that can hold a value

- From the instruction_memory.v file, we have used 8 registers
- Each register is 8 bit wide 
- The register file should support 
    - Two simultananeous reads
    - one write
- Why do we go with two reads and one write is because 
    - Operations like:
        - ADD R4, R2, R3 → R4 = R2 + R3
        - MUL R2, R0, R1 → R2 = R0 × R1
    - Need:
        - 2 source operands (e.g., R0, R1)
        - 1 destination (e.g., R2)
    - So:
        - You must read 2 registers in the same clock cycle
        - You must write 1 result at the end of that cycle

Also, This matches most common CPU Architectures

| Architecture | Register File Ports |
| ------------ | ------------------- |
| MIPS         | 2 read, 1 write     |
| RISC-V       | 2 read, 1 write     |
| ARM          | 2 read, 1 write     |

*/

module register_file(
    input wire clk,

    //instantiate variables for write operation
    input wire we, //write enable
    input wire [2:0] wr_addr, //write address
    input wire [7:0] wr_data, //write data

    //instantiate variables for read operation
    // it is done twice because of 2 reads 
    input wire rd, //read enable
    input wire [2:0] rd_addr1, //read address 1
    input wire [2:0] rd_addr2, //read address 2
    
    // output wire and not input because the data has to be read out 
    
    output wire [7:0] rd_data1, //read data 1
    output wire [7:0] rd_data2 // read data 2
);

// we need 8 registers each of size 8 bit
// reg [7:0] regs - this tells that regs is 8 bit wide
// reg [7:0] regs [0:7] - this tells that there are 8 registers from 0 to 7 each 8b wide

    reg [7:0] regs [0:7];

    // To read the values from the registers we need the values to be present in it
    // The registers must have the values updated in the same cycle before ALU executes the operation
    // Thus we use asynchronous read.

    assign rd_data1 = regs[rd_addr1];
    assign rd_data2 = regs[rd_addr2];

    // Writing is a state-changing operation — so it must be:
    //    - Controlled, Predictable & Aligned with instruction timing
    // Synchronous write ensures:
    //    - Only one value is written per clock cycle
    //    - No race conditions occur
    //    - Works correctly with the write enable (we) and pipeline control
    always@(posedge clk)begin 
        if (we) begin 
            regs[wr_addr] <= wr_data;
        end
    end

endmodule
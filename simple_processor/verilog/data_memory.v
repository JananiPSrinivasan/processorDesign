/*
- data_memory.v
- 8-bit wide, 16-word data memory
- Supports synchronous write and asynchronous read

*/

module data_memory(
    input wire clk,
    input wire write_en, //write enable
    input wire [3:0] addr, // write address
    input wire [7:0] write_data, //write data
    output wire [7:0] read_data 
);
    
    //16 x 8bit memory
    reg [7:0] mem [0:15];

    //Load contents from the file
    initial $readmemh("F:/processor_design/simple_processor/perceptron_model/data.hex", mem);

    // Asynchronous read
    assign read_data = mem[addr];

    // Synchronous write
    always @(posedge clk) begin
        if (write_en) begin
            mem[addr] <= write_data;
        end
    end
endmodule
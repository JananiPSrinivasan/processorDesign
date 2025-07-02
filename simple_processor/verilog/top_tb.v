`timescale 1ns/1ps

module top_tb;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
    end

    reg clk;
    reg reset;
    wire [7:0] mem_read_data;

    // Instantiate the processor
    top uut (
        .clk(clk),
        .reset(reset),
        .mem_read_data(mem_read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;

        // Apply reset
        #10 reset = 0;

        // Run for 200 ns (20 cycles)
        #200;
        
        $display("Final Output (Classification): %d", mem_read_data);
        $finish;
    end
    $display("Memory[13] = %d", uut.dp.mem.mem[13]);

endmodule

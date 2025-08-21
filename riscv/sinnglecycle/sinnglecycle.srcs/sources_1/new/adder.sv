`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 16:47:34
// Design Name: 
// Module Name: adder
// Project Name: Carry save adder
// Target Devices: 
// Tool Versions: 
// Description: 
// Basic full adder that will be used in other complex adders such as carry save 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import pkg::WIDTH; 
module adder(
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic carry_in,
    output logic [WIDTH-1:0] sum,
    output logic carry_out,
    output logic [WIDTH:0]result
    );
    
    // Create a full adder first so that CSA will use this full adder as base
  
    assign {carry_out,sum} = a + b + carry_in;
    assign result = {carry_out,sum};
endmodule

`timescale 1ns/1ps


import pkg::*;
module subtractor(
    input logic [WIDTH-1:0]     a,
    input logic [WIDTH-1:0]     b,
    input logic                 borrow,
    output logic [WIDTH:0]      result,
    output logic                no_borrow  
    
); 
    
    assign {no_borrow, result}= {1'b0,a}-{1'b0,b}-borrow;
    
    
endmodule
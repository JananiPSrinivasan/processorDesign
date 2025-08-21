`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 19:13:45
// Design Name: 
// Module Name: subtractor_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import pkg::WIDTH;
module subtractor_tb;
  logic [WIDTH-1:0] a, b, result;
  logic             borrow;       // borrow_in
  logic             difference;   // borrow_out (MSB of extended subtraction)

  // DUT
  subtractor dut (
    .a(a),
    .b(b),
    .borrow(borrow),
    .result(result),
    .difference(difference)
  );

  // Checker: drive inputs, wait a tick, compare to golden
  task automatic check(input logic [WIDTH-1:0] ta,
                       input logic [WIDTH-1:0] tb,
                       input logic             tborrow);
    logic [WIDTH:0] exp;
    a = ta; b = tb; borrow = tborrow;
    #1;  // let DUT settle
    exp = {1'b0, ta} - {1'b0, tb} - tborrow;

    if ({difference, result} !== exp) begin
      $error("Mismatch: a=%h b=%h bin=%0d | got {%0d,%h} | exp {%0d,%h}",
             ta, tb, tborrow, difference, result, exp[WIDTH], exp[WIDTH-1:0]);
    end
    #9;  // spacing for waves
  endtask

  initial begin
    a='0; b='0; borrow=0; #1;

    // Directed tests
    check('0, '0, 0);                       // 0 - 0
    check('0, '0, 1);                       // 0 - 0 - 1 -> borrow out
    check({WIDTH{1'b1}}, '0, 0);            // max - 0
    check({WIDTH{1'b1}}, '0, 1);            // max - 1 - 1
    check('h1, 'h1, 0);                     // equal, no borrow_in
    check('h1, 'h1, 1);                     // equal, with borrow_in -> underflow
    check('h10, 'h01, 0);                   // a > b
    check('h01, 'h10, 0);                   // a < b
    check('h80 >> (8-WIDTH), 'h01, 0);      // high MSB case (adjusts if WIDTH<8)

    // Randomized (uncomment for more)
    // repeat (200) check($urandom, $urandom, $urandom_range(0,1));

    $display("Subtractor TB: done.");
    $finish;
  end
endmodule

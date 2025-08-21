`timescale 1ns/1ps
import pkg::WIDTH;

module adder_tb;
  logic [WIDTH-1:0] a, b, sum;
  logic             carry_in, carry_out;
  logic [WIDTH:0]   result;

  adder dut (.a(a), .b(b), .carry_in(carry_in), .sum(sum), .carry_out(carry_out), .result(result));

  task automatic check(input logic [WIDTH-1:0] ta,
                       input logic [WIDTH-1:0] tb,
                       input logic             tcin);
    logic [WIDTH:0] exp;
    a = ta; b = tb; carry_in = tcin;
    #1;                          // let DUT settle
    exp = ta + tb + tcin;
    if (result !== exp) begin    // case-inequality catches X/Z
      $error("Mismatch: a=%h b=%h cin=%0d | got {%0d,%h} | exp %0d",
             ta, tb, tcin, carry_out, sum, exp);
    end
    #9;                          // spacing so each vector shows in waves
  endtask

  initial begin
    a='0; b='0; carry_in=0; #1;
    check('0, '0, 0);
    check('0, '0, 1);
    check({WIDTH{1'b1}}, '0, 0);
    check({WIDTH{1'b1}}, 1, 0);
    check({WIDTH{1'b1}}, 1, 1);
    // repeat (200) check($urandom(), $urandom(), $urandom_range(0,1));
    $display("Adder TB: done.");
    $finish;
  end
endmodule

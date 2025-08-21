`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.08.2025 13:49:24
// Design Name: 
// Module Name: alu
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

//////////////////////////////////////////////////////////////////////////////////

import pkg::*;
module alu (
        input logic [WIDTH-1:0]     a,
        input logic [WIDTH-1:0]     b,
        input logic [OPCODE-1:0]    op,
        output logic [WIDTH-1:0]    result,
        output logic                zf, //zero flag
        output logic                cf, // carry_flag
        output logic                nf, //negative flag
        output logic                vf, //overflow flag
        output logic                bf // borrow flag
         
    );
    // We have created indiviual blocks for adder and subtractor
    // But we need wires to drive the result
    logic [WIDTH-1:0] add_sum, sub_result; 
    logic add_cout,sub_no_borrow;
    
    localparam int MSB = WIDTH-1;
    
    adder #(.WIDTH(WIDTH))u_add (
        .a(a),
        .b(b),
        .carry_in(1'b0),
        .carry_out(add_cout),
        .sum(add_sum)
        
    );
    
    subtractor #(.WIDTH(WIDTH)) u_sub (
        .a(a),
        .b(b),
        .borrow(1'b0),
        .no_borrow(sub_no_borrow),
        .result(sub_result)
    );
    /*
    The output should be Based on whatever the opcode     
    if opcode is 001 - ADD
    opcode is 010 - subtract
    opcode 011 - and
    opcode 100 -or
    
    */ 
    
    typedef enum logic [OPCODE-1:0] {
        OP_ADD = 'b001,
        OP_SUB = 'b010,    
        OP_AND = 'b011,
        OP_OR = 'b100
    }op_code_t;
    
    logic vf_add = (~(a[MSB] ^ b[MSB])) &  (a[MSB] ^ add_sum[MSB]);
    logic vf_sub = ( (a[MSB] ^ b[MSB])) &  (a[MSB] ^ sub_result[MSB]);
    
    
    always @(*) begin 
        result = '0;
        cf = 1'b0;
        vf = 1'b0;
        bf = 1'b0;
        
        unique case (op_code_t '(op))
            OP_ADD: begin
                result = add_sum; 
                cf = add_cout;
                vf = vf_add;
                bf = 1'b0;
            end 
            OP_SUB: begin 
                result = sub_result;
                cf = sub_no_borrow;
                vf = vf_sub;
                bf = ~sub_no_borrow;
            end
            OP_AND: begin 
                result = a & b;
                cf = 1'b0; 
                vf = 1'b0; 
                bf = 1'b0;
            end
            OP_OR : begin
                result = a | b;
                cf = 1'b0; 
                vf = 1'b0; 
                bf = 1'b0;
            end
             default: ;
        endcase
        // flags from final result
    zf = (result == '0);
    nf = result[MSB];
    end
    
    
    
endmodule

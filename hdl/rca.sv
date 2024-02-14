`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2024 01:06:58 PM
// Design Name: 
// Module Name: rca
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

// if op is 0, then we're adding; if it's 1 then we're subtracting
/* module rca(
        input logic [31:0] a, [31:0] b, op,
        output logic [31:0] s, overf
    );
    
    logic notb;
    logic bprime;
    assign notb = ~b[0];
    fundamental_mux m(.a(b[0]), .b(notb), .sel(op), .f(bprime));
    
    logic [31:0] carries; //carries[i] represents the carry out of the ith full adder
    full_adder f(.a(a[0]), .b(bprime), .ci(op), .co(carries[0]), .s(s[0]));
    
    generate
        genvar i;
        for (i = 1; i < 32; i = i + 1) begin
            logic nb;
            logic bp;
            assign nb = ~b[i];
            fundamental_mux m(.a(b[i]), .b(nb), .sel(op), .f(bp));
            full_adder f(.a(a[i]), .b(bp), .ci(carries[i-1]), .co(carries[i]), .s(s[i]));
        end
    endgenerate
    assign overf = carries[31] ^ carries[30];
endmodule
*/

module rca(
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic ci,                 // Carry in for the least significant bit
    output logic co,                 // Carry out from the most significant bit
    output logic [31:0] sum
);
    logic [30:0] carry; // Internal carry signals for full adders 1 through 30

    // Manually instantiate the first full adder
    full_adder fa_first(
        .a(a[0]),
        .b(b[0]),
        .ci(ci),
        .co(carry[0]),
        .s(sum[0])
    );

    // Instantiate full adders 1 through 30
    genvar i;
    generate
        for (i = 1; i < 31; i = i + 1) begin : adders
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .ci(carry[i-1]),
                .co(carry[i]),
                .s(sum[i])
            );
        end
    endgenerate

    // Manually instantiate the last full adder
    full_adder fa_last(
        .a(a[31]),
        .b(b[31]),
        .ci(carry[30]),
        .co(co),
        .s(sum[31])
    );
endmodule
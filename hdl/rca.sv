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


module rca (
    input logic [31:0] a, b,  // Two 32-bit inputs
    input logic ci,           // Carry input (usually set to 0 for addition)
    output logic [31:0] sum,  // 32-bit sum of a and b
    output logic co           // Carry output of the final addition
);

// Internal signals for carry bits between adders
logic [30:0] carry;

// Instantiate 32 full adders
genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : adder
            if (i == 0) begin
                // For the least significant bit, use ci as the carry input
                full_adder fa(.a(a[i]), .b(b[i]), .ci(ci), .co(carry[i]), .sum(sum[i]));
            end else if (i < 31) begin
                // For bits 1 through 30, use the carry from the previous adder
                full_adder fa(.a(a[i]), .b(b[i]), .ci(carry[i-1]), .co(carry[i]), .sum(sum[i]));
            end else begin
                // For the most significant bit, output the carry out to co
                full_adder fa(.a(a[i]), .b(b[i]), .ci(carry[i-1]), .co(co), .sum(sum[i]));
            end
        end
    endgenerate

endmodule
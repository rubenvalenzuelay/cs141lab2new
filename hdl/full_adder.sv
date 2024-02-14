`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2024 01:02:22 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
        input logic a, b, ci,
        output logic co, s
    );
    
    // assign co = a ^ b ^ ci;
    // assign s = (a & b) | (a & ci) | (b & ci);

    // Corrected expressions
    assign s = a ^ b ^ ci; // Sum is the XOR of a, b, and ci
    assign co = (a & b) | (a & ci) | (b & ci); // Carry out is true if any two inputs are true
endmodule
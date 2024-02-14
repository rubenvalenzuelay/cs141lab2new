module alu (
    input logic [31:0] x, y,              // Two 32-bit inputs
    input logic [1:0] op_code,            // Operation code: 00 for AND, 01 for ADD, 10 for SUB
    output logic [31:0] result,           // Result of the operation
    output logic overflow, equal, zero    // Flags
);

    // TODO part 1 -- 8:1 mux, AND, ADD (with ripple-carry adder), SUB, flags

    // Intermediate signals
    logic [31:0] y_twos_complement;
    logic [31:0] addition_result, subtraction_result;
    logic addition_overflow, subtraction_overflow;
    logic [31:0] and_result;

    // Two's complement for y (invert y and add 1 for subtraction)
    assign y_twos_complement = ~y + 1;

    // Bitwise AND operation
    assign and_result = x & y;

    // Using the rca module for addition
    rca adder_inst_add(.a(x), .b(y), .ci(0), .sum(addition_result), .co(addition_overflow));

    // Using the rca module for subtraction (addition with two's complement of y)
    rca adder_inst_sub(.a(x), .b(y_twos_complement), .ci(0), .sum(subtraction_result), .co(subtraction_overflow));

    // Selecting overflow flag without using '=='
    assign overflow = (op_code[1] & ~op_code[0]) ? subtraction_overflow : addition_overflow;

    // Selecting operation without using '=='
    always_comb begin
        case (op_code)
            2'b00: result = and_result;              // Bitwise AND
            2'b01: result = addition_result;         // Addition
            2'b10: result = subtraction_result;      // Subtraction
            default: result = 32'b0;                 // Default case
        endcase

        // Zero flag (result is zero if all bits are 0)
        zero = ~|result;

        // Equal flag (x and y are equal if their bitwise NOR is all zeros)
        equal = ~|(x ^ y);
    end

    // TODO part 2 -- SLT, SRL, SRA, SLL, ADD (with carry-lookahead adder)

endmodule



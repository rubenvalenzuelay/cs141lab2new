module alu (
    input logic [31:0] x, y,              // Two 32-bit inputs
    input logic [2:0] op,                 // Operation code: 00 for AND, 01 for ADD, 10 for SUB
    output logic [31:0] z,                // Result of the operation
    output logic overflow, equal, zero    // Flags
);

    // Intermediate signals
    logic [31:0] y_twos_complement;
    logic [31:0] addition_result, subtraction_result;
    logic addition_overflow, subtraction_overflow;
    logic [31:0] and_result;
    logic co_dummy; // Dummy carry-out for two's complement calculation

    // Two's complement for y (invert y and add 1 with carry-in)
    rca twos_complement_calculator(
        .a(~y),
        .b(32'd0),
        .ci(1),
        .co(co_dummy), // This carry-out is not used for overflow detection
        .sum(y_twos_complement)
    );

    // Bitwise AND operation
    assign and_result = x & y;

    // Using the rca module for addition
    rca adder_inst_add(
        .a(x),
        .b(y),
        .ci(0),
        .sum(addition_result),
        .co(addition_overflow)
    );

    // Using the rca module for subtraction (addition with two's complement of y)
    rca adder_inst_sub(
        .a(x),
        .b(y_twos_complement),
        .ci(0),
        .sum(subtraction_result),
        .co(subtraction_overflow)
    );

    // Logic for overflow handling remains the same as previously discussed

    assign overflow = (op[1] & ~op[0]) ? subtraction_overflow : addition_overflow;

    // Selecting operation without using '=='
    always_comb begin
        case (op)
            3'b000: z = and_result;              // Bitwise AND
            3'b001: z = addition_result;         // Addition
            3'b010: z = subtraction_result;      // Subtraction
            default: z = 32'b0;                  // Default case
        endcase

        // Zero flag (result is zero if all bits are 0)
        // zero = ~|z;
        zero = 0'b1;

        // Equal flag (x and y are equal if their bitwise NOR is all zeros)
        equal = ~|(x ^ y);
    end

    // TODO part 2 -- SLT, SRL, SRA, SLL, ADD (with carry-lookahead adder)

endmodule

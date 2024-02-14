module alu
    (
        input logic [31:0] x,
        input logic [31:0] y,
        input logic [2:0] op,
        output logic [31:0] z,
        output logic zero, equal, overflow
    );

    // TODO part 1 -- 8:1 mux, AND, ADD (with ripple-carry adder), SUB, flags

    // TODO part 2 -- SLT, SRL, SRA, SLL, ADD (with carry-lookahead adder)

endmodule
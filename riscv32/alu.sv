// Arithmetic and Logic Unit

typedef enum [2:0] {CONST, ADD, SUBSTRACT} alu_ops;

/* module */
module alu #(parameter WIDTH=32) (op, x, y, out);
    /* I/O */
    input [2:0] op;
    input [WIDTH-1:0] x;
    input [WIDTH-1:0] y;

    output [WIDTH-1:0] out;

    assign out = (op == ADD) ? x + y :
                 (op == SUBSTRACT) ? x - y :
                 y;
endmodule
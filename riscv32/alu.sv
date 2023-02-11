// Arithmetic and Logic Unit


/* module */
module alu #(parameter WIDTH=32) (op, x, y, out);
    /* I/O */
    input [2:0] op;
    input [WIDTH-1:0] x;
    input [WIDTH-1:0] y;

    output [WIDTH-1:0] out;

    localparam ZERO = 0;
    localparam ADD = 1;
    localparam SUBSTRACT = 2;

    assign out = (op == ADD) ? x + y :
                 (op == SUBSTRACT) ? x - y :
                 0;
endmodule
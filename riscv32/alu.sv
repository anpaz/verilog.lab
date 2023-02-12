// Arithmetic and Logic Unit

parameter ZERO = 0;
parameter ADD = 1;
parameter SUBSTRACT = 2;
parameter LESSTHAN = 3;

/* module */
module alu #(parameter WIDTH=32) (op, x, y, out);
    /* I/O */
    input [2:0] op;
    input [WIDTH-1:0] x;
    input [WIDTH-1:0] y;

    output [WIDTH-1:0] out;

    logic [WIDTH-1:0] lessThan;
    logic [WIDTH-1:0] add;
    logic [WIDTH-1:0] subs;

    assign add = x + y;
    assign subs = x - y;
    assign lessThan = (subs[WIDTH-1] == 1) ? 1 : 0;
    
    assign out = (op == ADD) ? add :
                 (op == SUBSTRACT) ? subs :
                 (op == LESSTHAN) ? lessThan :
                 0;
endmodule
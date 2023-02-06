// Compute the logical AND and OR of inputs A and B.
module top(andOut, orOut, A, B);
 output andOut, orOut;
 input A, B;
 and TheAndGate (andOut, A, B);
 or TheOrGate (orOut, A, B);
endmodule 
// Blink an LED provided an input clock
/* module */
module top (hwclk, rst, led1, led2, led3, led4, led5, led6, led7, led8 );
    /* I/O */
    input hwclk;
    input rst;

    output led1;
    output led2;
    output led3;
    output led4;
    output led5;
    output led6;
    output led7;
    output led8;

    /* Counter register */
    reg [31:0] counter = 32'b0;

    /* LED drivers */
    assign led1 = counter[24];
    assign led2 = counter[25];
    assign led3 = counter[26];
    assign led4 = counter[27];
    assign led5 = counter[28];
    assign led6 = counter[29];
    assign led7 = counter[30];
    assign led8 = counter[31];

    /* always */
    always @ (posedge hwclk) begin
        // Only increase counter when RST is pressed.
        if (rst == 1'b1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
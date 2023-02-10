// Data Registers
/* module */
module memory #(parameter WIDTH=32, SIZE=4) (clk, reset, data, location_read, location_write, write_enabled, out);
    /* I/O */
    input clk;
    input reset;
    input [WIDTH-1:0] data;
    input [4:0] location_read;
    input [4:0] location_write;
    input write_enabled;
    output [WIDTH-1:0] out;

    /* data storage */
    reg [SIZE-1:0][WIDTH-1:0] registers;
    integer  i;

    /* update register if write_enabled */
    always_ff @( posedge clk ) begin
        if (reset) begin
            for (i = 0; i < SIZE; i=i+1) begin
                registers[i] <= 0;
            end
        end else begin 
            if (write_enabled) begin
                registers[location_write] <= data;
            end
        end
    end

    //assign out = out_buffer;
    assign out = registers[location_read];

endmodule
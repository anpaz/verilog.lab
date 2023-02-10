// Data Registers
/* module */
module memory #(parameter WIDTH=32) (clk, rst, data, location_read, location_write, write_enabled, out);
    /* I/O */
    input clk;
    input rst;
    input [WIDTH-1:0] data;
    input [4:0] location_read;
    input [4:0] location_write;
    input write_enabled;
    output [WIDTH-1:0] out;

    /* data storage */
    reg [2:0][WIDTH-1:0] registers;

    /* update register if write_enabled */
    always_ff @( posedge clk ) begin
        if (rst) begin
            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 0;
            // registers[3] <= 0;
            // registers[4] <= 0;
            // out_buffer <= 0;
        end else begin 
            if (write_enabled) begin
                registers[location_write] <= data;
            end
        end
    end

    //assign out = out_buffer;
    assign out = registers[location_read];

endmodule
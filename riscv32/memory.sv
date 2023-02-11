// Data Registers
/* module */
module memory #(parameter WIDTH=32, SIZE=4) (clk, reset, write_enabled, write_location, write_data, read1_location, read1_data, read2_location, read2_data);
    /* I/O */
    input clk;
    input reset;
    input [WIDTH-1:0] write_data;
    input [4:0] write_location;
    input write_enabled;
    input [4:0] read1_location;
    input [4:0] read2_location;
    output [WIDTH-1:0] read1_data;
    output [WIDTH-1:0] read2_data;

    /* data storage, somehow verilator uses a different syntax: */
`ifdef verilator
    reg [SIZE-1:0][WIDTH-1:0] registers;
`else
    reg registers[SIZE-1:0][WIDTH-1:0];
`endif


    /* update register if write_enabled */
    always_ff @( posedge clk ) begin
        if (reset) begin
            integer  i;
            for (i = 0; i < SIZE; i=i+1) begin
                registers[i] <= 0;
            end
        end else begin 
            if (write_enabled) begin
                registers[write_location] <= write_data;
            end
        end
    end

    //assign out = out_buffer;
    assign read1_data = registers[read1_location];
    assign read2_data = registers[read2_location];

endmodule
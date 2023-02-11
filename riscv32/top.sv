// Entry point
/* module */

module top #(parameter WIDTH=32) (clk, reset, opcode, rd, rs1, imm12, out, led);
    /* I/O */
    input clk;
    input reset;

    input [2:0] opcode;
    input [4:0] rd;
    // input [2:0] func;
    input [4:0] rs1;
    // input [4:0] rs2;
    input [11:0] imm12;
    // input [WIDTH-1:0] y;

    output [WIDTH-1:0] out;
    output [7:0] led;

    logic reg_write_enabled;
    wire  [WIDTH-1:0] reg_out1;
    //wire  [WIDTH-1:0] reg_out2;
    logic [4:0] reg_location_read;
    logic [4:0] reg_location_write;

    logic [WIDTH-1:0] imm_data;

    logic [2:0] alu_op;
    wire [WIDTH-1:0] alu_out;

    reg [1:0] curr_state;
    reg [WIDTH-1:0] curr_out;

    localparam STATE_INIT     = 0;
    localparam STATE_UPDATE   = 1;
    localparam STATE_COMPLETE = 2;


    alu #(.WIDTH(WIDTH)) alu (
        .op(alu_op),
        .x(reg_out1),
        .y(imm_data),
        .out(alu_out)
    );

    memory #(.WIDTH(WIDTH)) data_registers (
        .clk(clk),
        .reset(reset),
        .write_data(alu_out),
        .write_location(reg_location_write),
        .write_enabled(reg_write_enabled),
        .read1_location(reg_location_read),
        .read1_data(reg_out1),
        .read2_location(reg_location_read),
        .read2_data(reg_out1)
    );

    assign imm_data[WIDTH-1:12] = 0;
    assign imm_data[11:0] = imm12;
    
    assign alu_op = opcode[2:0];

    /* always */
    always @ (posedge clk) begin
        if (reset) begin
            curr_state <= STATE_COMPLETE;
            curr_out <= reg_out1;
        end else begin
            case (curr_state)
                STATE_INIT: begin
                    curr_state <= STATE_UPDATE;
                    reg_location_read <= rs1;
                    reg_location_write <= rd;
                    reg_write_enabled <= 1;
                end
                STATE_UPDATE: begin
                    curr_state <= STATE_COMPLETE;
                    reg_write_enabled <= 0;
                    reg_location_read <= rd;
                end
                default: begin
                    curr_state <= STATE_INIT;
                    reg_location_read <= rd;
                    reg_write_enabled <= 0;
                    curr_out <= reg_out1;
                end
            endcase
        end
    end

    /* LED output */
    assign out = curr_out;
    assign led[7:0] = out[7:0];

endmodule
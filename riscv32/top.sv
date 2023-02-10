// Entry point
/* module */
typedef enum [1:0] {STATE_INIT, STATE_UPDATE, STATE_COMPLETE} cpu_state;

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
    wire  [WIDTH-1:0] reg_out;
    logic [4:0] reg_location_read;
    logic [4:0] reg_location_write;

    logic [WIDTH-1:0] imm_data;

    logic [2:0] alu_op;
    wire [WIDTH-1:0] alu_out;

    reg [1:0] curr_state;

    alu #(.WIDTH(WIDTH)) alu (
        .op(alu_op),
        .x(reg_out),
        .y(imm_data),
        .out(alu_out));

    memory #(.WIDTH(WIDTH)) data_registers (
        .clk(clk),
        .reset(reset),
        .data(alu_out),
        .location_read(reg_location_read),
        .location_write(reg_location_write),
        .write_enabled(reg_write_enabled),
        .out(reg_out));

    assign imm_data[WIDTH-1:12] = 0;
    assign imm_data[11:0] = imm12;
    
    assign alu_op = opcode[2:0];

    /* always */
    always @ (posedge clk) begin
        if (reset) begin
            curr_state <= STATE_COMPLETE;
        end else
            case (curr_state)
                STATE_COMPLETE:
                    curr_state <= STATE_INIT;
                default: 
                    curr_state <= curr_state + 1;
            endcase
    end

    /* always */
    assign reg_location_read = rs1;
    always @ (posedge clk) begin
        case (curr_state)
            STATE_INIT: begin
                reg_location_write <= rd;
                reg_write_enabled <= 1;
            end default: begin
                reg_write_enabled <= 0;
            end
        endcase
    end

    /* LED output */
    assign out = reg_out;
    assign led[7:0] = out[7:0];

endmodule
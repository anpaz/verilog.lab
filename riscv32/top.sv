// Entry point
/* module */
module top #(parameter WIDTH=32) (clk, reset, opcode, rd, rs1, rs2, imm12, out, led);
    /* I/O */
    input clk;
    input reset;

    input [6:0] opcode;
    input [4:0] rd;
    // input [2:0] func;
    input [4:0] rs1;
    input [4:0] rs2;
    input [11:0] imm12;

    output [WIDTH-1:0] out;
    output [7:0] led;

    logic               reg_write_enabled;
    wire  [WIDTH-1:0]   reg_out1;
    wire  [WIDTH-1:0]   reg_out2;
    logic [4:0]         reg_read1_location;
    logic [4:0]         reg_read2_location;
    logic [4:0]         reg_write_location;
    logic [WIDTH-1:0]   reg_write_data;

    logic [2:0]         alu_op;
    logic [WIDTH-1:0]   alu_x;
    logic [WIDTH-1:0]   alu_y;
    wire  [WIDTH-1:0]   alu_out;

    logic [WIDTH-1:0]   imm_data;

    logic [1:0]         curr_state;
    logic [WIDTH-1:0]   curr_out;

    /* yosys doesn't support enums, use parameters instead: */
    localparam STATE_INIT     = 0;
    localparam STATE_UPDATE   = 1;
    localparam STATE_COMPLETE = 2;

    localparam OPCODE_ADD = 1;
    localparam OPCODE_SUBS = 2;
    localparam OPCODE_LESSTHAN = 3;
    
    localparam OPCODE_ADDI = 11;
    localparam OPCODE_SUBSI = 12;
    localparam OPCODE_LESSTHANI = 13;

    alu #(.WIDTH(WIDTH)) alu (
        .op(alu_op),
        .x(alu_x),
        .y(alu_y),
        .out(alu_out)
    );

    memory #(.WIDTH(WIDTH)) data_registers (
        .clk(clk),
        .reset(reset),
        .write_data(reg_write_data),
        .write_location(reg_write_location),
        .write_enabled(reg_write_enabled),
        .read1_location(reg_read1_location),
        .read1_out(reg_out1),
        .read2_location(reg_read2_location),
        .read2_out(reg_out2)
    );

    /* immediate data maps directly from inputs */
    assign imm_data[WIDTH-1:12] = 0;
    assign imm_data[11:0] = imm12;

    /* state.vnext and registers depend on state */
    assign reg_write_location = rd;
    assign reg_write_data = alu_out;
    assign reg_read2_location = rs2;
    always @ (posedge clk) begin
        if (reset) begin
            curr_state <= STATE_COMPLETE;
            curr_out <= reg_out1;
        end else begin
            case (curr_state)
                STATE_INIT: begin
                    curr_state <= STATE_UPDATE;
                    reg_read1_location <= rs1;
                    reg_write_enabled <= 1;
                end
                STATE_UPDATE: begin
                    curr_state <= STATE_COMPLETE;
                    reg_read1_location <= rd;
                    reg_write_enabled <= 0;
                end
                default: begin
                    curr_state <= STATE_INIT;
                    reg_read1_location <= rd;
                    reg_write_enabled <= 0;
                    curr_out <= reg_out1;
                end
            endcase
        end
    end

    /* alu inputs depend on opcode */
    assign alu_x = reg_out1;
    always @ (posedge clk) begin
        case (opcode)
            OPCODE_ADD: begin
                alu_op <= ADD;
                alu_y <= reg_out2;
            end
            OPCODE_SUBS: begin
                alu_op <= SUBSTRACT;
                alu_y <= reg_out2;
            end
            OPCODE_LESSTHAN: begin
                alu_op <= LESSTHAN;
                alu_y <= reg_out2;
            end
            OPCODE_ADDI: begin
                alu_op <= ADD;
                alu_y <= imm_data;
            end
            OPCODE_SUBSI: begin
                alu_op <= SUBSTRACT;
                alu_y <= imm_data;
            end
            OPCODE_LESSTHANI: begin
                alu_op <= LESSTHAN;
                alu_y <= imm_data;
            end
        endcase
    end

    /* outputs */
    assign out = curr_out;
    assign led[7:0] = out[7:0];

endmodule
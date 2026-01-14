// Simple Educational GPU Model
// Demonstrates basic GPU concepts: parallel processing, memory hierarchy, and shader execution

module basic_gpu (
  input clk,
  input rst,
  input [31:0] instruction,
  input valid_instruction,
  output reg [31:0] result,
  output reg ready
);

  // GPU Parameters
  parameter NUM_CORES = 4;
  parameter MEMORY_SIZE = 1024;
  parameter THREAD_COUNT = 16;

  // Memory
  reg [31:0] global_memory [0:MEMORY_SIZE-1];
  reg [31:0] shared_memory [0:255];
  reg [31:0] registers [0:NUM_CORES-1][0:31];

  // Control signals
  reg [3:0] opcode;
  reg [4:0] dest_reg, src1_reg, src2_reg;
  reg [31:0] immediate;

  // Execution state
  reg [1:0] state;
  localparam IDLE = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10, WRITEBACK = 2'b11;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      ready <= 1;
      result <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (valid_instruction) begin
            state <= DECODE;
            ready <= 0;
          end
        end

        DECODE: begin
          opcode <= instruction[31:28];
          dest_reg <= instruction[27:23];
          src1_reg <= instruction[22:18];
          src2_reg <= instruction[17:13];
          immediate <= instruction[12:0];
          state <= EXECUTE;
        end

        EXECUTE: begin
          case (opcode)
            4'b0000: result <= registers[0][src1_reg] + registers[0][src2_reg]; // ADD
            4'b0001: result <= registers[0][src1_reg] - registers[0][src2_reg]; // SUB
            4'b0010: result <= registers[0][src1_reg] * registers[0][src2_reg]; // MUL
            4'b0011: result <= registers[0][src1_reg] & registers[0][src2_reg]; // AND
            4'b0100: result <= registers[0][src1_reg] | registers[0][src2_reg]; // OR
            default: result <= 0;
          endcase
          state <= WRITEBACK;
        end

        WRITEBACK: begin
          registers[0][dest_reg] <= result;
          state <= IDLE;
          ready <= 1;
        end
      endcase
    end
  end

endmodule
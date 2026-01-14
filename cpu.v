module simple_processor13(
  input clk,
  input reset,
  input [7:0] instruction,
  input [7:0] data_in,
  output reg [7:0] data_out,
  output reg [7:0] pc
);

  reg [7:0] accumulator;
  reg [7:0] memory [0:255];

  always @(posedge clk) begin
    if (reset) begin
      accumulator <= 8'b0;
      pc <= 8'b0;
      data_out <= 8'b0;
    end else begin
      case(instruction[7:4])
        4'b0001: accumulator <= data_in;                    // LOAD
        4'b0010: data_out <= accumulator;                   // STORE
        4'b0011: accumulator <= accumulator + data_in;      // ADD
        4'b0100: accumulator <= accumulator - data_in;      // SUB
        4'b0101: accumulator <= accumulator & data_in;      // AND
        4'b0110: accumulator <= accumulator | data_in;      // OR
        4'b0111: pc <= instruction[7:0];                    // JUMP
        default: pc <= pc + 1;                              // NOP
      endcase
    end
  end

endmodule
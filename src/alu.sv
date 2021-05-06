module alu(
  input var logic [31:0] a,
  input var logic [31:0] b,
  input var logic [2:0] f,
  output var logic zero,
  output var logic [31:0] y
);

always_comb begin
  case (f)
    3'b000: y = a & b;
    3'b001: y = a | b;
    3'b010: y = a + b;
    3'b100: y = a & ~b;
    3'b101: y = a | ~b;
    3'b110: y = a - b;
    3'b111: y = a < b;
    default: y = 32'bx;
  endcase
end

assign zero = y === 32'b0;

endmodule
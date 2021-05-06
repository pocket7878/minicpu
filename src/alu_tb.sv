module alu_tb;

logic [31:0] a, b;
logic [2:0] f;
logic [31:0] y;
logic zero;

alu dut(.a, .b, .f, .zero, .y);

initial begin
  /* Test Add */
  // 1 + 1
  f = 3'b010;
  a = 32'b1;
  b = 32'b1;
  #1;
  assert(y === 32'b10) else $error("Failed to add 1 + 1");
  assert(zero == 0) else $error("Zero flag must be 0 for 1 + 1");
  // 0 + 1
  a = 32'b0;
  b = 32'b0;
  #1;
  assert(y === 32'b0) else $error("Failed to add 0 + 0");
  assert(zero === 1) else $error("Zero flag must be 1 for 0 + 0");
  /* Test And */
  f = 3'b000;
  a = 4'b0101;
  b = 4'b0011;
  #1;
  assert (y === 32'b0001) else $error("Failed to AND");
  /* Test Or */
  f = 3'b001;
  a = 4'b0101;
  b = 4'b0011;
  #1;
  assert (y === 32'b0111) else $error("Failed to OR");
  #1;
  $finish;
end

endmodule
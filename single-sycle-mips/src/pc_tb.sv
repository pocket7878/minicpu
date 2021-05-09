module pc_tb;

logic clk;
logic rst;
logic [31:0] next_pc;
logic [31:0] pc;

pc dut(
  .clk,
  .rst,
  .next_pc,
  .pc
);

initial begin
  rst = 'b1; #1; rst = 'b0; #1;
  assert(pc === 32'b0) else $error("pc must be initialize to 0");
  next_pc = 32'b1;
  clk = 'b1; #1; clk = 'b0; #1;
  assert(pc === 32'b1) else $error("pc must be updated to next_pc");
  $finish;
end

endmodule
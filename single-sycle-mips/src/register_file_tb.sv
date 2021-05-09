module register_file_tb;

logic clk, rst;
logic [4:0] a1, a2, a3;
logic we3;
logic [31:0] wd3;
logic [31:0] rd1, rd2;

register_file dut(
  .clk,
  .rst,
  .a1,
  .a2,
  .a3,
  .we3,
  .wd3,
  .rd1,
  .rd2
);

initial begin
  // Initialize
  we3 = 0;
  wd3 = 32'b0;
  a3 = 32'b0;
  clk = 0;
  rst = 1; #1; rst = 0; #1;
  // Read initialized registers
  a1 = 32'b0; a2 = 32'b1; #1;
  assert(rd1 === 32'b0 && rd2 === 32'b0) else $error("Failed to initialze registers");
  // Write data to registe
  a3 = 32'b1; #1;
  wd3 = 32'b1; #1;
  we3 = 1; #1;
  clk = 1; #1; clk = 0; #1;
  assert(rd1 ==	32'b0) else $error("Write is affected different register.");
  assert(rd2 == 32'b1) else $error("Failed to write to register");
  $finish;
end

endmodule
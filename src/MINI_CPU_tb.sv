module MINI_CPU_tb;

logic clk, rst;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;


MINI_CPU dut(
  .CLK(clk),
  .RST(rst),
  .HEX0,
  .HEX1,
  .HEX2,
  .HEX3,
  .HEX4,
  .HEX5
);

always begin
  clk = 0; #1; clk = 1; #1;
end

initial begin
  rst = 1; #1; rst = 0;
  #30;
  $finish;
end

endmodule
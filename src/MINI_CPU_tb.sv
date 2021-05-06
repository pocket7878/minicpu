`include "def.svh"

module MINI_CPU_tb;
  logic rst, clk;
  logic [`DATA_WIDTH-1:0] sw;
  logic [`DATA_WIDTH-1:0] outp;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  MINI_CPU dut(
    .RST(rst),
    .CLK(clk),
    .SW(sw),
    .outp,
    .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5
  );

  initial begin
    sw = 8'b0000_0000;
    rst = 1; #1; rst = 0; #1;
  end

  always begin
    clk = 0; #1; clk = 1; #1;
  end

  initial begin
    #15;
    $finish;
  end

endmodule
`include "def.svh"

module MINI_CPU(
  input var RST,
  input var CLK,
  input var [`DATA_WIDTH-1:0] SW,
  output var [`DATA_WIDTH-1:0] outp,
  output var [6:0] HEX0,
  output var [6:0] HEX1,
  output var [6:0] HEX2,
  output var [6:0] HEX3,
  output var [6:0] HEX4,
  output var [6:0] HEX5
);
endmodule

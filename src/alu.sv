`include "def.svh"

module alu(
  input var logic [`DATA_WIDTH-1:0] ain,
  input var logic [`DATA_WIDTH-1:0] bin,
  output var logic c,
  output var logic [`DATA_WIDTH-1:0] out
);

  assign {c,out} = ain + bin;
endmodule
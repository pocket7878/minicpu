module alu(
  input var logic [3:0] ain,
  input var logic [3:0] bin,
  output var logic c,
  output var logic [3:0] out
);

  assign {c,out} = ain + bin;
endmodule
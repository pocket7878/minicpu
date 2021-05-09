module mult2(
  input var logic sel,
  input var logic [31:0] a,
  input var logic [31:0] b,
  output var logic [31:0] y
);

always_comb begin
  case (sel)
    0: y <= a;
    1: y <= b;
  endcase
end

endmodule
module branch_judge(
  input var logic [1:0] branch,
  input var logic zero,
  output var logic y
);

always_comb begin
  case (branch)
    2'b00: y = 0;
    2'b01: y = zero;
    2'b11: y = ~zero;
    default: y = 0;
  endcase
end

endmodule
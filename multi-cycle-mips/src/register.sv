module register(
  input var logic clk,
  input var logic rst,
  input var logic [31:0] a,
  output var logic [31:0] y
);

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    y <= 0;
  end
  else begin
    y <= a;
  end
end

endmodule
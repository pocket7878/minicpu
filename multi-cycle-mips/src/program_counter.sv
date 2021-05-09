module program_counter(
  input var logic clk,
  input var logic rst,
  input var logic [31:0] next_pc,
  output var logic [31:0] pc
);

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    pc <= 0;
  end
  else begin
    pc <= next_pc;
  end
end

endmodule
module memory(
  input var logic clk,
  input var logic rst,
  input var logic [31:0] a,
  input var logic we,
  input var logic [31:0] wd,
  output var logic [31:0] rd
);

logic [31:0] mem[255:0];
assign rd = mem[a[29:0]];

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    mem <= '{default:'0};
  end
  else if (we) begin
    mem[a[29:0]] <= wd;
  end
end

endmodule
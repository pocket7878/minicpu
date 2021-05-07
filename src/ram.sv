module ram(
  input var clk,
  input var rst,
  input var logic [31:0] a,
  input var logic [31:0] wd,
  input var logic we,
  output var logic [31:0] rd
);

logic [31:0] mem[255:0];

logic [29:0] word_addr;
assign word_addr = a[31:2];
assign rd = mem[word_addr];

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    mem <= '{default: '0};
  end
  else if (we) begin
    mem[word_addr] <= wd;
  end
end

endmodule
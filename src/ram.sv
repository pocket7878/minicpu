module ram(
  input var clk,
  input var rst,
  input var logic [31:0] a,
  input var logic [31:0] wd,
  input var logic we,
  output var logic [31:0] rd
);

logic [31:0] mem[0:1023];

// Initialize memory
always_ff @(posedge rst) begin
  for(int i=0; i<1024; i++) begin
    mem[i] = 0;
  end
end

assign rd = mem[a];

always_ff @(posedge clk) begin
  if (we) begin
    mem[a] <= wd;
  end
end

endmodule
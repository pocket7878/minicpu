module register_file(
  input var logic clk,
  input var logic rst,
  input var logic [4:0] a1,
  input var logic [4:0] a2,
  input var logic [4:0] a3,
  input var logic we3,
  input var logic [31:0] wd3,
  output var logic [31:0] rd1,
  output var logic [31:0] rd2,
  output var logic [31:0] out
);

logic [31:0] mem[32:0];

// Initialze registers
always_ff @(posedge rst) begin
  mem <= '{default:'0};
end

assign rd1 = mem[a1];
assign rd2 = mem[a2];

always_ff @(posedge clk) begin
  if (we3) begin
    mem[a3] <= wd3;
  end
end

// output for debug
assign out = mem[2];

endmodule
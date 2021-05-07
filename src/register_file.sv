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

logic [31:0] mem[31:0];

always_ff @(posedge clk or posedge rst) begin
  if (rst) begin
    mem <= '{default: '0};
  end
  else if (we3) begin
    mem[a3] <= wd3;
  end
end

// output for debug
assign out = mem[2];

assign rd1 = (a1 != 0) ? mem[a1] : 0;
assign rd2 = (a1 != 0) ? mem[a2] : 0;

endmodule
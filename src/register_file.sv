module register_file(
  input var logic clk,
  input var logic rst,
  input var logic [4:0] a1,
  input var logic [4:0] a2,
  input var logic [4:0] a3,
  input var logic we3,
  input var logic [31:0] wd3,
  output var logic [31:0] rd1,
  output var logic [31:0] rd2
);

logic [31:0] mem[0:32];

// Initialze registers
always_ff @(posedge rst) begin
  if (rst) begin
    for(int i=0; i<32; i++) begin
      mem[i] <= 0;
    end
  end
end

assign rd1 = mem[a1];
assign rd2 = mem[a2];

always_ff @(posedge clk) begin
  if (we3) begin
    mem[a3] <= wd3;
  end
end

endmodule
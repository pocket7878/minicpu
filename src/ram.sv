module ram 
  #(parameter N = 4, M = 8)
  (
    input var logic clk,
    input var logic we,
    input var logic [N-1:0] adr,
    input var logic [M-1:0] din,
    output var logic [M-1:0] dout
  );


  logic [M-1:0] mem [2**N-1:0];

  always_ff @(posedge clk) begin
    if (we) begin
      mem[adr] <= din;
    end
  end

  assign dout = mem[adr];
endmodule
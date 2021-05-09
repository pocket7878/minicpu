module counter(
  input var logic clk,
  input var logic reset,
  input var logic [3:0] in,
  input var logic ld,
  output var logic [3:0] out
);
  
  logic [3:0] cnt=4'b0000;
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      cnt <= 4'b0000;
    end
    else if(ld==0) begin;
      cnt <= in;
    end
    else begin
      cnt <= cnt + 1;
    end
  end
  
  assign out = cnt;
endmodule
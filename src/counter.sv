`include "def.svh"

module counter(
  input var logic clk,
  input var logic reset,
  input var logic [`DATA_WIDTH-1:0] in,
  input var logic ld,
  output var logic [`DATA_WIDTH-1:0] out
);
  
  parameter DEFAULT = 0;

  logic [`DATA_WIDTH-1:0] cnt = DEFAULT;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      cnt <= DEFAULT;
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
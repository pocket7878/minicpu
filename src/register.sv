`include "def.svh"

module register
  (
    input var clk,
    input var reset,
    input var [`DATA_WIDTH-1:0] in,
    input var ld,
    output var [`DATA_WIDTH-1:0] out
  );

  parameter DEFAULT = 'b0;

  logic [`DATA_WIDTH-1:0] mem = DEFAULT;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      mem <= DEFAULT;
    end 
    else if(ld == 0) begin
      mem <= in;
    end
  end

  assign out = mem;
endmodule
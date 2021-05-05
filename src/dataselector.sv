`include "def.svh"

module dataselector(
  input var logic [1:0] sel,
  input var logic [`DATA_WIDTH-1:0] c0, c1, c2, c3,
  output var logic [`DATA_WIDTH-1:0] y
);
  
  always_comb begin
    case (sel)
      2'b00: y = c0;
      2'b01: y = c1;
      2'b10: y = c2;
      2'b11: y = c3;
      default: y = 'bx;
    endcase
  end

endmodule
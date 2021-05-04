module dataselector(
  input var logic [1:0] sel,
  input var logic [3:0] c0,
  input var logic [3:0] c1,
  input var logic [3:0] c2,
  input var logic [3:0] c3,
  output var logic [3:0] y
);
  
  logic [3:0] out;
  always_comb begin
    case (sel)
      2'b00: out <= c0;
      2'b01: out <= c1;
      2'b10: out <= c2;
      2'b11: out <= c3;
      default: out <= 2'b000;
    endcase
  end
  
  assign y = out;
endmodule
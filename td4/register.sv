module register(
  input var clk,
  input var reset,
  input var [3:0] in,
  input var ld,
  output var [3:0] out
);

  parameter DEFAULT = 4'b0000;

  logic [3:0] mem = DEFAULT;

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
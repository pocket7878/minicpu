module mult2_tb;

logic sel;
logic [31:0] a;
logic [31:0] b;
logic [31:0] y;

mult2 dut(
  .sel,
  .a,
  .b,
  .y
);

initial begin
  sel = 0; #1;
  a = 32'b0;
  b = 32'b1;
  #1;
  assert(y == 32'b0) else $error("select a failed");
  sel = 1; #1;
  assert(y == 32'b1) else $error("select b failed");
  #1;
  $finish;
end

endmodule
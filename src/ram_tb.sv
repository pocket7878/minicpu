module ram_tb;

logic clk, rst;
logic [31:0] a;
logic [31:0] wd;
logic we;
logic [31:0] rd;

ram dut(
  .clk,
  .rst,
  .a,
  .wd,
  .we,
  .rd
);

initial begin
  a = 32'b100;
  wd = 32'b0;
  we = 0;
  clk = 0;
  rst = 1; #1; rst = 0; #1;
  //Data initialize
  assert(rd === 32'b0) else $error("failed to initialize memory");
  wd = 32'b100; #1;
  we = 1; #1;
  clk = 1; #1; clk = 0; #1;
  assert(rd === 32'b100) else $error("failed to write data.");
  $finish;
end

endmodule
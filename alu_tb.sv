`timescale 1ps/1ps

module alu_tb();
  logic [3:0] ain;
  logic [3:0] bin;
  logic c;
  logic [3:0] out;

  alu dut(
    .ain(ain),
    .bin(bin),
    .c(c),
    .out(out)
  );

  initial begin
    ain = 4'b0000;
    bin = 4'b0000;
    #2
    ain = 4'b0000;
    bin = 4'b0001;
    #2
    ain = 4'b0001;
    bin = 4'b0000;
    #2
    ain = 4'b0001;
    bin = 4'b0001;
    #2
    ain = 4'b1111;
    bin = 4'b1111;
    #2
    $finish;
  end
endmodule
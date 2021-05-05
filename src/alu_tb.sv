`timescale 1ps/1ps
`include "def.svh"

module alu_tb();
  logic [`DATA_WIDTH-1:0] ain;
  logic [`DATA_WIDTH-1:0] bin;
  logic c;
  logic [`DATA_WIDTH-1:0] out;

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
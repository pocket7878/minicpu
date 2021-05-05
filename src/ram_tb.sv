`include "def.svh"

module ram_tb;

  parameter ADR_W = 4;

  logic clk;
  logic we;
  logic [ADR_W-1:0] adr;
  logic [`DATA_WIDTH-1:0] wdata;
  logic [`DATA_WIDTH-1:0] rdata;

  ram dut(
    .clk(clk),
    .we(we),
    .adr(adr),
    .din(wdata),
    .dout(rdata)
  );

  initial begin
    // initial clk
    clk = 0; #1;
    // Write data
    wdata = 8'b0101_0101;
    adr = 4'b0101;
    we = 1;
    #1;
    clk = 1; #1; clk = 0; #1;
    // Read data
    we = 0;
    #1;
    assert (rdata === 8'b0101_0101) else $error("Data write failed");
  end

endmodule
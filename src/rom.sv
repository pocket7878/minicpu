`include "def.svh"

module rom(
  input var [3:0] addr,
  output var logic [`PROG_WIDTH-1:0] out
);

  logic [`PROG_WIDTH-1:0] mem[0:15] /* synthesis ram_init_file = "rom.mif" */;
  initial begin
    $display("Loading rom.");
    $readmemb("rom.mem", mem); 
  end

  assign out = mem[addr];
endmodule

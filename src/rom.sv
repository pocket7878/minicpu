module rom(
  input var [31:0] a,
  output var logic [31:0] rd
);

  logic [31:0] mem[0:1023] /* synthesis ram_init_file = "rom.mif" */;

  initial begin
    $display("Loading rom.");
    $readmemb("rom.mem", mem); 
  end

  assign rd = mem[a>>2];
endmodule

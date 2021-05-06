module rom_tb;

logic [31:0] a;
logic [31:0] rd;

rom dut(
  .a,
  .rd
);

initial begin
  a = 32'b0; #1;
  assert(rd === 32'b0000000000000111_0000000000000001) else $error("Read rom failed");
  a = 32'b100; #1;
  assert(rd === 32'b0000000000000010_0000000000000000) else $error("Read by byte address failed.");
  $finish;
end

endmodule
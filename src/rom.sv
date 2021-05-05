`include "def.svh"

module rom(
  input var [3:0] addr,
  output var logic [`PROG_WIDTH-1:0] out
 );
  
  always_comb begin
    case (addr)
      4'b0000: out=12'b0111_00000000; // MOV B,0
      4'b0001: out=12'b0010_00000000; // IN A,
      4'b0010: out=12'b0000_00000001; // ADD A,1
      4'b0011: out=12'b0100_00000000; // MOV B,A
      4'b0100: out=12'b1001_00000000; // OUT B,
      4'b0101: out=12'b1111_00000101; // JMP 5,
      default: out=12'b1111_00000000; // JMP 0,
    endcase
  end
endmodule

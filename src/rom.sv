`include "def.svh"

module rom(
  input var [3:0] addr,
  output var logic [`PROG_WIDTH:0] out
 );
  
  always_comb begin
    case (addr)
      4'b0000: out=8'b01110000; // MOV B,0
      4'b0001: out=8'b00100000; // IN A,
      4'b0010: out=8'b00000001; // ADD A,1
      4'b0011: out=8'b01000000; // MOV B,A
      4'b0100: out=8'b10010000; // OUT B,
      4'b0101: out=8'b11110101; // JMP 5,
      default: out=8'b1111_0000; // DEFAULT: JMP 0
    endcase
  end
endmodule

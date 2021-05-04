module rom(
  input var [3:0] addr,
  output var logic [7:0] out
 );
  
  always_comb begin
    case (addr)
      4'b0000: out=8'b0010_0000; // IN A,
      4'b0001: out=8'b0111_0000; // MOV B,0
      4'b0010: out=8'b0000_0001; // ADD A,1
      4'b0011: out=8'b0000_0001; // ADD A,1
      4'b0100: out=8'b0100_0000; // MOV B,A
      4'b0101: out=8'b1001_0000; // OUT B,
      4'b0110: out=8'b1111_0110; // JMP 6,
      default: out=8'b1111_0000; // DEFAULT: JMP 0
    endcase
  end
endmodule

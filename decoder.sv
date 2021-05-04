module decoder(
  input var logic [3:0] op,
  input var logic c,
  output var logic [1:0] sel,
  output var logic [3:0] ld
);

  // Op code parameter
  parameter MOV_A_IM = 4'b0011,
            MOV_B_IM = 4'b0111,
            MOV_A_B = 4'b0001,
            MOV_B_A = 4'b0100,
            ADD_A_IM = 4'b0000,
            ADD_B_IM = 4'b0101,
            IN_A = 4'b0010,
            IN_B = 4'b0110,
            OUT_IM = 4'b1011,
            OUT_B = 4'b1001,
            JMP_IM = 4'b1111,
            JNC_IM = 4'b1110;
  
  // Load pattern
  parameter LOAD_A = 4'b1110,
            LOAD_B = 4'b1101,
            LOAD_C = 4'b1011,
            LOAD_PC = 4'b0111,
            LOAD_IGN = 4'bxxxx;

  // Select pattern
  parameter SELECT_A = 2'b00,
            SELECT_B = 2'b01,
            SELECT_IN = 2'b10,
            SELECT_ZERO = 2'b11;
  
  logic [3:0] load;
  logic [1:0] select;
  
   always_comb begin      
    case (op) 
      MOV_A_IM: begin
        load <= LOAD_A;
        select <= SELECT_ZERO;
      end
      MOV_B_IM: begin
        load <= LOAD_B;
        select <= SELECT_ZERO;
      end
      MOV_A_B: begin
        load <= LOAD_A;
        select <= SELECT_B;
      end
      MOV_B_A: begin
        load <= LOAD_B;
        select <= SELECT_A;
      end
      ADD_A_IM: begin
        load <= LOAD_A;
        select <= SELECT_A;
      end
      ADD_B_IM: begin
        load <= LOAD_B;
        select <= SELECT_B;
      end
      IN_A: begin
        load <= LOAD_A;
        select <= SELECT_IN;
      end
      IN_B: begin
        load <= LOAD_B;
        select <= SELECT_IN;
      end
      OUT_IM: begin
        load <= LOAD_C;
        select <= SELECT_ZERO;
      end
      OUT_B: begin
        load <= LOAD_C;
        select <= SELECT_B;
      end
      JMP_IM: begin
        load <= LOAD_PC;
        select <= SELECT_ZERO;
      end
      JNC_IM: if (c == 0) begin
        load <= LOAD_PC;
        select <= SELECT_ZERO;
      end
      else begin
        load <= LOAD_IGN;
        select <= SELECT_ZERO;
      end
      default: begin
        load <= LOAD_IGN;
        select <= SELECT_ZERO;
      end
    endcase
  end

  assign ld=load;
  assign sel=select;
endmodule

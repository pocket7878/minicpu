module control_unit(
  input var logic [5:0] op,
  input var logic [5:0] funct,
  output var logic mem_to_reg,
  output var logic mem_write,
  output var logic [1:0] branch,
  output var logic alu_src,
  output var logic reg_dst,
  output var logic reg_write,
  output var logic jump,
  output var logic [2:0] alu_control
);

logic [1:0] alu_op;

alu_decoder alu_decoder_u(
  .alu_op(alu_op),
  .funct(funct),
  .alu_control(alu_control)
);

always_comb begin
  casez (op)
    // R-type
    6'b000000: begin
      reg_write <= 1;
      reg_dst <= 1;
      branch <= 2'b00;
      mem_write <= 0;
      mem_to_reg <= 0;
      alu_op <= 2'b10;
      jump <= 0;
      if (funct == 6'b000000) begin
        alu_src <= 1;
      end
      else begin
        alu_src <= 0;
      end
    end
    // lw
    6'b100011: begin
      reg_write <= 1;
      reg_dst <= 0;
      alu_src <= 1;
      branch <= 2'b00;
      mem_write <= 0;
      mem_to_reg <= 1;
      alu_op <= 2'b00;
      jump <= 0;
    end
    // sw
    6'b101011: begin
      reg_write <= 0;
      reg_dst <= 1'bx;
      alu_src <= 1;
      branch <= 2'b00;
      mem_write <= 1;
      mem_to_reg <= 1'bx;
      alu_op <= 2'b00;
      jump <= 0;
    end
    // beq
    6'b000100: begin
      reg_write <= 0;
      reg_dst <= 1'bx;
      alu_src <= 0;
      branch <= 2'b01;
      mem_write <= 0;
      mem_to_reg <= 1'bx;
      alu_op <= 2'b01;
      jump <= 0;
    end
    // bne
    6'b000101: begin
      reg_write <= 0;
      reg_dst <= 1'bx;
      alu_src <= 0;
      branch <= 2'b11;
      mem_write <= 0;
      mem_to_reg <= 1'bx;
      alu_op <= 2'b01;
      jump <= 0;
    end
    // addi, addiu
    6'b00100?: begin
      reg_write <= 1;
      reg_dst <= 0;
      alu_src <= 1;
      branch <= 2'b00;
      mem_write <= 0;
      mem_to_reg <= 0;
      alu_op <= 2'b00;
      jump <= 0;
    end
    // j
    6'b000010: begin
      reg_write <= 0;
      reg_dst <= 1'bx;
      alu_src <= 1'bx;
      branch <= 2'bxx;
      mem_write <= 0;
      mem_to_reg <= 1'bx;
      alu_op <= 2'bxx;
      jump <= 1;
    end
    default: begin
      reg_write <= 1'bx;
      reg_dst <= 1'bx;
      alu_src <= 1'bx;
      branch <= 2'bxx;
      mem_write <= 1'bx;
      mem_to_reg <= 1'bx;
      alu_op <= 2'bxx;
      jump <= 1'bx;
    end
  endcase
end

endmodule
module MINI_CPU(
  input var RST,
  input var CLK,
  output var [6:0] HEX0,
  output var [6:0] HEX1,
  output var [6:0] HEX2,
  output var [6:0] HEX3,
  output var [6:0] HEX4,
  output var [6:0] HEX5
);

// Program counter
logic [31:0] next_pc;
logic [31:0] curr_pc;
pc pc_u(.clk(CLK), .rst(RST), .next_pc(next_pc), .pc(curr_pc));

// Program memory
logic [31:0] instr;
rom rom_u(.a(curr_pc), .rd(instr));

// Register file
logic [4:0] a1, a2, a3;
logic [31:0] wd3;
logic [31:0] rd1, rd2;
logic [31:0] out;
register_file register_file_u(
  .clk(CLK),
  .rst(RST),
  .a1(a1),
  .a2(a2),
  .a3(a3),
  .we3(reg_write),
  .wd3(wd3),
  .rd1(rd1),
  .rd2(rd2),
  .out(out)
);

// Display Debug
seg7dec v0_hi(.a(out[7:4]), .HEX0(HEX1));
seg7dec v0_lo(.a(out[3:0]), .HEX0(HEX0));

logic [31:0] write_data;
assign write_data = rd2;

// Program memory -> Register file

// Step 1: Judge rt <-> rd
assign a1 = instr[25:21];
assign a2 = instr[20:16];
logic [31:0] prg_write_reg;
logic reg_dst;
mult2 prg_reg(.sel(reg_dst), .a(instr[20:16]), .b(instr[15:11]), .y(prg_write_reg));

// Step 2: Judge rt or not
logic [31:0] write_reg;
logic reg_ra;
mult2 ra_reg(.sel(reg_ra), .a(prg_write_reg), .b(32'd31), .y(write_reg));
assign a3 = write_reg[4:0];

// Sign Extend
logic [31:0] sign_imm;
assign sign_imm[15:0] = instr[15:0];
assign sign_imm[31:16] = instr[15];

// ALU
logic [31:0] src_a, src_b;
logic [2:0] alu_control;
logic zero;
logic [31:0] alu_result;
alu alu_u(
  .a(src_a),
  .b(src_b),
  .f(alu_control),
  .zero(zero),
  .y(alu_result)
);


// Register -> ALU
assign src_a = rd1;
logic alu_src;
mult2 alu_src_mult(.sel(alu_src), .a(rd2), .b(sign_imm), .y(src_b));

// Data Memory
logic mem_write;
logic [31:0] read_data;
ram ram_u(
  .clk(CLK),
  .rst(RST),
  .a(alu_result),
  .we(mem_write),
  .wd(write_data),
  .rd(read_data)
);

// Increment Program Counter & Branch Program Counter
logic pc_src;
logic [1:0] branch;
branch_judge branch_judge_u(.branch, .zero, .y(pc_src));

logic [31:0] pc_plus_4;
logic [31:0] pc_branch;
assign pc_plus_4 = curr_pc + 4;
assign pc_branch = (sign_imm << 2) + pc_plus_4;

logic [31:0] branch_next_pc;

mult2 pc_mult(.sel(pc_src), .a(pc_plus_4), .b(pc_branch), .y(branch_next_pc));

// Data Memory or PC -> Register File
logic mem_to_reg;
logic [31:0] mem_reg_result;
mult2 mem_reg_mult(.sel(mem_to_reg), .a(alu_result), .b(read_data), .y(mem_reg_result));

logic pc_to_reg;
logic [31:0] pc_reg_result;
mult2 pc_reg_mult(.sel(pc_to_reg), .a(mem_reg_result), .b(pc_plus_4), .y(pc_reg_result));

assign wd3 = pc_reg_result;

// Direct jump
logic jump;
logic [31:0] pc_jump;
assign pc_jump[31:28] = pc_plus_4[31:28];
assign pc_jump[27:0] = instr[25:0] << 2;
logic [31:0] direct_jump_pc;

mult2 pc_jump_mult(.sel(jump), .a(branch_next_pc), .b(pc_jump), .y(direct_jump_pc));

// Register jump
logic [31:0] reg_jump;
assign reg_jump = rd1;
logic jump_reg;

mult2 pc_reg_jump_mult(.sel(jump_reg), .a(direct_jump_pc), .b(reg_jump), .y(next_pc));

// Control Unit
control_unit control_unit_u(
  .op(instr[31:26]),
  .funct(instr[5:0]),
  .mem_to_reg,
  .pc_to_reg,
  .mem_write,
  .branch,
  .alu_control,
  .alu_src,
  .reg_dst,
  .reg_ra,
  .reg_write,
  .jump,
  .jump_reg
);

endmodule

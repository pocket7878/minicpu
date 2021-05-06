`include "def.svh"

module MINI_CPU(
  input var RST,
  input var CLK,
  input var [`DATA_WIDTH-1:0] SW,
  output var [`DATA_WIDTH-1:0] outp,
  output var [6:0] HEX0,
  output var [6:0] HEX1,
  output var [6:0] HEX2,
  output var [6:0] HEX3,
  output var [6:0] HEX4,
  output var [6:0] HEX5
);

  parameter ZERO = 4'b0000;

  logic [`DATA_WIDTH-1:0] ch0, ch1, ch2, ch3;
  logic [`DATA_WIDTH-1:0] addr;
  
  logic [`DATA_WIDTH-1:0] a;
  
  logic [`PROG_WIDTH-1:0] prog_data;
  
  logic [`DATA_WIDTH-1:0] alu_out;
  logic [3:0] ld;
  
  logic cflag;
  logic cflga_r;
  
  logic [1:0] sel;
  
  assign outp = ch2;
  logic [`OP_WIDTH-1:0] op;
  logic [`IM_WIDTH-1:0] im;
  
  // Program Memory
  rom prog_rom(.addr(addr),.out(prog_data));

  // Always zero dummy register.
  assign ch3 = ZERO;
  
  // Clock division to 1 clock par 1s.
  logic clk;
  //slow_clk slow_clk_u(.clk(CLK), .rst(RST), .out(clk));
  assign clk = CLK;
  
  // Registers
  register areg(.reset(RST),.in(alu_out),.ld(ld[0]),.clk(clk),.out(ch0));
  register breg(.reset(RST),.in(alu_out),.ld(ld[1]),.clk(clk),.out(ch1));
  register creg(.reset(RST),.in(alu_out),.ld(ld[2]),.clk(clk),.out(ch2));
  counter    pc(.reset(RST),.in(alu_out),.ld(ld[3]),.clk(clk),.out(addr));
  
  // Memory Data Selector
  assign op = prog_data[`PROG_WIDTH-1:`PROG_WIDTH-`OP_WIDTH];
  assign im = prog_data[`IM_WIDTH-1:0];
  
  decoder decoder_u(.op(op),.c(cflag),.sel(sel),.ld(ld));

  dataselector dataselector_u(
    .sel(sel),
    .c0(ch0),
    .c1(ch1),
    .c2(SW),
    .c3(ch3),
    .y(a)
  );

  alu alu_u(.ain(a), .bin(im), .c(cflag_r), .out(alu_out));
  
  seg7dec disp_op(.a(op), .HEX0(HEX5));
  seg7dec disp_im(.a(im), .HEX0(HEX4));
  seg7dec disp_pc(.a(addr), .HEX0(HEX3));
  seg7dec disp_outp_h(.a(outp[7:4]), .HEX0(HEX1));
  seg7dec disp_outp_l(.a(outp[3:0]), .HEX0(HEX0));

  always_ff @(posedge clk) begin
    if (RST) begin
      cflag = 1'b0;
    end
    else begin
      cflag = cflag_r;
    end
  end
endmodule

module TD4(
  input var RST,
  input var CLK,
  input var [3:0] SW,
  output var [3:0] outp,
  output var [6:0] HEX0,
  output var [6:0] HEX1,
  output var [6:0] HEX2,
  output var [6:0] HEX3,
  output var [6:0] HEX4,
  output var [6:0] HEX5
);

  parameter ZERO = 4'b0000;

  logic [3:0] ch0, ch1, ch2, ch3;
  logic [3:0] addr;
  
  logic [3:0] a;
  
  logic [7:0] memdata;
  
  logic [3:0] alu_out;
  logic [3:0] ld;
  
  logic cflag;
  logic cflga_r;
  
  logic [1:0] sel;
  
  assign outp = ch2;
  logic [3:0] op, im;
  
  // Program Memory
  rom rom_u(.addr(addr),.out(memdata));

  // Always zero dummy register.
  assign ch3 = ZERO;
  
  // Clock division to 1 clock par 1s.
  logic clk;
  slow_clk slow_clk_u(.clk(CLK), .rst(RST), .out(clk));
  
  // Registers
  register areg(.reset(RST),.in(alu_out),.ld(ld[0]),.clk(clk),.out(ch0));
  register breg(.reset(RST),.in(alu_out),.ld(ld[1]),.clk(clk),.out(ch1));
  register creg(.reset(RST),.in(alu_out),.ld(ld[2]),.clk(clk),.out(ch2));
  counter    pc(.reset(RST),.in(alu_out),.ld(ld[3]),.clk(clk),.out(addr));
  
  // Memory Data Selector
  assign op = memdata[7:4];
  assign im = memdata[3:0];
  
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
  
  // Display Machine state on-board LED.
  seg7dec disp_op(.SW(op), .HEX0(HEX5));
  seg7dec disp_im(.SW(im), .HEX0(HEX4));
  seg7dec disp_pc(.SW(addr), .HEX0(HEX3));
  seg7dec disp_a(.SW(ch0), .HEX0(HEX2));
  seg7dec disp_b(.SW(ch1), .HEX0(HEX1));
  seg7dec disp_outp(.SW(ch2), .HEX0(HEX0));

  always_ff @(posedge clk) begin
    if (RST) begin
      cflag = 1'b0;
    end
    else begin
      cflag = cflag_r;
    end
  end
endmodule

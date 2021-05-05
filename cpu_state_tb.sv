module cpu_state_tb;
  logic clk;
  logic rst;
  logic [1:0] state;

  cpu_state subject(
    .clk(clk),
    .rst(rst),
    .state(state)
  );

  initial begin
    clk = 1'b0;
    rst = 1'b1;
    #1;
    rst = 1'b0;
    #1;
    clk = 1'b1;
    #1;
    clk = 1'b0;
    #1;
    clk = 1'b1;
    #1;
    clk = 1'b0;
    #1;
    clk = 1'b1;
    #1;
    $finish;
   end

endmodule
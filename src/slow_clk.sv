module slow_clk(
  input var logic clk,
  input var logic rst,
  output var logic out
);

  // Original Clock is 50MHz
  parameter COUNT_DEFAULT = 26'b0,
            COUNT_MAX = 26'd49_999_999;

  logic [25:0] cnt;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      cnt <= COUNT_DEFAULT;
      out <= 0;
    end
    else if (cnt == COUNT_MAX) begin
      out <= 1;
      cnt <= COUNT_DEFAULT;
    end
    else begin
      out <= 0;
      cnt <= cnt + 26'b1;
    end
  end

endmodule

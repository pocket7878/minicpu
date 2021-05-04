module slow_clk(
  input var logic clk,
  input var logic rst,
  output var logic out
);

  // Original Clock is 50MHz
  parameter COUNT_MAX = 26'd49_999_999;
  logic [25:0] cnt;

  always_ff @(posedge clk) begin
    if (rst) begin
      cnt <= 26'b0;
    end
    else if (cnt == COUNT_MAX) begin
      out <= 1;
    end
    else begin
      out <= 0;
      cnt <= cnt + 26'b1;
    end
  end

endmodule
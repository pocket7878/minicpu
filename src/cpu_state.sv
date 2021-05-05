module cpu_state(
  input var logic clk,
  input var logic rst,
  output var logic [1:0] state
);
  parameter STATE_IF = 2'b01,
            STATE_EXEC = 2'b10;

  logic [1:0] st;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      st <= STATE_IF;
    end
    else if (st == STATE_IF) begin
      st <= STATE_EXEC;
    end
    else if (st == STATE_EXEC) begin
      st <= STATE_IF;
    end
  end

  assign state = st;
endmodule
module baud_rt_gen
#(
  parameter N = 1,
            N_BITS = 1
)
(
  input  logic clk, rst,
  output logic max_tick
);

logic [N_BITS-1:0] next_state;
logic [N_BITS-1:0] current_state;

always @(posedge clk)
  if (rst)
    current_state <= 0;
  else
    current_state <= next_state;

always @*
begin
  if (current_state == N)
  begin
    max_tick = 1'b1;
    next_state = 0;
  end
  else
  begin
    max_tick = 1'b0;
    next_state = current_state + 1;
  end
end

endmodule
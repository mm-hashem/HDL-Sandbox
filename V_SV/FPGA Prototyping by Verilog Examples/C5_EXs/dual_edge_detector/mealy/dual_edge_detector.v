module dual_edge_detector
(
  input wire clk, rst,
             wave,
  output reg tick
);

localparam S0 = 1'b0,
           S1 = 1'b1;

reg current_state, next_state;

always @(posedge clk)
  if (rst)
    current_state <= S0;
  else
    current_state <= next_state;

always @*
begin
  tick = 1'b0;
  next_state = current_state;
  case(current_state)
    S0:
    begin
      next_state = wave ? S1 : S0;
      tick = wave ? 1'b1 : 1'b0;  
    end
    S1:
    begin
      next_state = wave ? S1 : S0;
      tick = wave ? 1'b0 : 1'b1;
    end
    default: next_state = S0;
  endcase
end

endmodule

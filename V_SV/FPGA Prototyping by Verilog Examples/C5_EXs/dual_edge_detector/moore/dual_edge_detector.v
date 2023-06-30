module dual_edge_detector
(
  input wire clk, rst,
             wave,
  output reg tick
);

localparam S0 = 2'b00,
           S1 = 2'b01,
           S2 = 2'b10,
           S3 = 2'b11;


reg [1:0] current_state, next_state;

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
    S0: next_state = wave ? S1 : S0;
    S1:
    begin
      tick = 1'b1;
      next_state = wave ? S2 : S0;
    end
    S2: next_state = wave ? S2 : S3;
    S3:
    begin
      tick = 1'b1;
      next_state = S0;
    end
    default: next_state = S0;
  endcase
end

endmodule

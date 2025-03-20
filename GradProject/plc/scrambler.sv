module scrambler
(
  input  logic clk,
               scrm_in,
               start,
  output logic scrm_out
);

logic [9:0] lfsr;
logic [2:0] current_bit, next_bit;
logic current_state, next_state;
initial
begin
  lfsr = {10{1'b1}};
  current_bit = 0;
  current_state = 0;
end

always @(posedge clk)
begin
  lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[2]};
  current_bit <= next_bit;
  current_state <= next_state;
end

always @*
begin
  next_bit = current_bit;

  case(current_state)
    1'b0:
    begin
      if (start)
      begin
        next_state = 1'b1;
        lfsr = {10{1'b1}};
      end
      else
        next_state = 0;
    end
    1'b1:
    begin
      if (current_bit == 7)
      begin
        next_bit = 0;
        next_state = 1'b0;
      end
      else
      begin
        next_bit = current_bit + 1;
        next_state = 1'b1;
      end
    end
  endcase
end

assign scrm_out = scrm_in ^ (lfsr[9] ^ lfsr[2]);

endmodule
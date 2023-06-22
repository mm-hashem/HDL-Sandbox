module stopwatch
(
  input  wire       clk, rst, go,  up,
  output wire [3:0] d3,  d2,  d1,  d0
);

// counter
reg counter_rst;
wire max_tick;
counter counter_inst(.clk(clk), .rst(counter_rst), .max_tick(max_tick));

// state reg logic
parameter S0 = 2'b00,
          S1 = 2'b01,
          S2 = 2'b10,
          S3 = 2'b11;

reg [1:0] current_state, next_state;
reg [9:0] _01s_counter_current, _1s_counter_current, _10s_counter_current, _60s_counter_current;
reg [9:0] _01s_counter_next,    _1s_counter_next,    _10s_counter_next,    _60s_counter_next;

always @(posedge clk)
begin
  if (rst)
  begin
    current_state        <= S0;
    _01s_counter_current <= 0;
    _1s_counter_current  <= 0;
    _10s_counter_current <= 0;
    _60s_counter_current <= 0;
  end
  else
  begin
    current_state        <= next_state;
    _01s_counter_current <= _01s_counter_next;
    _1s_counter_current  <= _1s_counter_next;
    _10s_counter_current <= _10s_counter_next;
    _60s_counter_current <= _60s_counter_next;
  end
end

// next state logic
always @*
begin
  _01s_counter_next = _01s_counter_current;
  _1s_counter_next  = _1s_counter_current;
  _10s_counter_next = _10s_counter_current;
  _60s_counter_next = _60s_counter_current;
  case(current_state)
    S0:
    begin
      counter_rst = 1'b1;
      next_state = go && up ? S1 : go && !up ? S2 : S0;
    end
    S1:
    begin
      counter_rst = 1'b0;

      if (max_tick && !(_01s_counter_current == 9))
        _01s_counter_next = _01s_counter_current + 1;

      if ((_01s_counter_current == 9) && max_tick && !(_1s_counter_current == 10))
      begin
        _01s_counter_next = 0;
        _1s_counter_next = _1s_counter_current + 1;
      end

      if ((_1s_counter_current == 10) && max_tick && !(_10s_counter_current == 6))
      begin
        _1s_counter_next = 0;
        _10s_counter_next = _10s_counter_current + 1;
      end

      if ((_10s_counter_current == 6) && max_tick && !(_60s_counter_current == 10))
      begin
        _10s_counter_next = 0;
        _60s_counter_next = _60s_counter_current + 1;
      end

      next_state = max_tick ? S3 : go && up ? S1 : go && !up ? S2 : S0;
    end
    S2:
    begin
      counter_rst = 1'b0;

      if (max_tick && !(_01s_counter_current == 0))
        _01s_counter_next = _01s_counter_current - 1;

      if ((_01s_counter_current == 0) && max_tick && !(_1s_counter_current == 0))
      begin
        _01s_counter_next = 9;
        _1s_counter_next = _1s_counter_current - 1;
      end

      if ((_1s_counter_current == 0) && max_tick && !(_10s_counter_current == 0))
      begin
        _1s_counter_next = 9;
        _10s_counter_next = _10s_counter_current - 1;
      end

      if ((_10s_counter_current == 0) && max_tick && !(_60s_counter_current == 0))
      begin
        _10s_counter_next = 5;
        _60s_counter_next = _60s_counter_current - 1;
      end

      next_state = max_tick ? S3 : go && up ? S1 : go && !up ? S2 : S0;
    end
    S3:
    begin
      counter_rst = 1'b1;
      next_state = go && up ? S1 : go && !up ? S2 : S0;
    end
    default: next_state = S0;
  endcase
end


// output logic
assign d0 = _01s_counter_current;
assign d1 = _1s_counter_current;
assign d2 = _10s_counter_current;
assign d3 = _60s_counter_current;

endmodule

module counter
(
  input  wire clk, rst,
  output wire max_tick
);

wire [22:0] next_state;
reg  [22:0] current_state;

always @(posedge clk)
  if (rst)
    current_state <= 0;
  else
    current_state <= next_state;

assign next_state = current_state + 1;
assign max_tick   = (current_state == 3) ? 1'b1 : 1'b0;

endmodule

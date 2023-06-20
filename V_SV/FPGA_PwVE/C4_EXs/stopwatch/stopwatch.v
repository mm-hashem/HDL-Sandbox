module stopwatch
(
  input  wire       clk, rst, go,  up,
  output wire [3:0] d3,  d2,  d1,  d0
);

reg [3:0] d0_current, d1_current, d2_current, d3_current;
reg [3:0] d0_next, d1_next, d2_next, d3_next;

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

always @(posedge clk)
begin
  if (rst)
  begin
    current_state <= S0;
    d0_current <= 0;
    d1_current <= 0;
    d2_current <= 0;
    d3_current <= 0;
  end
  else
  begin
    current_state <= next_state;
    d0_current <= d0_next;
    d1_current <= d1_next;
    d2_current <= d2_next;
    d3_current <= d3_next;
  end
end

// next state logic
always @*
begin
  case(current_state)
    S0:
    begin
      counter_rst = 1'b1;
      d0_next = d0_current;
      d1_next = d1_current;
      d2_next = d2_current;
      d3_next = d3_current;
      next_state = go && up ? S1 : go && !up ? S2 : S0;
    end
    S1:
    begin
      counter_rst = 1'b0;

      if (d0_current == 9)
        d0_next = d0_current;
      else if (max_tick)
        d0_next = d0_current + 1;

      if (d0_current == 9)
        if (d1_current == 9)
          d1_next = d1_current;
        else if (max_tick)
          d1_next = d1_current + 1;
      else
        d1_next = d1_current;

      if (d1_current == 9)
        if (d2_current == 5)
          d2_next = d2_current;
        else if (max_tick)
          d2_next = d2_current + 1;
      else
        d2_next = d2_current;

      if (d2_current == 5)
        if (d3_current == 9)
          d3_next = d3_current;
        else if (max_tick)
          d3_next = d3_current + 1;
      else
        d3_next = d3_current;

      next_state = max_tick ? S3 : go && up ? S1 : go && !up ? S2 : S0;
    end
    S2:
    begin
      counter_rst = 1'b0;

      if (d3_current == 0)
        d3_next = d3_current;
      else if (max_tick)
        if (d3_current == 0)
          d3_next = d3_current;
        else
          d3_next = d3_current - 1;

      if (d3_current == 0)
        if (max_tick)
          if (d2_current == 0)
            d2_next = d2_current;
          else
            d2_next = d2_current - 1;
        else
          d2_next = d2_current;
      else
        d2_next = d2_current;
      
      if (d2_current == 0)
        if (max_tick)
          if (d1_current == 0)
            d1_next = d1_current;
          else
            d1_next = d1_current - 1;
        else
          d1_next = d1_current;
      else
        d1_next = d1_current;

      if (d1_current == 0)
        if (max_tick)
          if (d0_current == 0)
            d0_next = d0_current;
          else
            d0_next = d0_current - 1;
        else
          d0_next = d0_current;
      else
        d0_next = d0_current;

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
assign d0 = d0_current;
assign d1 = d1_current;
assign d2 = d2_current;
assign d3 = d3_current;

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
assign max_tick = (current_state == 3) ? 1'b1 : 1'b0;

endmodule

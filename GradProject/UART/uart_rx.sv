module uart_rx
#(
  parameter DATA_BITS = 8,
            STOP_TICKS = 16
)
(
  input  logic       clk, rst,
                     rx, tick,
  output logic       rx_done,
  output logic [7:0] dout
);

localparam [1:0]
  idle  = 2'b00,
  start = 2'b01,
  data  = 2'b10,
  stop  = 2'b11;

logic [1:0] current_state, next_state;
logic [3:0] current_tick , next_tick;
logic [2:0] current_bit  , next_bit;
logic [7:0] current_data , next_data;

always @(posedge clk)
  if (rst)
  begin
    current_state <= idle;
    current_tick  <= 0;
    current_bit   <= 0;
    current_data  <= 0;
  end
  else
  begin
    current_state <= next_state;
    current_tick  <= next_tick;
    current_bit   <= next_bit;
    current_data  <= next_data;
  end

always @*
begin
  next_state = current_state;
  next_tick  = current_tick;
  next_bit   = current_bit;
  next_data  = current_data;
  rx_done    = 1'b0;

  case(current_state)
    idle:
    begin
      if (!rx)
      begin
        next_state = start;
        next_tick = 0;
      end
    end
    start:
    begin
      if (tick)
        if (current_tick == 7)
        begin
          next_state = data;
          next_tick  = 0;
          next_bit   = 0;
        end
        else
          next_tick = current_tick + 1;
    end
    data:
    begin
      if (tick)
        if (current_tick == 15)
        begin
          next_tick = 0;
          next_data = {rx, current_data[7:1]};
          next_bit = current_bit + 1;
          if (current_bit == (DATA_BITS - 1))
            next_state = stop;
        end
        else
          next_tick = current_tick + 1;
    end
    stop:
    begin
      if (tick)
        if (current_tick == (STOP_TICKS - 1))
        begin
          next_state = idle;
          rx_done = 1'b1;
        end
        else
          next_tick = current_tick + 1;
    end
    default: next_state = idle;
  endcase
  assign dout = current_data;
end

endmodule
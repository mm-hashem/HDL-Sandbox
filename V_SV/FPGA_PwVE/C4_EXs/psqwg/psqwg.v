module psqwg
#(
  parameter T = 20,
  parameter M_BITS = 4,
  parameter N_BITS = 4,
  parameter COUNTER_BITS = 7
)
(
  input wire clk, rst, en,
  input  wire [M_BITS-1:0] m,
  input  wire [N_BITS-1:0] n,
  output wire sq_wave
);

localparam TICKS_MLTPLR = 100 / T;

reg [1:0] next_state;
reg [1:0] current_state;

reg rst_m, rst_n;
wire max_tick_m, max_tick_n;

counter_m #(.TICKS_MLTPLR(TICKS_MLTPLR), .COUNTER_BITS(COUNTER_BITS), .TICKS_BITS(M_BITS)) counter_m_inst (.clk(clk), .rst(rst_m), .ticks_num(m), .max_tick(max_tick_m));
counter_n #(.TICKS_MLTPLR(TICKS_MLTPLR), .COUNTER_BITS(COUNTER_BITS), .TICKS_BITS(N_BITS)) counter_n_inst (.clk(clk), .rst(rst_n), .ticks_num(n), .max_tick(max_tick_n));

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// current state
always @(posedge clk)
  if (rst)
    current_state <= S0;
  else
    current_state <= next_state;

// next state
always @*
begin
  case(current_state)
    S0: begin
      next_state = en ? S1 : S0;
      rst_m = 1'b1;
      rst_n = 1'b1;
    end
    S1: begin
      rst_n = 1'b1;
      rst_m = 1'b0;
      next_state = en ? (max_tick_m ? S2 : S1) : S0;
    end
    S2: begin
      rst_n = 1'b0;
      rst_m = 1'b1;
      next_state = en ? (max_tick_n ? S1 : S2) : S0;
    end
  endcase
end

//output logic
assign sq_wave = (current_state == S1) ? 1'b1 : 1'b0;

endmodule

module counter_m
#(
  parameter TICKS_MLTPLR = 5,
  parameter COUNTER_BITS = 7,
  parameter TICKS_BITS = 4
)
(
  input  wire clk, rst,
  input  wire [TICKS_BITS-1:0] ticks_num,
  output wire max_tick
);

wire [COUNTER_BITS-1:0] next_state;
reg  [COUNTER_BITS-1:0] current_state;

always @(posedge clk)
  if (rst)
    current_state <= 0;
  else
    current_state <= next_state;

assign next_state = current_state + 1;
assign max_tick = (current_state == ticks_num * TICKS_MLTPLR - 1) ? 1'b1 : 1'b0;

endmodule

module counter_n
#(
  parameter TICKS_MLTPLR = 5,
  parameter COUNTER_BITS = 7,
  parameter TICKS_BITS = 4
)
(
  input  wire clk, rst,
  input  wire [TICKS_BITS-1:0] ticks_num,
  output wire max_tick
);

wire [COUNTER_BITS-1:0] next_state;
reg  [COUNTER_BITS-1:0] current_state;

always @(posedge clk)
  if (rst)
    current_state <= 0;
  else
    current_state <= next_state;

assign next_state = current_state + 1;
assign max_tick = (current_state == ticks_num * TICKS_MLTPLR - 1) ? 1'b1 : 1'b0;

endmodule

module psqwg
(
  input wire clk, rst, en,
  input  wire [3:0] m,
  input  wire [3:0] n,
  output wire sq_wave
);

reg [1:0] next_state;
reg [1:0] current_state;

reg rst_m, rst_n;
wire max_tick_m, max_tick_n;

counter_m counter_m_inst (.clk(clk), .rst(rst_m), .m(m), .max_tick(max_tick_m));
counter_n counter_n_inst (.clk(clk), .rst(rst_n), .n(n), .max_tick(max_tick_n));

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
      next_state = max_tick_m ? S2 : S1;
    end
    S2: begin
      rst_n = 1'b0;
      rst_m = 1'b1;
      next_state = max_tick_n ? S1 : S2;
    end
  endcase
end

//output logic
assign sq_wave = (current_state == S1) ? 1'b1 : (current_state == S2) ? 1'b0 : 1'b0;

endmodule

module counter_m (
  input  wire clk, rst,
  input  wire [3:0] m,
  output wire max_tick
);

wire [6:0] next_state;
reg  [6:0] current_state;

always @(posedge clk)
  if (rst)
    current_state <= 7'b0000000;
  else
    current_state <= next_state;

assign next_state = current_state + 7'b0000001;
assign max_tick = (current_state == (m*5 - 1)) ? 1'b1 : 1'b0;

endmodule

module counter_n (
  input  wire clk, rst,
  input  wire [3:0] n,
  output wire max_tick
);

wire [6:0] next_state;
reg  [6:0] current_state;

always @(posedge clk)
  if (rst)
    current_state <= 7'b0000000;
  else
    current_state <= next_state;

assign next_state = current_state + 7'b0000001;
assign max_tick = (current_state == (n*5 - 1)) ? 1'b1 : 1'b0;

endmodule

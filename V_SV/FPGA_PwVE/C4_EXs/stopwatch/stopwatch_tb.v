`timescale 1ms/100us
module stopwatch_tb();

localparam T = 20;

reg        clk_tb, rst_tb, go_tb,  up_tb;
wire [3:0] d3_tb,  d2_tb,  d1_tb,  d0_tb;

stopwatch uut(.clk(clk_tb), .rst(rst_tb), .go(go_tb), .up(up_tb), .d3(d3_tb), .d2(d2_tb), .d1(d1_tb), .d0(d0_tb));

always
begin
  clk_tb = 1'b1;
  #(T/2);
  clk_tb = 1'b0;
  #(T/2);
end

initial
begin
  rst_tb = 1'b1;
  @(negedge clk_tb);
  rst_tb = 1'b0;
  @(negedge clk_tb);
  go_tb = 1'b1;
  up_tb = 1'b1;
  repeat(100) @(negedge clk_tb);
  up_tb = 1'b0;
  repeat(100) @(negedge clk_tb);
  $stop;
end

endmodule

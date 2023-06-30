`timescale 1ns/10ps
module dual_edge_detector_tb();

localparam T = 20;

reg clk_tb, rst_tb,
    wave_tb;
wire tick_tb;

dual_edge_detector uut(.clk(clk_tb), .rst(rst_tb), .wave(wave_tb), .tick(tick_tb));

always
begin
  clk_tb = 1'b1; #(T/2);
  clk_tb = 1'b0; #(T/2);
end

initial
begin
  rst_tb = 1'b1;
  @(negedge clk_tb);
  rst_tb = 1'b0;
  @(negedge clk_tb);
  wave_tb = 1'b0;
  @(negedge clk_tb);
  wave_tb = 1'b1;
  @(negedge clk_tb);
  wave_tb = 1'b0;
  @(negedge clk_tb);
  #5; wave_tb = 1'b1; #10; wave_tb = 1'b0;
  @(negedge clk_tb);
  @(negedge clk_tb);
  wave_tb = 1'b1;
  repeat(5) @(negedge clk_tb);
  wave_tb = 1'b0;
  @(negedge clk_tb);
  @(negedge clk_tb);
  $stop;
end

endmodule

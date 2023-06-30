`timescale 1ns/10ps
module psqwg_tb();

localparam T = 20;

reg clk_tb, rst_tb, en_tb;
reg [3:0] m_tb;
reg [3:0] n_tb;
wire sq_wave_tb;

psqwg uut(.clk(clk_tb), .rst(rst_tb), .m(m_tb), .n(n_tb), .sq_wave(sq_wave_tb), .en(en_tb));

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
  en_tb = 1'b0;
  @(negedge clk_tb);
  rst_tb = 1'b0;
  en_tb = 1'b1;
  m_tb = 4'b0001;
  n_tb = 4'b0001;
  repeat (20) @(negedge clk_tb);
  rst_tb = 1'b1;
  repeat (3) @(negedge clk_tb);
  rst_tb = 1'b0;
  en_tb = 1'b0;
  repeat (5) @(negedge clk_tb);
  $stop;
end

endmodule

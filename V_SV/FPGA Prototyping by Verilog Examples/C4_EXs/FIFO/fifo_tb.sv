`timescale 1ns/10ps
module fifo_tb();

localparam T = 20,
           DEPTH_tb = 2,
           WIDTH_tb = 4;

logic clk_tb, rst_tb,
      wr_tb, rd_tb,
      empty_tb, full_tb;

logic [WIDTH_tb-1:0] wr_data_tb, rd_data_tb;      

fifo #(
    .DEPTH(DEPTH_tb),
    .WIDTH(WIDTH_tb)
  )
  uut(
    .clk(clk_tb),
    .rst(rst_tb),
    .wr(wr_tb),
    .rd(rd_tb),
    .wr_data(wr_data_tb),
    .rd_data(rd_data_tb),
    .empty(empty_tb),
    .full(full_tb)
  );

always
begin
  clk_tb = 1'b1; #(T/2);
  clk_tb = 1'b0; #(T/2);
end

initial
begin
  rst_tb = 1'b1;
  wr_tb = 1'b0;
  rd_tb = 1'b0;
  wr_data_tb = 4'b0000;
  @(negedge clk_tb);
  rst_tb = 1'b0;
  wr_tb = 1'b1;
  wr_data_tb = 4'b0001;//1
  @(negedge clk_tb);
  wr_data_tb = 4'b0011;//3
  @(negedge clk_tb);
  wr_data_tb = 4'b0101;//5
  @(negedge clk_tb);
  wr_data_tb = 4'b0111;//7
  @(negedge clk_tb);
  wr_data_tb = 4'b1001;//9
  @(negedge clk_tb);
  wr_data_tb = 4'b0000;//0
  @(negedge clk_tb);
  wr_tb = 1'b0;
  rd_tb = 1'b1;
  repeat (6) @(negedge clk_tb);
  wr_tb = 1'b1;
  rd_tb = 1'b0;
  repeat (2) @(negedge clk_tb);
  wr_data_tb = 4'b0010; //2
  @(negedge clk_tb);
  wr_data_tb = 4'b0100; //4
  @(negedge clk_tb);
  wr_tb = 1'b0;
  rd_tb = 1'b1;
  repeat (5) @(negedge clk_tb);
  $stop;
end

endmodule
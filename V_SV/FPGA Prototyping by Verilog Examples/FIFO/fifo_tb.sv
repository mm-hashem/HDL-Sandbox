`timescale 1ns/10ps
module fifo_tb();

localparam T = 20,
           ADRS_BITS_tb = 2,
           WORD_BITS_tb = 4;

logic clk_tb, rst_tb,
      push_tb, pop_tb,
      empty_tb, full_tb;

logic [WORD_BITS_tb-1:0] push_data_tb,
                         pop_data_tb;      

fifo #(.ADRS_BITS(ADRS_BITS_tb), .WORD_BITS(WORD_BITS_tb)) uut(.clk(clk_tb), .rst(rst_tb), .push(push_tb), .pop(pop_tb), .push_data(push_data_tb), .pop_data(pop_data_tb), .empty(empty_tb), .full(full_tb));

always
begin
  clk_tb = 1'b1; #(T/2);
  clk_tb = 1'b0; #(T/2);
end

initial
begin
  rst_tb = 1'b1;
  push_tb = 1'b0;
  pop_tb = 1'b0;
  push_data_tb = 4'b0000;
  @(negedge clk_tb);
  rst_tb = 1'b0;
  push_tb = 1'b1;
  @(negedge clk_tb);
  push_data_tb = 4'b0001;//1
  @(negedge clk_tb);
  push_data_tb = 4'b0011;//3
  @(negedge clk_tb);
  push_data_tb = 4'b0101;//5
  @(negedge clk_tb);
  push_data_tb = 4'b0111;//7
  @(negedge clk_tb);
  push_data_tb = 4'b1001;//9
  @(negedge clk_tb);
  push_data_tb = 4'b0000;//0
  @(negedge clk_tb);
  push_tb = 1'b0;
  pop_tb = 1'b1;
  repeat (6) @(negedge clk_tb);
  push_tb = 1'b1;
  pop_tb = 1'b0;
  repeat (2) @(negedge clk_tb);
  push_data_tb = 4'b0010; //2
  @(negedge clk_tb);
  push_data_tb = 4'b0100; //4
  @(negedge clk_tb);
  push_tb = 1'b0;
  pop_tb = 1'b1;
  repeat (5) @(negedge clk_tb);
  $stop;
end

endmodule
`timescale 1ns/10ps
module uart_tb();

localparam T_tb = 20,
           rx_T_tb = 52083,
           DATA_BITS_tb = 8,
           STOP_TICKS_tb = 16,
           FRQ_DVSR_tb = 163,
           FRQ_DVSR_BITS_tb = 8,
           FIFO_DEPTH_tb = 2;

logic clk_tb, rst_tb,
      rx_tb,
      rd_tb, wr_tb,
      fifo_rx_full_tb, fifo_rx_empty_tb,
      fifo_tx_full_tb, fifo_tx_empty_tb,
      tx_tb;

logic [7:0] rx_data_tb, tx_data_tb;

logic bit_clk_tb;

uart #(
  .DATA_BITS(DATA_BITS_tb),
  .STOP_TICKS(STOP_TICKS_tb),
  .FRQ_DVSR(FRQ_DVSR_tb),
  .FRQ_DVSR_BITS(FRQ_DVSR_BITS_tb),
  .FIFO_DEPTH(FIFO_DEPTH_tb)
  )
  uut(
    .clk(clk_tb),
    .rst(rst_tb),
    .rx(rx_tb),
    .rd(rd_tb),
    .wr(wr_tb),
    .tx_data(tx_data_tb),
    .rx_data(rx_data_tb),
    .fifo_rx_full(fifo_rx_full_tb),
    .fifo_rx_empty(fifo_rx_empty_tb),
    .fifo_tx_full(fifo_tx_full_tb),
    .fifo_tx_empty(fifo_tx_empty_tb),
    .tx(tx_tb)
  );

always
begin
  clk_tb = 1'b1; #(T_tb/2);
  clk_tb = 1'b0; #(T_tb/2);
end

always
begin
  bit_clk_tb = 1'b1; #(rx_T_tb/2);
  bit_clk_tb = 1'b0; #(rx_T_tb/2);
end

initial
begin
  rx_tb = 1'b1;
  rst_tb = 1'b1;
  rd_tb = 1'b0;
  wr_tb = 1'b0;
  tx_data_tb = 8'b00000000;
  @(negedge clk_tb);
  rst_tb = 1'b0;
  wr_tb = 1'b1;
  tx_data_tb = 8'b01010101;
  @(negedge clk_tb);
  wr_tb = 1'b0;
  @(negedge clk_tb);
  @(negedge clk_tb);
  repeat(25) @(negedge bit_clk_tb);

  tx_data_tb = 8'b11110000;
  wr_tb = 1'b1;
  @(negedge clk_tb);
  wr_tb = 1'b0;
  @(negedge clk_tb);
  repeat(25) @(negedge bit_clk_tb);

  /*@(negedge clk_tb);
  rst_tb = 1'b0;
  @(negedge clk_tb);

  uart_byte_in(8'b11111111);

  @(negedge clk_tb);
  rd_tb = 1'b1;
  @(negedge clk_tb);
  rd_tb = 1'b0;
  @(negedge clk_tb);

  uart_byte_in(8'b00000000);

  @(negedge clk_tb);
  rd_tb = 1'b1;
  @(negedge clk_tb);
  rd_tb = 1'b0;
  @(negedge clk_tb);

  uart_byte_in(8'b11110000);

  @(negedge clk_tb);
  rd_tb = 1'b1;
  @(negedge clk_tb);
  rd_tb = 1'b0;
  @(negedge clk_tb);

  uart_byte_in(8'b00001111);

  @(negedge clk_tb);
  rd_tb = 1'b1;
  @(negedge clk_tb);
  rd_tb = 1'b0;
  @(negedge clk_tb);

  uart_byte_in(8'b10101010);

  @(negedge clk_tb);
  rd_tb = 1'b1;
  @(negedge clk_tb);
  rd_tb = 1'b0;
  @(negedge clk_tb);*/

  $stop;
end

task automatic uart_byte_in;
  input logic [7:0] data_in;
  begin
    integer i = 0;
    @(negedge bit_clk_tb)
    rx_tb = 0;
    @(negedge bit_clk_tb)
    while (i <= 7)
    begin
      rx_tb = data_in[i];
      @(negedge bit_clk_tb)
      i++;
    end
    rx_tb = 1;
    @(negedge bit_clk_tb);
  end
endtask

endmodule
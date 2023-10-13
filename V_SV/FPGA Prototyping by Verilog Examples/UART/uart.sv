module uart
#(
  parameter DATA_BITS = 8,
            STOP_TICKS = 16,
            FRQ_DVSR = 163,
            FRQ_DVSR_BITS = 8,
            FIFO_DEPTH = 2
)
(
  input  logic       clk, rst,
                     rx, 
                     rd, wr,
  input  logic [7:0] tx_data,
  output logic [7:0] rx_data,
  output logic       fifo_rx_full, fifo_rx_empty,
                     fifo_tx_full, fifo_tx_empty,
                     tx
);

logic tick, rx_done, tx_done, tx_fifo_start, fifo_tx_empty_wire;
logic [7:0] rx_data_fifo, tx_data_fifo;

assign tx_fifo_start = ~fifo_tx_empty_wire;
assign fifo_tx_empty = fifo_tx_empty_wire;

baud_rt_gen #(
  .N(FRQ_DVSR),
  .N_BITS(FRQ_DVSR_BITS)
  )
  baud_rt_gen_unit (
    .clk(clk),
    .rst(rst),
    .max_tick(tick)
  );

uart_rx #(
  .DATA_BITS(DATA_BITS),
  .STOP_TICKS(STOP_TICKS)
  )
  uart_rx_unit (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .tick(tick),
    .rx_done(rx_done),
    .dout(rx_data_fifo)
  );

fifo #(
  .DEPTH(FIFO_DEPTH),
  .WIDTH(DATA_BITS)
  )
  fifo_rx (
    .clk(clk),
    .rst(rst),
    .wr(rx_done),
    .rd(rd),
    .wr_data(rx_data_fifo),
    .rd_data(rx_data),
    .empty(fifo_rx_empty),
    .full(fifo_rx_full)
  );

uart_tx #(
  .DATA_BITS(DATA_BITS),
  .STOP_TICKS(STOP_TICKS)
  )
  uart_tx_unit (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_fifo_start),
    .tick(tick),
    .tx_data(tx_data_fifo),
    .tx_done(tx_done),
    .tx_line(tx)
  );

fifo #(
.DEPTH(FIFO_DEPTH),
.WIDTH(DATA_BITS)
)
  fifo_tx (
    .clk(clk),
    .rst(rst),
    .wr(wr),
    .rd(tx_done),
    .wr_data(tx_data),
    .rd_data(tx_data_fifo),
    .empty(fifo_tx_empty_wire),
    .full(fifo_tx_full)
  );

endmodule
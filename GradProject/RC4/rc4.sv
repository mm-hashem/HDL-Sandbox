module rc4 (
  input logic clk,
              wr, rd,
  input logic [7:0] raw_data,
  output logic [7:0] enc_data,
  output logic enc_done
);

  logic ksa_done, byte_done, empty;
  logic [7:0] cipherkey,
              rd_data;
  wire S_swap;
  wire [7:0] S_addr_a, S_addr_b, S_addr_c,
             S_data_a, S_data_b, S_data_c;

  assign enc_done = byte_done;

  assign enc_data = byte_done ? rd_data ^ cipherkey : 0;

  fifo fifo_unit (
    .clk(clk),
    .wr_fifo(wr), .rd_fifo(rd),
    .wr_data(raw_data), .rd_data(rd_data),
    .empty(empty), .full()
  );

  ksa ksa_unit (
    .clk(clk),
    .key_vld(~empty),
    .S_data(S_data_a),
    .S_addr_a(S_addr_a), .S_addr_b(S_addr_b),
    .S_swap(S_swap),
    .ksa_done(ksa_done)
  );

  sarr_mem sarr_mem_unit (
    .clk(clk),
    .S_swap(S_swap),
    .S_addr_a(S_addr_a), .S_addr_b(S_addr_b), .S_addr_c(S_addr_c),
    .S_data_a(S_data_a), .S_data_b(S_data_b), .S_data_c(S_data_c)
  );

  prng prng_unit (
    .clk(clk),
    .key_gen(ksa_done),
    .S_data_a(S_data_a), .S_data_b(S_data_b), .S_data_c(S_data_c),
    .S_addr_a(S_addr_a), .S_addr_b(S_addr_b), .S_addr_c(S_addr_c),
    .S_swap(S_swap),
    .cipherkey(cipherkey),
    .byte_done(byte_done)
  );

endmodule
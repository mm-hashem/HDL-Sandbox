`timescale 1ns/1ps
module rc4_tb();
  bit _clk;
  logic _wr, _rd, _empty, _byte_done, _ksa_done;
  logic [7:0] _raw_data, _rd_data, _enc_data, _cipherkey;
  wire [7:0] _S_data_a, _S_data_b, _S_data_c,
             _S_addr_a_ksa, _S_addr_b_ksa,
             _S_addr_a_prng, _S_addr_b_prng, _S_addr_c_prng;
  wire _S_swap_ksa, _S_swap_prng;

  always #3 _clk = ~_clk; //41

  /*
    input clk, wr, raw_data, rd,
    output enc_data
  */

  fifo fifo_raw_unit (
    .clk(_clk),
    .wr_fifo(_wr), .rd_fifo(_byte_done),
    .wr_data(_raw_data), .rd_data(_rd_data),
    .empty(_empty), .full()
  );

  fifo fifo_enc_unit (
    .clk(_clk),
    .wr_fifo(_byte_done), .rd_fifo(_rd),
    .wr_data(_rd_data ^ _cipherkey), .rd_data(_enc_data),
    .empty(), .full()
  );

  ksa ksa_unit (
    .clk(_clk),
    .key_vld(~_empty),
    .S_data(_S_data_a),
    .S_addr_a(_S_addr_a_ksa), .S_addr_b(_S_addr_b_ksa),
    .S_swap(_S_swap_ksa),
    .ksa_done(_ksa_done)
  );

  sarr_mem sarr_mem_unit (
    .clk(_clk),
    .S_swap(_S_swap_prng | _S_swap_ksa),
    .S_addr_a(_S_addr_a_ksa | _S_addr_a_prng), .S_addr_b(_S_addr_b_ksa | _S_addr_b_prng), .S_addr_c(_S_addr_c_prng),
    .S_data_a(_S_data_a), .S_data_b(_S_data_b), .S_data_c(_S_data_c)
  );

  prng prng_unit (
    .clk(_clk),
    .key_gen(_ksa_done & (~_empty)),
    .S_data_a(_S_data_a), .S_data_b(_S_data_b), .S_data_c(_S_data_c),
    .S_addr_a(_S_addr_a_prng), .S_addr_b(_S_addr_b_prng), .S_addr_c(_S_addr_c_prng),
    .S_swap(_S_swap_prng),
    .cipherkey(_cipherkey),
    .byte_done(_byte_done)
  );

  initial
  begin
    _wr = 0; _rd = 0; _raw_data = 0;
    repeat(10) @(negedge _clk);
    _wr = 1;
    @(negedge _clk);
    _raw_data = 8'hAA;
    @(negedge _clk);
    _raw_data = 8'hBB;
    @(negedge _clk);
    _raw_data = 8'hCC;
    @(negedge _clk);
    _raw_data = 8'hDD;
    @(negedge _clk);
    _wr = 0;
    wait(_byte_done == 1);
    repeat(10) @(negedge _clk);
    _rd = 1;
    repeat(10) @(negedge _clk);
    _rd = 0;
    repeat(20) @(negedge _clk);
    $stop;
  end

endmodule
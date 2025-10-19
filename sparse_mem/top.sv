`timescale 1ns/10ps

import spmem_pkj::*;

module top;
  bit clk_i, rst_ni;
  always #10 clk_i = ~clk_i;

  spmem_f spmem_fu (clk_i);
  sparse_memory spmem_u (spmem_fu, clk_i, rst_ni);
  test test_u (spmem_fu, clk_i, rst_ni);
  //monitor monitor_u (spmem_fu);
endmodule
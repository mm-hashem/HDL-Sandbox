import spmem_pkj::*;
interface spmem_f(input logic clk_i);

  logic cs_ni;

  // Enabling interface
  rwop_e we_i, re_i;

  // Address interface
  addr_t write_address_i, read_address_i;

  // Data interface
  data_t write_data_i, read_data_o;

  clocking tcb @(posedge clk_i);
    input read_data_o;
    output cs_ni,
           we_i, re_i,
           write_address_i, write_data_i,
           read_address_i;
  endclocking

  clocking mcb @(posedge clk_i);
    input re_i, read_address_i, read_data_o,
          we_i, write_address_i, write_data_i; 
  endclocking

  modport spmem_ports (input  cs_ni,
                              we_i, re_i,
                              write_address_i, write_data_i,
                              read_address_i,
                       output read_data_o);

  modport test_ports (clocking tcb);

  modport monitor_ports (clocking mcb);
endinterface
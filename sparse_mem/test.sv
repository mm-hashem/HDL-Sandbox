import spmem_pkj::*;
`define NUM_PACKETS 50
`define NUM_UNINIT 10

class packet_t;
  rwop_e opcode;
  addr_t addr;
  data_t data;
  byte delay;

  function new;
    opcode = rwop_e'($urandom_range(2 + (DataWidth > 32)));
    addr   = $urandom;
    // needs better implementation using bitwise operations
    data   = {$urandom_range(2**(2**(opcode + 1) * 4) - 1) * (opcode == OP_DWORD), $urandom_range(2**(2**(opcode + 1) * 4) - 1)};
    delay  = (2**opcode) - 1;
  endfunction
endclass

module test (
  spmem_f.test_ports spm,
  input  bit clk_i,
  output bit rst_ni
);

  packet_t packet_q[$], pkt_temp;
  string current_op;

  initial begin
    rst_ni                  <= 0;       spm.tcb.cs_ni        <= 1;
    spm.tcb.re_i            <= OP_BYTE; spm.tcb.we_i         <= OP_BYTE;
    spm.tcb.write_address_i <= 0;       spm.tcb.write_data_i <= 0;
    spm.tcb.read_address_i  <= 0;
    repeat(3) @(spm.tcb);
    rst_ni <= 1;
    repeat(3) @(spm.tcb);

    pkt_temp = new;

    // WRITING OPERATIONS
    current_op = "WRITE";
    $display("START OF WRITING OPERATIONS\n");
    for (int i = 0; i < `NUM_PACKETS; i++) begin
      // Generating stimuli
      pkt_temp = new;
      packet_q.push_front(pkt_temp);
      write_task(pkt_temp); // Driving inputs
      repeat($urandom_range(10)) @(spm.tcb); // random delay
    end

    repeat($urandom_range(10)) @(spm.tcb);

    // READING OPERATIONS
    current_op = "READ";
    $display("START OF READING OPERATIONS\n");
    while(packet_q.size != 0) begin
      pkt_temp = packet_q.pop_front();
      //if (pkt_temp.opcode == OP_WORD) pkt_temp.opcode = rwop_e'($urandom_range(2));
      //else if (pkt_temp.opcode == OP_HALF) pkt_temp.opcode = rwop_e'($urandom_range(1));
      fork
        read_task(pkt_temp);
        read_check(pkt_temp);
      join
      repeat($urandom_range(10)) @(spm.tcb); // random delay
    end

    repeat($urandom_range(10)) @(spm.tcb);

    // reading uninitalized memory
    current_op = "READ UNINIT";
    $display("START OF READING UNINITALIZED MEMORY OPERATIONS\n");
    for (int i = 0; i < `NUM_UNINIT; i++) begin
      pkt_temp = new;
      fork
        read_task(pkt_temp);
        read_check(pkt_temp);
      join
      repeat($urandom_range(10)) @(spm.tcb); // random delay
    end
    $stop;
  end

  task automatic read_task(packet_t packet);
    $display("SPARSE MEM\t\tOP: READ\t\tOP_TYPE: %s\t\tADDR: %h\t\tDATA: %h", packet.opcode.name(), packet.addr, packet.data);
    @(spm.tcb);

    // Driving inputs
    spm.tcb.cs_ni <= 0;
    spm.tcb.re_i <= packet.opcode;
    spm.tcb.read_address_i <= packet.addr;

    // Waiting for the sparse memory to register the data
    repeat(2 + packet.delay) @(spm.tcb);

    // Stopping the operation
    spm.tcb.cs_ni <= 1;
    spm.tcb.read_address_i <= 0;
  endtask

  task automatic read_check(packet_t packet);
    repeat(4) @(spm.tcb);
    for (byte i = 0; i < packet.delay + 1; i++) begin
      assert(spm.tcb.read_data_o == packet.data[7:0]) $display("Consistent data - read: %h = %h :expected at byte %0d", spm.tcb.read_data_o, packet.data[7:0], i);
      else $error("Inconsistent data - read: %h != %h :expected at byte %0d", spm.tcb.read_data_o, packet.data[7:0], i);
      packet.data = packet.data >> 8;
      @(spm.tcb);
    end
    $display;
  endtask

  task automatic write_task(packet_t packet);
    $display("SPARSE MEM\t\tOP: WRITE\t\tOP_TYPE: %s\t\tADDR: %h\t\tDATA: %h", packet.opcode.name(), packet.addr, packet.data);
    @(spm.tcb);
    spm.tcb.cs_ni <= 0;
    spm.tcb.we_i <= packet.opcode;
    spm.tcb.write_address_i <= packet.addr;
    spm.tcb.write_data_i <= packet.data;
    repeat(1 + packet.delay) @(spm.tcb);
    
    spm.tcb.cs_ni <= 1;
    spm.tcb.write_address_i <= 0;
  endtask

endmodule
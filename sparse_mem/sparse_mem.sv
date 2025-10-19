import spmem_pkj::*;
module sparse_memory (
  spmem_f.spmem_ports spm,
  input bit clk_i, rst_ni
);

  data_t sparse_memory[addr_t];

  typedef enum logic [3:0] {
    ST_RST,
    ST_BYTE,
    ST_HALF,
    ST_WORD0,
    ST_WORD1,
    ST_DOWRD0,
    ST_DOWRD1,
    ST_DOWRD2,
    ST_DOWRD3
  } state_e;

  state_e r_state_current, r_state_next,
          w_state_current, w_state_next;

  data_t read_data_o_reg, read_data_o_wire;
  addr_t write_address_i_reg;

    ///////////////////////////////
   // FSM Registers transitions //
  ///////////////////////////////
  always_ff @(posedge clk_i or negedge rst_ni) begin
    unique if (!rst_ni) begin
      r_state_current <= ST_RST;
      w_state_current <= ST_RST;
    end else begin
      r_state_current <= r_state_next;
      w_state_current <= w_state_next;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    unique if (!rst_ni) begin
      sparse_memory.delete();
      read_data_o_reg <= 0;
      write_address_i_reg <= 0;
    end else begin
      unique if (!spm.cs_ni) begin
        unique if (sparse_memory.exists(spm.read_address_i)) read_data_o_reg <= read_data_o_wire;
        else                                                 read_data_o_reg <= 0;
        write_address_i_reg <= spm.write_address_i;
      end else begin
        read_data_o_reg     <= 0;
        write_address_i_reg <= 0;
      end
    end
  end

    ///////////////////////
   // FSM Control Logic //
  ///////////////////////

  // begin: reading control state logic
  always_comb begin
    unique case(r_state_current)
      ST_RST: begin
        if (!spm.cs_ni) r_state_next = ST_BYTE;
        else r_state_next = ST_RST;
      end
      ST_BYTE: begin
        if (spm.re_i == OP_BYTE) r_state_next = ST_RST;
        else                     r_state_next = ST_HALF;
      end
      ST_HALF: begin
        if (spm.re_i == OP_HALF) r_state_next = ST_RST;
        else                     r_state_next = ST_WORD0;
      end
      ST_WORD0: r_state_next = ST_WORD1;
      ST_WORD1: begin
        if (spm.re_i == OP_WORD) r_state_next = ST_RST;
        else r_state_next = ST_DOWRD0;
      end
      ST_DOWRD0: r_state_next = ST_DOWRD1;
      ST_DOWRD1: r_state_next = ST_DOWRD2;
      ST_DOWRD2: r_state_next = ST_DOWRD3;
      ST_DOWRD3: r_state_next = ST_RST;
    endcase
  end
  // end: reading control state logic

  // begin: writing control state logic
  always_comb begin
    unique case(w_state_current)
      ST_RST: begin
        if (!spm.cs_ni) w_state_next = ST_BYTE;
        else w_state_next = ST_RST;
      end
      ST_BYTE: begin
        if (spm.we_i == OP_BYTE) w_state_next = ST_RST;
        else                     w_state_next = ST_HALF;
      end
      ST_HALF: begin
        if (spm.we_i == OP_HALF) w_state_next = ST_RST;
        else                     w_state_next = ST_WORD0;
      end
      ST_WORD0: w_state_next = ST_WORD1;
      ST_WORD1: begin
        if (spm.we_i == OP_WORD) w_state_next = ST_RST;
        else w_state_next = ST_DOWRD0;
      end
      ST_DOWRD0: w_state_next = ST_DOWRD1;
      ST_DOWRD1: w_state_next = ST_DOWRD2;
      ST_DOWRD2: w_state_next = ST_DOWRD3;
      ST_DOWRD3: w_state_next = ST_RST;
    endcase
  end
  // end: writing control state logic

    ////////////////////////////////
   // Reading/Writing Operations //
  ////////////////////////////////

  // begin: reading operations
  always_comb begin
    unique case(r_state_current)
      ST_RST   : read_data_o_wire = 0;
      ST_BYTE  : read_data_o_wire = sparse_memory[spm.read_address_i][7:0];
      ST_HALF  : read_data_o_wire = sparse_memory[spm.read_address_i][15:8];
      ST_WORD0 : read_data_o_wire = sparse_memory[spm.read_address_i][23:16];
      ST_WORD1 : read_data_o_wire = sparse_memory[spm.read_address_i][31:24];
      ST_DOWRD0: read_data_o_wire = sparse_memory[spm.read_address_i][39:32];
      ST_DOWRD1: read_data_o_wire = sparse_memory[spm.read_address_i][47:40];
      ST_DOWRD2: read_data_o_wire = sparse_memory[spm.read_address_i][55:48];
      ST_DOWRD3: read_data_o_wire = sparse_memory[spm.read_address_i][63:56];
    endcase
  end
  // end: reading operations

  // begin: writing operations
  always_comb begin
    sparse_memory[0] = 0;
    unique case(w_state_current)
      ST_RST   : sparse_memory[write_address_i_reg]        = 0;
      ST_BYTE  : sparse_memory[write_address_i_reg]        = {{24{1'b0}}, spm.write_data_i[7:0]};
      ST_HALF  : sparse_memory[write_address_i_reg][15:8]  =              spm.write_data_i[15:8];
      ST_WORD0 : sparse_memory[write_address_i_reg][23:16] =              spm.write_data_i[23:16];
      ST_WORD1 : sparse_memory[write_address_i_reg][31:24] =              spm.write_data_i[31:24];
      ST_DOWRD0: sparse_memory[write_address_i_reg][39:32] =              spm.write_data_i[39:32];
      ST_DOWRD1: sparse_memory[write_address_i_reg][47:40] =              spm.write_data_i[47:40];
      ST_DOWRD2: sparse_memory[write_address_i_reg][55:48] =              spm.write_data_i[55:48];
      ST_DOWRD3: sparse_memory[write_address_i_reg][63:56] =              spm.write_data_i[63:56];
    endcase
  end
  // end: writing operations

  assign spm.read_data_o = read_data_o_reg;
    
endmodule

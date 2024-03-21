module fifo (_ifc_.FIFO ifc);

  localparam idle_s = 2'b00,
             wr_s   = 2'b01,
             rd_s   = 2'b10;
            
  logic [1:0] next_state, current_state;

  logic [ifc.FIFO_DEPTH:0] current_rd_ptr, next_rd_ptr,
                           current_wr_ptr, next_wr_ptr;

  logic current_full, next_full,
        current_empty, next_empty;

  logic [7:0] regfile [ifc.REG_DEPTH:0];

  initial
  begin
    current_state   = idle_s;
    current_rd_ptr  = 0;
    current_wr_ptr  = 0;
    current_full    = 0;
    current_empty   = 1;
  end

  always @(posedge ifc.clk)
  begin
    current_state   <= next_state;
    current_rd_ptr  <= next_rd_ptr;
    current_wr_ptr  <= next_wr_ptr;
    current_empty   <= next_empty;
    current_full    <= next_full;
  end

  always @(posedge ifc.clk)
    if (ifc.wr_fifo && (current_state == wr_s) && !current_full)
      regfile[current_wr_ptr[ifc.FIFO_DEPTH-1:0]] <= ifc.wr_data;

  always @*
  begin
    next_wr_ptr = current_wr_ptr;
    next_rd_ptr = current_rd_ptr;
    next_full   = ((current_wr_ptr[ifc.FIFO_DEPTH-1:0] == current_rd_ptr[ifc.FIFO_DEPTH-1:0]) && (current_wr_ptr[ifc.FIFO_DEPTH] != current_rd_ptr[ifc.FIFO_DEPTH])) ? 1'b1 : 1'b0;
    next_empty  = (current_wr_ptr == current_rd_ptr) ? 1'b1 : 1'b0;
    case(current_state)
      idle_s:
      begin
        if (ifc.wr_fifo)
          next_state = wr_s;
        else if (ifc.rd_fifo)
          next_state = rd_s;
        else
          next_state = idle_s;
      end
      wr_s:
      begin
        if (!current_full && ifc.wr_fifo)
          next_wr_ptr = current_wr_ptr + 1'b1;
        else
          next_wr_ptr = current_wr_ptr;

        if (ifc.wr_fifo)
          next_state = wr_s;
        else if (ifc.rd_fifo)
          next_state = rd_s;
        else
          next_state = idle_s;
      end
      rd_s:
      begin
        if (!current_empty && ifc.rd_fifo)
          next_rd_ptr = current_rd_ptr + 1'b1;
        else
          next_rd_ptr = current_rd_ptr;

        if (ifc.wr_fifo)
          next_state = wr_s;
        else if (ifc.rd_fifo)
          next_state = rd_s;
        else
          next_state = idle_s;
      end
      default: next_state = idle_s;
    endcase
  end

  always @*
  begin
    if (ifc.rd_fifo && (current_state == rd_s) && !current_empty)
      ifc.rd_data = regfile[current_rd_ptr[ifc.FIFO_DEPTH-1:0]];
    else
      ifc.rd_data = 0;
  end

  assign ifc.full = current_full;
  assign ifc.empty = current_empty;

endmodule

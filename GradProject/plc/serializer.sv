module serializer (_ifc_.serializer ifc);

  logic [1:0] current_state, next_state;
  logic [7:0] current_data, next_data;
  logic [2:0] current_bit, next_bit;
  logic       current_done, next_done,
              current_start, next_start;

  parameter [1:0] idle_s = 0,
                  data_s = 1,
                  ser_s  = 2;

  initial
  begin
    current_data = 0;
    current_state = idle_s;
    current_bit = 0;
    current_done = 0;
    current_start = 0;
  end

  always @(posedge ifc.clk)
  begin
    current_data <= next_data;
    current_state <= next_state;
    current_bit <= next_bit;
    current_done <= next_done;
    current_start <= next_start;
  end

  always @*
  begin
    next_bit = current_bit;
    next_done = current_done;
    next_start = current_start;
    
    case(current_state)
      idle_s:
      begin
        ifc.rd_fifo = 1'b0;
        next_done = 0;
        next_bit = 0;
        if (ifc.empty == 0)
        begin
          next_state = data_s;
          ifc.rd_fifo = 1'b1;
          
        end
        else
          next_state = idle_s;
      end
      data_s:
      begin
        ifc.rd_fifo = 1'b1;
        next_data = ifc.rd_data;
        next_state = ser_s;
        next_start = 1;
      end
      ser_s:
      begin
        next_start = 0;
        ifc.rd_fifo = 1'b0;
        next_data = current_data >> 1;
        if (current_bit == 7)
        begin
          next_state = idle_s;
          next_done = 1;
        end
        else
          next_bit = current_bit + 1;
      end
      default: next_state = idle_s;
    endcase
  end

  assign ifc.piso_start = current_start;
  assign ifc.piso_done = current_done;
  assign ifc.ser_out = current_data[0];
endmodule
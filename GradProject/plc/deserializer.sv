module deserializer (_ifc_.deserializer ifc);

  logic current_state, next_state;
  logic [7:0] current_data, next_data;
  logic [2:0] current_bit, next_bit;

  initial
  begin
    current_state = 0;
    current_data = 0;
    current_bit = 0;
  end

  always @(posedge ifc.clk)
  begin
    current_state <= next_state;
    current_data <= next_data;
    current_bit <= next_bit;
  end

  always @*
  begin
    next_data = current_data;
    next_bit = current_bit;
    case(current_state)
      1'b0:
      begin
        //next_bit = 0;
        if (ifc.piso_start)
          next_state = 1'b1;
        else
          next_state = 1'b0;
      end
      1'b1:
      begin
        next_data = {ifc.ser_out, current_data[7:1]};
        if (current_bit == 7)
        begin
          next_state = 1'b0;
          next_bit = 0;
        end
        else
        begin
          next_state = 1'b1;
          next_bit = current_bit + 1;
        end
      end
    endcase
  end

  assign ifc.prl_out = current_data;
endmodule
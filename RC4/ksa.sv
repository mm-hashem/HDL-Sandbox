module ksa (
  input logic clk, key_vld,
  input logic [7:0] S_data,
  
  output logic [7:0] S_addr_a, S_addr_b,
  output logic S_swap,
               ksa_done
);

  localparam [1:0] idle_s = 2'b00,
                   i_s = 2'b01,
                   perm_s = 2'b10,
                   stop_s = 2'b11;

  logic [7:0] key[8] = '{8'hAB, 8'hBC, 8'hCD, 8'hDE, 8'hEF, 8'hFE, 8'hED, 8'hDC};

  logic [7:0] current_i, next_i;
  logic [7:0] current_j, next_j;
  logic [1:0] current_state, next_state;
  logic current_S_swap, next_S_swap;

  initial begin
    current_state = idle_s;
    current_S_swap = 0;
    current_i = 0;
    current_j = 0;
  end

  always @(posedge clk) begin
    current_state <= next_state;
    current_S_swap <= next_S_swap;
    current_i <= next_i;
    current_j <= next_j;  
  end

  always @* begin
    next_i = current_i;
    next_j = current_j;
    next_S_swap = current_S_swap;
    ksa_done = 0;
    case(current_state)
      idle_s: begin
        next_i = 0;
        next_j = 0;
        next_state = key_vld ? perm_s : idle_s;
      end
      perm_s: begin
        next_j = (current_j + S_data + key[current_i & 8'h07]) & 8'hFF;
        next_S_swap = 1;
        next_state = i_s;
      end
      i_s: begin
        next_S_swap = 0;
        if (current_i != 9'h0FF) begin
          next_i = current_i + 1;
          next_state = perm_s;
        end else begin
          next_state = stop_s;
          ksa_done = 1;
        end
      end
      stop_s: begin
        ksa_done = 1;
        next_S_swap = 0;
        next_i = 0;
        next_j = 0;
      end
      default: next_state = idle_s;
    endcase
  end

  assign S_addr_a = current_i;
  assign S_addr_b = current_j;
  assign S_swap = current_S_swap;

endmodule
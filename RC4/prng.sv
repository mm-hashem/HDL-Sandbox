module prng (
  input logic clk, key_gen,
  input logic [7:0] S_data_a, S_data_b, S_data_c,

  output logic [7:0] S_addr_a, S_addr_b, S_addr_c,
                     cipherkey,
  output logic S_swap, byte_done
);

  localparam [2:0] idle_s = 3'b000,
                   i_s = 3'b001,
                   j_s = 3'b010,
                   t_s = 3'b011,
                   key_s = 3'b100,
                   bytedone_s = 3'b101;

  logic [8:0] current_i, next_i;
  logic [7:0] current_j, next_j;
  logic [7:0] current_key_idx, next_key_idx;
  logic [2:0] current_state, next_state;
  logic current_S_swap, next_S_swap;
  logic current_byte_done, next_byte_done;
  logic [7:0] current_cipherkey, next_cipherkey;

  initial begin
    current_state = idle_s;
    current_S_swap = 0;
    current_i = 0;
    current_j = 0;
    current_key_idx = 0;
    current_byte_done = 0;
    current_cipherkey = 0;
  end

  always @(posedge clk) begin
    current_state <= next_state;
    current_S_swap <= next_S_swap;
    current_i <= next_i;
    current_j <= next_j;
    current_key_idx <= next_key_idx;
    current_byte_done <= next_byte_done;
    current_cipherkey <= next_cipherkey;
  end

  always @* begin
    next_i = current_i;
    next_j = current_j;
    next_key_idx = current_key_idx;
    next_byte_done = current_byte_done;
    next_S_swap = current_S_swap;
    next_cipherkey = current_cipherkey;
    next_byte_done = 0;
    case(current_state)
      idle_s: begin
        next_i = 0;
        next_j = 0;
        next_state = key_gen ? i_s : idle_s;
      end
      i_s: begin
        if (current_i != 9'h0FF) begin
          next_i = current_i + 1;
          next_state = j_s;
        end else next_state = idle_s;
      end
      j_s: begin
        next_j = current_j + S_data_a;
        next_S_swap = 1;
        next_state = t_s;
      end
      t_s: begin
        next_S_swap = 0;
        next_key_idx = S_data_a + S_data_b;
        next_state = key_s;
      end
      key_s: begin
        next_cipherkey = S_data_c;
        next_state = bytedone_s;
        next_byte_done = 1;
      end
      bytedone_s: begin
        next_byte_done = 1;
        next_state = key_gen ? i_s : idle_s;
      end
      default: next_state = idle_s;
    endcase
  end

  assign S_addr_a = current_i;
  assign S_addr_b = current_j;
  assign S_addr_c = current_key_idx;
  assign S_swap = current_S_swap;
  assign cipherkey = current_cipherkey;
  assign byte_done = current_byte_done;

endmodule
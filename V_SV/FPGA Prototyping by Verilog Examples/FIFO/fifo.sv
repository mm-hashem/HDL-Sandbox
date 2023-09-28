module fifo
#(
  parameter ADRS_BITS = 2,
            WORD_BITS = 4
)
(
  input  logic                 clk, rst,
                               push, pop,
  input  logic [WORD_BITS-1:0] push_data,
  output logic [WORD_BITS-1:0] pop_data,
  output logic                 empty, full
);

localparam MAX_ADRS = ADRS_BITS**2-1,
           idle_s = 2'b00,
           push_s = 2'b01,
           pop_s  = 2'b10;
          
logic [1:0] next_state, current_state;

logic [ADRS_BITS-1:0] current_pop_ptr, next_pop_ptr,
                      current_push_ptr, next_push_ptr;

logic [WORD_BITS-1:0] regfile [MAX_ADRS:0];

always @(posedge clk)
  if (current_state == push_s)
    regfile[current_push_ptr] <= push_data;


always @(posedge clk)
begin
  if (rst)
  begin
    current_state <= idle_s;
    current_pop_ptr   <= 0;
    current_push_ptr   <= 0;
  end
  else
  begin
    current_state <= next_state;
    current_pop_ptr   <= next_pop_ptr;
    current_push_ptr   <= next_push_ptr;
  end
end

// next state logic
always @*
begin
  case(current_state)
    idle_s:
    begin
      next_push_ptr = current_push_ptr;
      next_pop_ptr = current_pop_ptr;
      next_state = push ? push_s : pop ? pop_s : idle_s;
    end
    push_s:
    begin
      next_push_ptr = (current_push_ptr == MAX_ADRS) ? current_push_ptr : current_push_ptr + 1;
      next_state = push ? push_s : pop ? pop_s : idle_s;
    end
    pop_s:
    begin
      next_pop_ptr = (current_pop_ptr == MAX_ADRS) ? current_pop_ptr : current_pop_ptr + 1;
      next_state = push ? push_s : pop ? pop_s : idle_s;
    end
    default: next_state = idle_s;
  endcase
end

// output logic
assign pop_data = (current_state == pop_s) ? regfile[current_pop_ptr] : 0;

assign full  = (current_push_ptr == MAX_ADRS) ? 1'b1 : 1'b0;
assign empty = ~full;

endmodule
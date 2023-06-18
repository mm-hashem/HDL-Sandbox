module stack
#(
  parameter ADDRESS_BITS = 2,
            WORD_BITS    = 4
)
(
  input  wire                 clk, rst,
  input  wire                 push, pop,
  input  wire [WORD_BITS-1:0] push_data,
  output wire [WORD_BITS-1:0] pop_data,
  output wire                 empty, full
);

localparam MAX_ADDRESS = ADDRESS_BITS**2-1;

reg [1:0] next_state;
reg [1:0] current_state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

reg [WORD_BITS-1:0]    regfile [MAX_ADDRESS:0];
reg [ADDRESS_BITS-1:0] push_ptr_current, pop_ptr_current,
                       push_ptr_next,    pop_ptr_next;

always @(posedge clk)
  if (current_state == S1)
    regfile[push_ptr_current] <= full ? regfile[push_ptr_current] : push_data;

// current state logic
always @(posedge clk)
begin
  if (rst)
  begin
    current_state    <= S0;
    push_ptr_current <= 0;
    pop_ptr_current  <= 0;
  end
  else
  begin
    current_state    <= next_state;
    push_ptr_current <= push_ptr_next;
    pop_ptr_current  <= pop_ptr_next;
  end
end

// next state logic
always @*
begin
  case(current_state)
    S0:
    begin
      pop_ptr_next  = pop_ptr_current;
      push_ptr_next = push_ptr_current;
      next_state    = push ? S1 : pop ? S2 : S0;
    end
    S1:
    begin
      pop_ptr_next  = (push_ptr_current == 0) ? pop_ptr_current : (pop_ptr_current == MAX_ADDRESS) ? pop_ptr_current : pop_ptr_current  + 1;
      push_ptr_next = (push_ptr_current == MAX_ADDRESS) ? push_ptr_current : push_ptr_current + 1;
      next_state    = push ? S1 : pop ? S2 : S0;
    end
    S2:
    begin
      pop_ptr_next  = (pop_ptr_current  == 0) ? pop_ptr_current  : pop_ptr_current  - 1;
      push_ptr_next = (push_ptr_current == 0) ? push_ptr_current : push_ptr_current - 1;
      next_state    = push ? S1 : pop ? S2 : S0;
    end
    default: next_state = S0;
  endcase
end

// output logic
assign pop_data = (current_state   == S2)          ? regfile[pop_ptr_current] : 0;
assign full     = (pop_ptr_current == MAX_ADDRESS) ? 1'b1                     : 1'b0;
assign empty    = (pop_ptr_current == MAX_ADDRESS) ? 1'b0                     : 1'b1;

endmodule

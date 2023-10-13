module fifo
#(
  parameter DEPTH = 2,
            WIDTH = 4
)
(
  input  logic             clk, rst,
                           wr, rd,
  input  logic [WIDTH-1:0] wr_data,
  output logic [WIDTH-1:0] rd_data,
  output logic             empty, full
);

localparam REG_DEPTH  = DEPTH**2-1,
           idle_state = 2'b00,
           wr_state   = 2'b01,
           rd_state   = 2'b10;
          
logic [1:0] next_state, current_state;

logic [DEPTH:0] current_rd_ptr, next_rd_ptr,
                current_wr_ptr, next_wr_ptr;

logic current_full,  next_full,
      current_empty, next_empty;

logic [WIDTH-1:0] regfile [REG_DEPTH:0];

always @(posedge clk)
  if (wr && !next_full)
    regfile[current_wr_ptr[1:0]] <= wr_data;

always @(posedge clk)
begin
  if (rst)
  begin
    current_state  <= idle_state;
    current_rd_ptr <= 0;
    current_wr_ptr <= 0;
    current_empty  <= 1;
    current_full   <= 0;
  end
  else
  begin
    current_state  <= next_state;
    current_rd_ptr <= next_rd_ptr;
    current_wr_ptr <= next_wr_ptr;
    current_empty  <= next_empty;
    current_full   <= next_full;
  end
end

// next state logic
always @*
begin
  next_wr_ptr = current_wr_ptr;
  next_rd_ptr = current_rd_ptr;
  next_full   = ((current_wr_ptr[1:0] == current_rd_ptr[1:0]) && (current_wr_ptr[2] != current_rd_ptr[2])) ? 1'b1 : 1'b0;
  next_empty  = (current_wr_ptr == current_rd_ptr) ? 1'b1 : 1'b0;

  case(current_state)
    idle_state: next_state = wr ? wr_state : rd ? rd_state : idle_state;
    wr_state:
    begin
      if (!next_full)
        next_wr_ptr = current_wr_ptr + 1;
      next_state = wr ? wr_state : rd ? rd_state : idle_state;
    end
    rd_state:
    begin
      if (!next_empty)
      begin
        next_rd_ptr = current_rd_ptr + 1;
        rd_data = regfile[current_rd_ptr[1:0]];
      end
      next_state = wr ? wr_state : rd ? rd_state : idle_state;
    end
    default: next_state = idle_state;
  endcase
end

assign full  = next_full;
assign empty = next_empty;

endmodule
module parking_lot_counter
#(
  parameter COUNTER_BITS = 8
)
(
  input wire                     clk, rst,
                                 a, b,
  output wire                    enter, exit,
  output wire [COUNTER_BITS-1:0] lot_count
);

localparam S00 = 3'b000, //0
           S01 = 3'b001, //1
           S10 = 3'b010, //2
           S11 = 3'b011, //3
           SCE = 3'b100, //4 -- Car entering the lot
           SCX = 3'b101, //5 -- Car exiting the lot
           SPD = 3'b110; //6 -- A pedestrian entering or exiting the lot

reg  [2:0]              current_state, next_state;
reg  [COUNTER_BITS-1:0] current_count, next_count;

always @(posedge clk)
begin
  if (rst)
  begin
    current_state <= S00;
    current_count <= 0;
  end
  else
  begin
    current_state <= next_state;
    current_count <= next_count;
  end
end

always @*
begin
  next_state = current_state;
  next_count = current_count;
  case(current_state) //00 10 11 01 00
    S00: next_state =  (a & !b) ? S10 : (!a &  b) ? S01                 : S00;
    S01: next_state = (!a & !b) ? SCE : ( a & !b) ? SPD : (a & b) ? S11 : S01;
    S10: next_state = (!a & !b) ? SCX : (!a &  b) ? SPD : (a & b) ? S11 : S10;
    S11: next_state =  (a & !b) ? S10 : (!a &  b) ? S01                 : S11;
    SCE:
    begin
      next_count = current_count + 1;
      next_state = S00;
    end
    SCX:
    begin
      next_count = current_count - 1;
      next_state = S00;
    end
    SPD: next_state = S00;
    default: next_state = S00;
  endcase
end

assign enter = (current_state == SCE) ? 1 : 0;
assign exit  = (current_state == SCX) ? 1 : 0;
assign lot_count = current_count;

endmodule

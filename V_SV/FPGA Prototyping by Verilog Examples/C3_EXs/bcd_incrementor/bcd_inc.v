module bcd_incrementor
(
  input  wire [11:0] bcd_in,
  input  wire        inc,
  output wire [11:0] bcd_out
);

wire carry_out_ntrmdt_1;
wire carry_out_ntrmdt_2;

sub_bcd_incrementor bcd_1 (.nibble_in(bcd_in[3:0]),  .carry_in(1'b1 & inc),         .nibble_out(bcd_out[3:0]),  .carry_out(carry_out_ntrmdt_1));
sub_bcd_incrementor bcd_2 (.nibble_in(bcd_in[7:4]),  .carry_in(carry_out_ntrmdt_1), .nibble_out(bcd_out[7:4]),  .carry_out(carry_out_ntrmdt_2));
sub_bcd_incrementor bcd_3 (.nibble_in(bcd_in[11:8]), .carry_in(carry_out_ntrmdt_2), .nibble_out(bcd_out[11:8]), .carry_out());

endmodule

module sub_bcd_incrementor
(
  input  wire [3:0] nibble_in,
  input  wire       carry_in,
  output reg [3:0] nibble_out,
  output reg       carry_out
);

always @* begin
  carry_out = 1'b0;
  nibble_out = nibble_in;
  if (carry_in) begin
    case(nibble_in)
        4'b0000 : nibble_out = 4'b0001;
        4'b0001 : nibble_out = 4'b0010;
        4'b0010 : nibble_out = 4'b0011;
        4'b0011 : nibble_out = 4'b0100;
        4'b0100 : nibble_out = 4'b0101;
        4'b0101 : nibble_out = 4'b0110;
        4'b0110 : nibble_out = 4'b0111;
        4'b0111 : nibble_out = 4'b1000;
        4'b1000 : nibble_out = 4'b1001;
        default : begin
          carry_out = 1'b1;
          nibble_out = 4'b0000;
        end
    endcase
  end
end

endmodule

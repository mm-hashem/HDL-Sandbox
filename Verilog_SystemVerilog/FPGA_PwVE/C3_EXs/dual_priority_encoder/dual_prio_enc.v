module dual_priority_encoder
(
  input  wire [11:0] req_d,
  output wire [3:0]  first,
  output wire [3:0]  second
);

wire [11:0] req_d_second;
assign req_d_second = {req_d[11:1], 1'b0};

priority_encoder pe_first  (.req(req_d),        .bin_code(first));
priority_encoder pe_second (.req(req_d_second), .bin_code(second));

endmodule

module priority_encoder
(
  input  wire [11:0] req,
  output reg  [3:0]  bin_code
);

always @*
begin
  casez(req)
    12'b????_????_???1 : bin_code = 4'b0001;
    12'b????_????_??10 : bin_code = 4'b0010;
    12'b????_????_?100 : bin_code = 4'b0011;
    12'b????_????_1000 : bin_code = 4'b0100;
    12'b????_???1_0000 : bin_code = 4'b0101;
    12'b????_??10_0000 : bin_code = 4'b0110;
    12'b????_?100_0000 : bin_code = 4'b0111;
    12'b????_1000_0000 : bin_code = 4'b1000;
    12'b???1_0000_0000 : bin_code = 4'b1001;
    12'b??10_0000_0000 : bin_code = 4'b1010;
    12'b?100_0000_0000 : bin_code = 4'b1011;
    12'b1000_0000_0000 : bin_code = 4'b1100;
    default            : bin_code = 4'b0000;
  endcase
end

endmodule

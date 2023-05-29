module multi_barrel_shifter
(
  input  wire [7:0] A_m,
  input  wire [2:0] SC_m,
  input  wire       dir,
  output wire [7:0] B_m
);

wire [7:0] A_m_rev;
wire [7:0] B_m_r;
wire [7:0] B_m_l;

assign A_m_rev = {A_m[0], A_m[1], A_m[2], A_m[3], A_m[4], A_m[5], A_m[6], A_m[7]};

barrel_shifter barrel_shifter_r (.A(A_m),     .SC(SC_m), .B(B_m_r));
barrel_shifter barrel_shifter_l (.A(A_m_rev), .SC(SC_m), .B(B_m_l));

assign B_m = dir ? B_m_r : {B_m_l[0], B_m_l[1], B_m_l[2], B_m_l[3], B_m_l[4], B_m_l[5], B_m_l[6], B_m_l[7]};

endmodule

module barrel_shifter
(
  input  wire [7:0] A,
  input  wire [2:0] SC,
  output wire [7:0] B
);

wire [7:0] S0, S1;

assign S0 = SC[0] ? {A [ 0 ], A[7:1]} : A;
assign S1 = SC[1] ? {S0[1:0], A[7:2]} : S0;
assign B =  SC[2] ? {S1[3:0], A[7:4]} : S1;

endmodule

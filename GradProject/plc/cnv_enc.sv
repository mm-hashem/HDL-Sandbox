`timescale 1ns/10ps
module cnv_enc
(
  input  logic clk,
  input  logic data_in,
  output logic out_0, out_1
);
logic q1, q2, q3;
initial
begin
  q1 = 0;
  q2 = 0;
  q3 = 0;
end
always @(posedge clk)
begin
  q1 <= data_in ^ (q2 ^ q3);
  q2 <= q1;
  q3 <= q2;
end

assign out_0 = data_in;
assign out_1 = (((q2 ^ q3) ^ data_in) ^ q1) ^ q3;
endmodule
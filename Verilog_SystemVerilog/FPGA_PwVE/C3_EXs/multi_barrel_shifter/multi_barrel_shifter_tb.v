`timescale 1ns/10ps

module multi_barrel_shifter_tb;

reg  [7:0] A_tb;
reg  [2:0] SC_tb;
reg        dir_tb;
wire [7:0] B_tb;

multi_barrel_shifter uut (.A_m(A_tb), .SC_m(SC_tb), .dir(dir_tb), .B_m(B_tb));

reg [8:0] i; 
reg [3:0] j;
reg [1:0] k;

initial begin
  for (i = 9'b0_0000_0000; i < 9'b0_1111_1111; i = i + 9'b0_0000_0001) begin
    for (j = 4'b0_000; j <= 4'b0_111; j = j + 4'b0_001) begin
      for (k = 2'b0_0; k <= 2'b0_1; k = k + 2'b0_1) begin
        A_tb = i[7:0];
        SC_tb = j[2:0];
        dir_tb = k[0];
        #5;
      end
    end
  end
  $finish;
end
endmodule

// THIS CODE NEEDS A RECHECK

`timescale 1ns/10ps
module bcd_incrementor_tb();

reg [11:0] bcd_in_tb;
reg        inc_tb;
wire [11:0] bcd_out_tb;

bcd_incrementor uut(.bcd_in(bcd_in_tb), .inc(inc_tb), .bcd_out(bcd_out_tb));

initial
begin
  bcd_in_tb = 12'b0010_0101_1001;
  inc_tb = 1;
  chk_rslt(12'b0010_0110_0000);
  #5;

  bcd_in_tb = 12'b1001_1001_1001;
  inc_tb = 1;
  chk_rslt(12'b0000_0000_0000);
  #5;
end

task chk_rslt(input [11:0] exp_bcd_out);
  if(exp_bcd_out !== bcd_out_tb)
    $display("Incorrect result");
endtask

endmodule

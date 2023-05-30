`timescale 1ns/10ps
module dual_priority_encoder_tb();

reg [11:0] req_tb;
wire [3:0]  first_tb;
wire [3:0]  second_tb;

dual_priority_encoder uut(.req_d(req_tb), .first(first_tb), .second(second_tb));

initial
begin
  req_tb = 12'b0000_0000_0000; chk_rslt(4'b0000, 4'b0000); #5;

  req_tb = 12'b0000_0000_0001; chk_rslt(4'b0001, 4'b0000); #5;

  req_tb = 12'b0000_0000_0011; chk_rslt(4'b0001, 4'b0010); #5;
end

task chk_rslt(input [3:0] exp_first, exp_second);
  if((exp_first !== first_tb) && (exp_second !== second_tb))
    $display("Incorrect result");
endtask

endmodule

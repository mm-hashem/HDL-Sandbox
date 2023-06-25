`timescale 1ns/10ps

class alu_inputs;
  rand bit [3:0] a_rand, b_rand;
  rand bit [3:0] opcode_rand;
  constraint opcode_range
  {
    if (opcode_rand == 8'h05)
      b_rand inside {[0:2]};
    else
      b_rand inside {[0:15]};
  }
endclass

module alu_tb();

reg  [3:0] a_tb, b_tb;
reg  [3:0] opcode_tb;
wire [7:0] _output_tb;

alu uut(.a(a_tb), .b(b_tb), .opcode(opcode_tb), ._output(_output_tb));

alu_inputs alu_rand;

integer i;

initial
begin
  alu_rand = new();
  for (i = 0; i < 50; i = i + 1)
  begin
    alu_rand.randomize();
    opcode_tb = alu_rand.opcode_rand;
    a_tb = alu_rand.a_rand;
    b_tb = alu_rand.b_rand;
    #5;
  end
  $stop;
end 

endmodule

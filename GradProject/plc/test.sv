module test (_ifc_.TEST ifc);
  initial
  begin
    ifc.wr_fifo = 1'b0;
    ifc.wr_data = 8'b0000_0000;
    @(negedge ifc.clk);
    ifc.wr_fifo = 1'b1;
    ifc.wr_data = 8'hFF;
    @(negedge ifc.clk);
    @(negedge ifc.clk);
    ifc.wr_data = 8'hAA;
    @(negedge ifc.clk);
    ifc.wr_fifo = 1'b0;
    repeat(50) @(negedge ifc.clk);
    $stop;
  end
endmodule
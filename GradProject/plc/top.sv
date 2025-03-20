`timescale 1ns/10ps
module top;
    bit clk;
    always #5 clk = ~clk; //5 for 100MHz
    logic scrm_out_tb;

    _ifc_ #(.FIFO_DEPTH(2)) ifc (clk);
    fifo fifo_u (ifc);
    serializer serializer_u (ifc);
    scrambler scrambler_u (.clk(ifc.clk), .scrm_in(ifc.ser_out), .start(ifc.piso_start), .scrm_out(scrm_out_tb));
    scrambler descrambler_u (.clk(ifc.clk), .scrm_in(scrm_out_tb), .start(ifc.piso_start));
    deserializer deserializer_u (ifc);
    test test_u (ifc);
endmodule
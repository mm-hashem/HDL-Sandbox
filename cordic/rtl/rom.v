module rom #(
    parameter DEPTH_BITS = 4,
              BIT_WIDTH = 32,
              FILE_NAME = "atan_lut.mem"
) (
    input  wire                        clk,
    input  wire       [DEPTH_BITS-1:0] addr,
    output reg signed [BIT_WIDTH-1:0]  data
);
    (* rom_style = "block" *) reg signed [BIT_WIDTH-1:0] rom [0:2**DEPTH_BITS-1];

    initial $readmemh(FILE_NAME, rom);

    always @(posedge clk) data <= rom[addr];

endmodule
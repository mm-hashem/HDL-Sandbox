module cordic_top #(
    parameter ITER_BITS = 4,
              Q1_14_BITS = 16,
              Q4_27_BITS = 32
) (
    input  wire                         clk, rst,
    input  wire signed [Q1_14_BITS-1:0] x_start, y_start, // Q1.14, x_start = 0.60725, y_start = 0
    input  wire signed [Q4_27_BITS-1:0] angle,            // Q4.27, Range: [-2pi, 4pi]
    output wire signed [Q1_14_BITS-1:0] cosine, sine,     // Q1.14, Range: [-1, 1]
    output wire                          valid_write, valid_read
);
    // Internal signals
    parameter ITEREATIONS = 2**ITER_BITS - 1;

    wire signed [Q4_27_BITS-1:0] atan_lut;
    reg [ITER_BITS-1:0] iter;
    reg start;

    // Instantiate cordic module
    cordic #(
        .ITER_BITS(ITER_BITS),
        .Q1_14_BITS(Q1_14_BITS),
        .Q4_27_BITS(Q4_27_BITS)
    ) cordic (
        .clk(clk), .rst(rst), .start(start),
        .iter(iter),
        .x_start(x_start), .y_start(y_start),
        .angle(angle),
        .atan_lut(atan_lut),
        .cosine(cosine), .sine(sine)
    );

    // atan LUT instantiation
    rom #(
        .DEPTH_BITS(ITER_BITS),
        .BIT_WIDTH(Q4_27_BITS),
        .FILE_NAME("atan_lut.mem")
    ) atan_lut_rom (
        .clk(clk),
        .addr(iter),
        .data(atan_lut)
    );

    always @(posedge clk) begin
        if (rst || (iter == ITEREATIONS)) begin
            iter <= 0;
            start <= 1'b0;
        end else begin
            iter <= iter + 1;
            start <= 1'b1;
        end
    end

    assign valid_read = (iter == ITEREATIONS) ? 1'b1 : 1'b0;
    assign valid_write = ~start;
    
endmodule
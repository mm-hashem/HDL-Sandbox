module cordic #(
    parameter ITER_BITS = 4,
              Q1_14_BITS = 16,
              Q4_27_BITS = 32
) (
    input  wire                         clk, rst, start,
    input  wire        [ITER_BITS-1:0]  iter,
    input  wire signed [Q1_14_BITS-1:0] x_start, y_start, // Q1.14, x_start = 0.60725, y_start = 0
    input  wire signed [Q4_27_BITS-1:0] angle, atan_lut,  // Q4.27, angle Range: [-2pi, 4pi], atan_lut: arctan(2^-i) values from LUT
    output wire signed [Q1_14_BITS-1:0] cosine, sine      // Q1.14, Range: [-1, 1]);
);
    // Internal signals and parameters

    parameter signed [Q4_27_BITS-1:0]
        _PIo2  = 32'sh0c90fdaa, // pi/2   in Q4.27
        _PI    = 32'sh1921fb54, // pi     in Q4.27
        _3PIo2 = 32'sh25b2f8fe, // 3*pi/2 in Q4.27
        _2PI   = 32'sh3243f6a8; // 2*pi   in Q4.27
    
    reg signed [Q4_27_BITS-1:0] angle_corrected_1, angle_corrected_2,
                                angle_acc_current, angle_acc_next;
    reg signed [Q1_14_BITS-1:0] x_cos_current, y_sin_current,
                                x_cos_next, y_sin_next;
    
    reg  sign_cos;
    wire direction;

    ////////////////////////////////////////////

    // Angles mapping logic
    always @* begin
        sign_cos = 1'b1;

        // Angles above 2pi and negative angles, wrapping to [-pi/2, 2pi]
        if (angle > _2PI) begin
            angle_corrected_1 = angle - _2PI;
        end else if (angle < -_PIo2) begin
            angle_corrected_1 = angle + _2PI;
        end else begin
            angle_corrected_1 = angle;
        end

        // Mapping angles to the I or IV quadrant, wrapping to [-pi/2, pi/2]
        if (angle_corrected_1 > _3PIo2) begin
            angle_corrected_2 = angle_corrected_1 - _2PI;
        end else if (angle_corrected_1 > _PIo2) begin
            angle_corrected_2 = _PI - angle_corrected_1;
            sign_cos = 1'b0;
        end else begin
            angle_corrected_2 = angle_corrected_1;
        end
    end

    /////////////////////////////////////////////

    always @(posedge clk) begin
        if (rst) begin
            x_cos_current     <= 32'sh0;
            y_sin_current     <= 32'sh0;
            angle_acc_current <= 32'sh0;
        end else begin
            x_cos_current     <= x_cos_next;
            y_sin_current     <= y_sin_next;
            angle_acc_current <= angle_acc_next;
        end
    end

    always @* begin
        case({start, direction})
            2'b00, 2'b01: begin
                angle_acc_next = angle_corrected_2;
                x_cos_next = x_start;
                y_sin_next = y_start;
            end
            2'b10: begin
                angle_acc_next = angle_acc_current + atan_lut;
                x_cos_next = x_cos_current + (y_sin_current >>> (iter - 1));
                y_sin_next = y_sin_current - (x_cos_current >>> (iter - 1));
            end
            2'b11: begin
                angle_acc_next = angle_acc_current - atan_lut;
                x_cos_next = x_cos_current - (y_sin_current >>> (iter - 1));
                y_sin_next = y_sin_current + (x_cos_current >>> (iter - 1));
            end
        endcase
    end

    assign direction = angle_acc_current[Q4_27_BITS-1] ? 1'b0 : 1'b1;
    
    assign cosine = sign_cos ? x_cos_current : -x_cos_current;
    assign sine   = y_sin_current;
    
endmodule
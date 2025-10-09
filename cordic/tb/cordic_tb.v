`timescale 1ns/1ns
`include "hex2real.v"
module cordic_tb();

    parameter T = 10,              // Clock period
              ITER_BITS = 4,       // CORDIC iterations
              Q1_14_BITS = 16,     // Q1.14 format (1 sign bit, 1 integer bit,  14 fractional bits)
              Q4_27_BITS = 32;     // Q4.27 format (1 sign bit, 4 integer bits, 27 fractional bits)

    parameter signed [Q1_14_BITS-1:0] COS_CONST = 16'sh26dd;

    reg  clk, rst;
    wire valid_read, valid_write;

    wire signed [Q1_14_BITS-1:0] cosine, sine; // Q1.14, Range: [-1, 1]
    reg signed [Q4_27_BITS-1:0] angle; // Q4.27, Range: [-2pi, 4pi]
    reg signed [Q1_14_BITS-1:0] x_start, y_start; // Q1.14, Range: [-1, 1]

    integer input_file, output_file, fscanf_ret;
    real angle_deg;
    reg signed [Q4_27_BITS-1:0] angle_matlab;
    reg signed [Q1_14_BITS-1:0] sin_matlab, cos_matlab;

    hex2real hex2real();

    cordic_top #(
        .ITER_BITS(ITER_BITS),
        .Q1_14_BITS(Q1_14_BITS),
        .Q4_27_BITS(Q4_27_BITS)
    ) cordic_top (
        .clk(clk), .rst(rst),
        .x_start(x_start), .y_start(y_start),
        .angle(angle),
        .cosine(cosine), .sine(sine),
        .valid_read(valid_read), .valid_write(valid_write)
    );
    //wire signed [Q4_27_BITS-1:0] z = cordic_top_dut.cordic_i.angle_acc_current;

    // Test angles from -360 to 720 degrees in 45 degree steps (-2pi to 4pi radians) in Q4.27 format
    parameter signed [Q4_27_BITS-1:0] 
        _PIo4   = 32'sh06487ed5, // pi/4    radians = 45  degrees
        _PIo2   = 32'sh0c90fdaa, // pi/2    radians = 90  degrees
        _3PIo4  = 32'sh12d97c7f, // 3*pi/4  radians = 135 degrees
        _PI     = 32'sh1921fb54, // pi      radians = 180 degrees
        _5PIo4  = 32'sh1f6a7a29, // 5*pi/4  radians = 225 degrees
        _3PIo2  = 32'sh25b2f8fe, // 3*pi/2  radians = 270 degrees
        _7PIo4  = 32'sh2bfb77d3, // 7*pi/4  radians = 315 degrees
        _2PI    = 32'sh3243f6a8, // 2*pi    radians = 360 degrees
        _9PIo4  = 32'sh388c757d, // 9*pi/4  radians = 405 degrees
        _5PIo2  = 32'sh3ed4f452, // 5*pi/2  radians = 450 degrees
        _11PIo4 = 32'sh451d7327, // 11*pi/4 radians = 495 degrees
        _3PI    = 32'sh4b65f1fc, // 3*pi    radians = 540 degrees
        _13PIo4 = 32'sh51ae70d1, // 13*pi/4 radians = 585 degrees
        _7PIo2  = 32'sh57f6efa6, // 7*pi/2  radians = 630 degrees
        _15PIo4 = 32'sh5e3f6e7b, // 15*pi/4 radians = 675 degrees
        _4PI    = 32'sh6487ed51; // 4*pi    radians = 720 degrees
    always #(T/2) clk = ~clk;
    initial begin
        //$monitor("T%0t cos %f sin %f z %f",
        //          $time, hex2real.hex2real16(cosine), hex2real.hex2real16(sine), hex2real.hex2real32(z)*180.0/3.141592653589793);
        
        // Test angles from -360 to 720 degrees in 45 degree steps
        //test_angle(-_2PI);   // -360 degrees
        //test_angle(-_7PIo4); // -315 degrees
        //test_angle(-_3PIo2); // -270 degrees
        //test_angle(-_5PIo4); // -225 degrees
        //test_angle(-_PI);    // -180 degrees
        //test_angle(-_3PIo4); // -135 degrees
        //test_angle(-_PIo2);  // -90  degrees
        //test_angle(-_PIo4);  // -45  degrees
        //rst = 1; #(T*4); rst = 0;
        //test_angle(0);       // 0    degrees
        //test_angle(_PIo4);   // 45   degrees
        //test_angle(_PIo2);   // 90   degrees
        //test_angle(_3PIo4);  // 135  degrees
        //test_angle(_PI);     // 180  degrees
        //test_angle(_5PIo4);  // 225  degrees
        //test_angle(_3PIo2);  // 270  degrees
        //test_angle(_7PIo4);  // 315  degrees
        //test_angle(_2PI);    // 360  degrees
        //test_angle(_9PIo4);  // 405  degrees
        //test_angle(_5PIo2);  // 450  degrees
        //test_angle(_11PIo4); // 495  degrees
        //test_angle(_3PI);    // 540  degrees
        //test_angle(_13PIo4); // 585  degrees
        //test_angle(_7PIo2);  // 630  degrees
        //test_angle(_15PIo4); // 675  degrees
        //test_angle(_4PI);    // 720  degrees

        // testing edge cases
        //test_angle(32'shffff_ffff); // min negative value
        //test_angle(32'sh0000_0001); // min positive value
        input_file = $fopen("../../matlab/output_matlab.txt", "r");
        //output_file = $fopen("output_rtl.txt", "w");
        clk = 0; rst = 1; angle = 32'sh0; x_start = 16'sh0; y_start = 16'sh0;
        #(T*2) rst = 0;
        x_start = COS_CONST; y_start = 16'sh0;
        fscanf_ret = 4;

        while (fscanf_ret != "EOF" && fscanf_ret == 4) begin
            wait(valid_write)
            fscanf_ret = $fscanf(input_file, "%h %h %h %f\n", angle, sin_matlab, cos_matlab, angle_deg);
            wait(valid_read)
            $fwrite(output_file, "%h %h %h %f\n", angle, sine, cosine, angle_deg);
            if (cosine != cos_matlab) begin
                $display("WARNING: Cosine mismatch detected at time %0t", $time);
                $display("Angle (deg): %0.14f", hex2real.hex2real32(angle)*180/3.141592653589793);
                $display("Cosine RTL: %0.14f, Cosine MATLAB: %0.14f", hex2real.hex2real16(cosine), hex2real.hex2real16(cos_matlab));
                $display("Difference: %f\n", hex2real.hex2real16(cosine) - hex2real.hex2real16(cos_matlab));
            end
            if (sine != sin_matlab) begin
                $display("WARNING: Sine mismatch detected detected at time %0t", $time);
                $display("Angle (deg): %0.14f", hex2real.hex2real32(angle)*180/3.141592653589793);
                $display("Sine RTL: %0.14f, Sine MATLAB: %0.14f", hex2real.hex2real16(sine), hex2real.hex2real16(sin_matlab));
                $display("Difference: %f\n", hex2real.hex2real16(sine) - hex2real.hex2real16(sin_matlab));
            end
            if ((cosine == cos_matlab) && (sine == sin_matlab)) begin
                $display("MATCH: Angle (deg): %0.14f, Cosine: %0.14f, Sine: %0.14f\n", hex2real.hex2real32(angle)*180.0/3.141592653589793, hex2real.hex2real16(cosine), hex2real.hex2real16(sine));
            end
        end
        $fclose(output_file);
        $fclose(input_file);
        $stop;
    end
endmodule
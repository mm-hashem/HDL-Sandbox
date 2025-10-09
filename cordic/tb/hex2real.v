module hex2real();
    function automatic real hex2real16(input [31:0] hex); // Q1.14
        integer i, sign;
        reg [15:14] int_part_bits;
        reg [13:0] frac_part_bits;
        real fraction_part = 0.0;
        begin
            if (hex[15] == 1) begin
                // Negative number, compute two's complement
                hex = ~hex + 1;
                sign = -1.0;
            end else begin
                sign = 1.0;
            end
            int_part_bits = hex[15:14];
            frac_part_bits = hex[13:0];
            for (i = 13; i >= 0; i = i - 1) begin
                if (frac_part_bits[i]) begin
                    fraction_part = fraction_part + 2.0**(-1*(13-i+1));
                end
            end
            hex2real16 = sign * (int_part_bits + fraction_part);
        end
    endfunction

    function automatic real hex2real32(input [31:0] hex); // Q4.27
        integer i, sign;
        reg [31:27] int_part_bits;
        reg [26:0] frac_part_bits;
        real fraction_part = 0.0;
        begin
            if (hex[31] == 1) begin
                // Negative number, compute two's complement
                hex = ~hex + 1;
                sign = -1.0;
            end else begin
                sign = 1.0;
            end
            int_part_bits = hex[31:27];
            frac_part_bits = hex[26:0];
            for (i = 26; i >= 0; i = i - 1) begin
                if (frac_part_bits[i]) begin
                    fraction_part = fraction_part + 2.0**(-1*(26-i+1));
                end
            end
            hex2real32 = sign * (int_part_bits + fraction_part);
        end
    endfunction
    function automatic signed [31:0] deg2rad2hex(input signed [31:0] degrees);
        real radians;
        begin
            radians = (degrees / 32'sd180) * 32'sh1921fb54;
            deg2rad2hex = $rtoi(radians * 2.0**27);
        end
    endfunction
endmodule
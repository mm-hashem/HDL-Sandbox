`timescale 1ns/10ps
module parking_lot_counter_tb();

localparam T = 20, COUNTER_BITS_tb = 8;

reg                        clk_tb, rst_tb,
                           a_tb, b_tb;
wire                       enter_tb, exit_tb;
wire [COUNTER_BITS_tb-1:0] lot_count_tb;
reg  [1:0]                 sensor_tb = {a_tb, b_tb};
reg  [3:0] crnt_task;

parking_lot_counter #(COUNTER_BITS_tb) uut(clk_tb, rst_tb, sensor_tb[1], sensor_tb[0], enter_tb, exit_tb, lot_count_tb);

always
begin
  clk_tb = 1'b1; #(T/2);
  clk_tb = 1'b0; #(T/2);
end

integer i;

initial
begin
  rst_tb = 1'b1;
  sensor_tb = 2'b00;
  @(negedge clk_tb);
  rst_tb = 1'b0;
  @(negedge clk_tb);

  for (i = 0; i < 5; i = i + 1)
    carIn();  
  for (i = 0; i < 5; i = i + 1)
    pedIn();  
  for (i = 0; i < 3; i = i + 1)
    carOut();  
  for (i = 0; i < 3; i = i + 1)
    pedOut();  
  for (i = 0; i < 2; i = i + 1)
    carOut();  
  $stop;
end

task carIn();
  begin
    crnt_task = 4'h0A;
    sensor_tb = 2'b00;
    @(negedge clk_tb);

    sensor_tb = 2'b10;
    @(negedge clk_tb);

    sensor_tb = 2'b11;
    @(negedge clk_tb);

    sensor_tb = 2'b01;
    @(negedge clk_tb);

    sensor_tb = 2'b00;
    @(negedge clk_tb);
    @(negedge clk_tb);
  end
endtask

task carOut();
  begin
    crnt_task = 4'h0B;
    sensor_tb = 2'b00;
    @(negedge clk_tb);

    sensor_tb = 2'b01;
    @(negedge clk_tb);

    sensor_tb = 2'b11;
    @(negedge clk_tb);

    sensor_tb = 2'b10;
    @(negedge clk_tb);

    sensor_tb = 2'b00;
    @(negedge clk_tb);
    @(negedge clk_tb);
  end
endtask

task pedIn();
  begin
    crnt_task = 4'h0C;
    sensor_tb = 2'b00;
    @(negedge clk_tb);

    sensor_tb = 2'b10;
    @(negedge clk_tb);

    sensor_tb = 2'b01;
    @(negedge clk_tb);

    sensor_tb = 2'b00;
    @(negedge clk_tb);
    @(negedge clk_tb);
  end
endtask

task pedOut();
  begin
    crnt_task = 4'h0D;
    sensor_tb = 2'b00;
    @(negedge clk_tb);

    sensor_tb = 2'b01;
    @(negedge clk_tb);

    sensor_tb = 2'b10;
    @(negedge clk_tb);

    sensor_tb = 2'b00;
    @(negedge clk_tb);
    @(negedge clk_tb);
  end
endtask

endmodule


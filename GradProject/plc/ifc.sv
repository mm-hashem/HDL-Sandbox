interface _ifc_ #(FIFO_DEPTH = 2) (input bit clk);

    logic wr_fifo, empty, full, rd_fifo, ser_out, piso_start, piso_done;
    logic [7:0] wr_data, rd_data, prl_out;

    parameter REG_DEPTH = 2**FIFO_DEPTH-1;

    modport FIFO (input  clk, wr_fifo, wr_data, rd_fifo,
                  output empty, full, rd_data);

    modport serializer (input  clk, empty, rd_data,
                        output rd_fifo, ser_out, piso_start, piso_done);
    
    modport deserializer (input  clk, ser_out, piso_start,
                          output prl_out);
            
    modport TEST (output wr_fifo, wr_data,
                  input  clk, empty, full, rd_fifo, ser_out, rd_data, piso_start, piso_done, prl_out);
endinterface
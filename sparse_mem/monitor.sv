module monitor(spmem_f.monitor_ports spm);
    always @(posedge spm.cb.cs_ni) begin
        $display("SPARSE MEM\t\tOP: READ\t\tOP_TYPE: %s\t\tADDR: %h\t\tDATA: %h", spm.mcb.re_i.name(), spm.mcb.read_address_i, spm.mcb.read_data_o);
    end
    always @(spm.mcb.we_i or spm.mcb.write_address_i or spm.mcb.write_data_i) begin
        $display("SPARSE MEM\t\tOP: WRITE\t\tOP_TYPE: %s\t\tADDR: %h\t\tDATA: %h\n", spm.mcb.we_i.name(), spm.mcb.write_address_i, spm.mcb.write_data_i);
    end
endmodule
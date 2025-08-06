import fifo_transaction_pkg::*;
import shared_pkg::*;
module fifo_tb(fifo_interface.TEST fifo_if);
    fifo_transaction fifo_testb;
    initial begin
        fifo_testb = new(); 
        fifo_if.data_in = 0;
        fifo_if.wr_en = 0;
        fifo_if.rd_en = 0;
       
        fifo_if.rst_n = 0; //active low
        @(negedge fifo_if.clk);#0;
        fifo_if.rst_n = 1;
        repeat(10000) begin
            assert (fifo_testb.randomize());
            fifo_if.data_in = fifo_testb.data_in;
            fifo_if.rst_n = fifo_testb.rst_n;  
            fifo_if.wr_en = fifo_testb.wr_en;  
            fifo_if.rd_en = fifo_testb.rd_en;
            @(negedge fifo_if.clk);#0;
        end
        test_finished = 1;
    end
endmodule
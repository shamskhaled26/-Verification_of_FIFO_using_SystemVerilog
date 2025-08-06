import fifo_transaction_pkg::*;
import fifo_scoreboard_pkg::*;
import fifo_coverage_pkg::*;
import shared_pkg::*;

module fifo_monitor(fifo_interface.MONITOR fifo_if);
fifo_transaction fifo_trans= new();
fifo_scoreboard  fifo_scr  = new();
fifo_coverage    fifo_covr = new();
initial begin
    forever begin
        @(negedge fifo_if.clk);
        fifo_trans.data_in = fifo_if.data_in;
        fifo_trans.rst_n = fifo_if.rst_n;  
        fifo_trans.wr_en = fifo_if.wr_en;  
        fifo_trans.rd_en = fifo_if.rd_en;
        fifo_trans.data_out = fifo_if.data_out;
        fifo_trans.wr_ack = fifo_if.wr_ack;  
        fifo_trans.overflow = fifo_if.overflow;  
        fifo_trans.full = fifo_if.full;
        fifo_trans.empty = fifo_if.empty;
        fifo_trans.almostfull = fifo_if.almostfull;  
        fifo_trans.almostempty = fifo_if.almostempty;  
        fifo_trans.underflow = fifo_if.underflow;
        fork 
            begin    fifo_covr.sample_data(fifo_trans); end
            begin    fifo_scr.check_data(fifo_trans);   end
        join

        if(test_finished)begin
            $display("--|   time = %0t : with error count = %0d and correct count = %0d    |--",$realtime() ,error_count,correct_count);
            $stop;
        end 
    end
end
endmodule
package fifo_scoreboard_pkg;
import fifo_transaction_pkg::*;
import shared_pkg::*;

    class fifo_scoreboard;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;

        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic full_ref, wr_ack_ref, overflow_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        localparam max_fifo_addr = $clog2(FIFO_DEPTH);
        logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
        logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
        logic [max_fifo_addr:0] count;
    
        function void check_data (fifo_transaction f_t);
            reference_model(f_t);
            if((data_out_ref !== f_t.data_out) || (full_ref !== f_t.full) ||(wr_ack_ref !== f_t.wr_ack)|| (overflow_ref!==f_t.overflow) || (empty_ref!==f_t.empty)
            || (almostfull_ref!==f_t.almostfull)|| (almostempty_ref!==f_t.almostempty)|| (underflow_ref!==f_t.underflow))
                error_count++;
            else correct_count++;
        endfunction
    
        function void reference_model(fifo_transaction fifo_ref);
            if(!fifo_ref.rst_n)begin
                rd_ptr=0; wr_ptr=0;count=0;wr_ack_ref=0;
                underflow_ref=0;overflow_ref=0;
                full_ref=0;empty_ref =1;
                almostempty_ref=0; almostfull_ref=0;
            end
            else begin
                if(fifo_ref.wr_en && !full_ref)begin //write
                    mem[wr_ptr] = fifo_ref.data_in;
                    wr_ack_ref = 1;
                    wr_ptr ++;
                    count++;
                    overflow_ref=0;
                    end
                    else if(fifo_ref.wr_en && full_ref) begin
                        overflow_ref=1;
                        wr_ack_ref = 0;
                    end
                    else begin
                        wr_ack_ref = 0;
                        overflow_ref=0;  
                    end
           
                if(fifo_ref.rd_en && !empty_ref)begin //read
                        data_out_ref = mem[rd_ptr];
                        rd_ptr++;
                        underflow_ref = 0;
                        count--;
                    end 
                else if(fifo_ref.rd_en && empty_ref) underflow_ref=1;   
                else underflow_ref=0;
            
                full_ref = (count == FIFO_DEPTH)? 1 : 0;
                empty_ref = (count == 0)? 1 : 0;    
                almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0;
                almostempty_ref = (count == 1)? 1 : 0;
             
            end    
        endfunction 
    endclass
endpackage

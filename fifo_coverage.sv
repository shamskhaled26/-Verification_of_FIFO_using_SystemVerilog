package fifo_coverage_pkg;
import fifo_transaction_pkg::*;
class fifo_coverage;   
    fifo_transaction F_cvg_txn =new;
 
        covergroup cvr_gp ;

        cvr_datain:          coverpoint F_cvg_txn.data_in;  
        cvr_rst_n:           coverpoint F_cvg_txn.rst_n;    
        cvr_wr_en:           coverpoint F_cvg_txn.wr_en;    
        cvr_rd_en:           coverpoint F_cvg_txn.rd_en;    
        cvr_data_out:        coverpoint F_cvg_txn.data_out; 
        cvr_ack:             coverpoint F_cvg_txn.wr_ack;
        cvr_overflow:        coverpoint F_cvg_txn.overflow;
        cvr_full:            coverpoint F_cvg_txn.full;
        cvr_empty:           coverpoint F_cvg_txn.empty;
        cvr_almostfull:      coverpoint F_cvg_txn.almostfull;
        cvr_almostempty:     coverpoint F_cvg_txn.almostempty;
        cvr_underflow:       coverpoint F_cvg_txn.underflow;


        cross cvr_wr_en,cvr_rd_en,cvr_ack{
            bins wr1_rd0_ack1 = binsof( cvr_wr_en) intersect {1} && binsof(cvr_rd_en) intersect {0} && binsof(cvr_ack) intersect {1};
            bins wr0_rd1_ack0 = binsof( cvr_wr_en) intersect {0} && binsof(cvr_rd_en) intersect {1} && binsof(cvr_ack) intersect {0};
            option.cross_auto_bin_max=0;
        }
        cross cvr_wr_en,cvr_rd_en,cvr_overflow{
            bins wr1_rd0_overflow1 = binsof( cvr_wr_en) intersect {1} && binsof(cvr_rd_en) intersect {0} && binsof(cvr_overflow) intersect {1};
            bins wr0_rd1_overflow0 = binsof( cvr_wr_en) intersect {0} && binsof(cvr_rd_en) intersect {1} && binsof(cvr_overflow) intersect {0};
            option.cross_auto_bin_max=0;
        }
        cross cvr_wr_en,cvr_rd_en, cvr_full{
            bins wr1_rd0_full1 = binsof( cvr_wr_en) intersect {1} && binsof(cvr_rd_en) intersect {0} && binsof( cvr_full) intersect {1};
            bins wr0_rd1_full0 = binsof( cvr_wr_en) intersect {0} && binsof(cvr_rd_en) intersect {1} && binsof( cvr_full) intersect {0};
            option.cross_auto_bin_max=0;
        }
        cross cvr_wr_en,cvr_rd_en,cvr_empty{
            bins wr1_rd0_empty1 = binsof( cvr_wr_en) intersect {1} && binsof(cvr_rd_en) intersect {0} && binsof(cvr_empty) intersect {0};
            bins wr0_rd1_empty0 = binsof( cvr_wr_en) intersect {0} && binsof(cvr_rd_en) intersect {1} && binsof(cvr_empty) intersect {1};
            option.cross_auto_bin_max=0;
        }
        cross cvr_wr_en,cvr_rd_en,cvr_almostfull{
            bins wr1_rd0_almostfull1 = binsof( cvr_wr_en) intersect {1} && binsof(cvr_rd_en) intersect {0} && binsof(cvr_almostfull) intersect {1};
            bins wr0_rd1_almostfull0 = binsof( cvr_wr_en) intersect {0} && binsof(cvr_rd_en) intersect {1} && binsof(cvr_almostfull) intersect {0};
            option.cross_auto_bin_max=0;
        }
        cross cvr_wr_en,cvr_rd_en,cvr_almostempty{
            bins wr1_rd0_almostempty1 = binsof( cvr_wr_en) intersect {1} && binsof(cvr_rd_en) intersect {0} && binsof(cvr_almostempty) intersect {1};
            bins wr0_rd1_almostempty0 = binsof( cvr_wr_en) intersect {0} && binsof(cvr_rd_en) intersect {1} && binsof(cvr_almostempty) intersect {0};
            option.cross_auto_bin_max=0;
        }
        cross cvr_wr_en,cvr_rd_en,cvr_underflow{
            bins wr1_rd0_underflow1 = binsof( cvr_wr_en) intersect {1} && binsof(cvr_rd_en) intersect {0} && binsof(cvr_underflow) intersect {0};
            bins wr0_rd1_underflow0 = binsof( cvr_wr_en) intersect {0} && binsof(cvr_rd_en) intersect {1} && binsof(cvr_underflow) intersect {1};//
            option.cross_auto_bin_max=0;
        }
        endgroup
    

    function new();
        cvr_gp=new();
    endfunction

    function void sample_data(input fifo_transaction F_txn);
      this.F_cvg_txn = F_txn;
        cvr_gp.sample();
    endfunction
endclass
endpackage

package fifo_transaction_pkg;
    class fifo_transaction;
    //I/OP declaration//
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic  rst_n, wr_en, rd_en;
    logic  [FIFO_WIDTH-1:0] data_out;
    logic  wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    //add 2 integers//
    int RD_EN_ON_DIST ;
    int WR_EN_ON_DIST ;

    // Constructor with default values
    function new(input int wr_dist = 70, int rd_dist = 30);
        this.WR_EN_ON_DIST = wr_dist;
        this.RD_EN_ON_DIST = rd_dist;
    endfunction
    //Add the following 3 constraint blocks//
    constraint reset_enable{
        rst_n dist{0:/ 5 , 1:/95};
    }
    constraint write_enable{
        wr_en dist{1:/ WR_EN_ON_DIST , 0:/(100-WR_EN_ON_DIST)};
    }
    constraint read_enable{
        rd_en dist{1:/ RD_EN_ON_DIST , 0:/(100-RD_EN_ON_DIST)};
    }  

    endclass
endpackage

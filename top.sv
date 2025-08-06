module top();
    bit clk;
    always #1 clk=!clk;

fifo_interface fifo_if(clk);
FIFO DUT(fifo_if);
fifo_tb TEST(fifo_if);
fifo_monitor fifo_monitor(fifo_if);

    
endmodule
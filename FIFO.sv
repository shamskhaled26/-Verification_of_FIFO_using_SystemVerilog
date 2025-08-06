////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_interface.DUT fifo_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);
reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
		fifo_if.wr_ack<=0;////is added////////
		fifo_if.overflow<=0;////is added////////
	end
	else if (fifo_if.wr_en && count < FIFO_DEPTH) begin//write
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifo_if.overflow<=0;////is added////////

	end
	else begin 
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full & fifo_if.wr_en)
			fifo_if.overflow <= 1;
		else
			fifo_if.overflow <= 0;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin //read
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
		fifo_if.underflow<=0;////is added////////

	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifo_if.underflow<=0;////is added////////
	end
	else if (fifo_if.empty && fifo_if.rd_en) ////is added////////
		fifo_if.underflow<=1;				////is added////////
	else 	fifo_if.underflow<=0; 			////is added////////
	
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin//counter
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
			count <= count - 1;
		////is added////////			
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full)
			count <= count - 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty)
			count <= count + 1;
	end
end

assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
assign fifo_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; //corrected 1 not 2////
assign fifo_if.almostempty = (count == 1)? 1 : 0;

`ifdef SIM

always_comb begin
	if(!fifo_if.rst_n)begin
		assert final (!count && !wr_ptr && !rd_ptr && !fifo_if.wr_ack && !fifo_if.overflow && !fifo_if.underflow);
		end
	assert final (fifo_if.full == (count == FIFO_DEPTH)? 1 : 0);
	assert final (fifo_if.empty == (count == 0)? 1 : 0);
	assert final (fifo_if.almostfull == (count == FIFO_DEPTH-1)? 1 : 0);
	assert final (fifo_if.almostempty == (count == 1)? 1 : 0);

end	
	property write_ack_p;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && !fifo_if.full) |=> (fifo_if.wr_ack);
	endproperty 
assert property(write_ack_p); cover property(write_ack_p);
	
	property overflow_p;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && fifo_if.full) |=> (fifo_if.overflow);
	endproperty 
assert property(overflow_p); cover property(overflow_p);

	property underflow_p;
		@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.rd_en && fifo_if.empty) |=> (fifo_if.underflow);
	endproperty 
assert property(underflow_p); cover property(underflow_p);

	property wr_ptr_p;
		@(posedge fifo_if.clk)  disable iff(!fifo_if.rst_n) (fifo_if.wr_en && !fifo_if.full) |=> (wr_ptr == (($past(wr_ptr)+1)%FIFO_DEPTH));
	endproperty 
assert property(wr_ptr_p); cover property(wr_ptr_p);

	property rd_ptr_p;
		@(posedge fifo_if.clk)  disable iff(!fifo_if.rst_n) (fifo_if.rd_en && !fifo_if.empty) |=> (rd_ptr == (($past(rd_ptr)+1)%FIFO_DEPTH));
	endproperty 
assert property(rd_ptr_p); cover property(rd_ptr_p);

`endif 
endmodule
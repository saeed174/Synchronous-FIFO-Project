////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
// Description: FIFO Design
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.dut if_c);

	logic [if_c.max_fifo_addr-1:0] wr_ptr, rd_ptr;
    logic [if_c.max_fifo_addr:0] count;
	logic [if_c.FIFO_WIDTH-1:0] mem [if_c.FIFO_DEPTH-1:0];

	reset_assert: assert property (@(if_c.rst_n) 
	(!if_c.rst_n |-> 
	(wr_ptr == 0 && rd_ptr == 0 && count == 0 && if_c.overflow == 0 && if_c.wr_ack == 0 && if_c.data_out == 0)));
	reset_cover: cover property (@(if_c.rst_n) 
	(!if_c.rst_n |-> 
	(wr_ptr == 0 && rd_ptr == 0 && count == 0 && if_c.overflow == 0 && if_c.wr_ack == 0 && if_c.data_out == 0)));

	always @(posedge if_c.clk or negedge if_c.rst_n) begin
		if (!if_c.rst_n) begin
			wr_ptr <= 0;
			if_c.overflow <= 0; //fix
			if_c.wr_ack <= 0; //fix
		end
		else if (if_c.wr_en && count < if_c.FIFO_DEPTH) begin
			mem[wr_ptr] <= if_c.data_in;
			if_c.wr_ack <= 1;
			wr_ptr <= (wr_ptr + 1)%8;
			if_c.overflow <= 0;
		end
		else begin
			if_c.wr_ack <= 0;
			if (if_c.full && if_c.wr_en)
				if_c.overflow <= 1;
			else
				if_c.overflow <= 0;
		end
	end

	always @(posedge if_c.clk or negedge if_c.rst_n) begin
		if (!if_c.rst_n) begin
			rd_ptr <= 0;
			if_c.data_out <= 0; //fix
			if_c.underflow <= 0;
		end
		else if (if_c.rd_en && count != 0) begin
			if_c.data_out <= mem[rd_ptr];
			rd_ptr <= (rd_ptr + 1)%8;
			if_c.underflow <= 0;
		end
		else if(if_c.empty && if_c.rd_en) begin //fix
			if_c.underflow <= 1;
		end
		else begin
			if_c.underflow <= 0;
		end
	end

	always @(posedge if_c.clk or negedge if_c.rst_n) begin
		if (!if_c.rst_n) begin
			count <= 0;
		end
		else begin
			if	( ({if_c.wr_en, if_c.rd_en} == 2'b10) && !if_c.full)
				count <= count + 1;
			else if ( ({if_c.wr_en, if_c.rd_en} == 2'b01) && !if_c.empty)
				count <= count - 1;
			else if( {if_c.wr_en, if_c.rd_en} == 2'b11) begin //fix
				if(if_c.full)
					count <= count - 1;
				else if(if_c.empty)
					count <= count + 1;
				else
					count <= count;
			end
		end
	end

	assign if_c.full = (count == if_c.FIFO_DEPTH)? 1 : 0;
	assign if_c.empty = (count == 0)? 1 : 0;
	assign if_c.almostfull = (count == if_c.FIFO_DEPTH-1)? 1 : 0; // almost full when one space is left not two
	assign if_c.almostempty = (count == 1)? 1 : 0;

	`ifdef SIM
		property wr_ptr_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (if_c.wr_en && count < if_c.FIFO_DEPTH |=> wr_ptr == ($past(wr_ptr) + 1)%if_c.FIFO_DEPTH)
		endproperty
		wr_ptr_assert		: assert property (wr_ptr_prop);
		wr_ptr_cover		: cover property (wr_ptr_prop);
		
		property rd_ptr_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (if_c.rd_en && count != 0 |=> rd_ptr == ($past(rd_ptr) + 1)%if_c.FIFO_DEPTH)
		endproperty
		rd_ptr_assert		: assert property (rd_ptr_prop);
		rd_ptr_cover		: cover property (rd_ptr_prop);

		property wr_ptr_wrap_prop;
			@(posedge if_c.clk) (wr_ptr == if_c.FIFO_DEPTH - 1 && if_c.wr_en && count < if_c.FIFO_DEPTH |=> wr_ptr == 0)
		endproperty
		wr_ptr_wrap: assert property (wr_ptr_wrap_prop);
		wr_ptr_wrap_cover: cover property (wr_ptr_wrap_prop);

		property rd_ptr_wrap_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (rd_ptr == if_c.FIFO_DEPTH - 1 && if_c.rd_en && count != 0 |=> rd_ptr == 0)
		endproperty
    	rd_ptr_wrap: assert property (rd_ptr_wrap_prop);
    	rd_ptr_wrap_cover: cover property (rd_ptr_wrap_prop);

		property counter1_prop;
			@(posedge if_c.clk)  disable iff(!if_c.rst_n) (({if_c.wr_en, if_c.rd_en} == 2'b10) && !if_c.full |=> count == $past(count) + 1)
		endproperty
		counter_assert1		: assert property (counter1_prop);
		counter_cover1		: cover property (counter1_prop);

		property counter2_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (({if_c.wr_en, if_c.rd_en} == 2'b01) && !if_c.empty |=> count == $past(count) - 1)
		endproperty
		counter_assert2		: assert property (counter2_prop);
		counter_cover2		: cover property (counter2_prop);

		property counter3_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (({if_c.wr_en, if_c.rd_en} == 2'b11) && if_c.full |=> count == $past(count) - 1)
		endproperty
		counter_assert3		: assert property (counter3_prop);
		counter_cover3		: cover property (counter3_prop);

		property counter4_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (({if_c.wr_en, if_c.rd_en} == 2'b11) && if_c.empty |=> count == $past(count) + 1)
		endproperty
		counter_assert4		: assert property (counter4_prop);
		counter_cover4		: cover property (counter4_prop);

		property wr_ack1_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (if_c.wr_en && count < if_c.FIFO_DEPTH |=> if_c.wr_ack == 1)
		endproperty
		wr_ack_assert1		: assert property (wr_ack1_prop);
		wr_ack_cover1		: cover property (wr_ack1_prop);

		property wr_ack2_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (!if_c.wr_en || !(count < if_c.FIFO_DEPTH) |=> if_c.wr_ack == 0)
		endproperty
		wr_ack_assert2		: assert property (wr_ack2_prop);
		wr_ack_cover2		: cover property (wr_ack2_prop);

		property overflow_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (if_c.wr_en && count == if_c.FIFO_DEPTH |=> if_c.overflow == 1)
		endproperty
		overflow_assert		: assert property (overflow_prop);
		overflow_cover		: cover property (overflow_prop);

		property underflow_prop;
			@(posedge if_c.clk) disable iff(!if_c.rst_n) (if_c.rd_en && count == 0 |=> if_c.underflow == 1)
		endproperty
		underflow_assert	: assert property (underflow_prop);
		underflow_cover		: cover property (underflow_prop);
	`endif
endmodule
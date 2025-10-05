module FIFO_top();
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    FIFO_interface if_c(clk);
    FIFO dut(if_c);
    FIFO_monitor monitor(if_c);
    FIFO_tb tb(if_c);

    `ifdef SIM
		always_comb begin
            if(!if_c.rst_n) begin
                wr_ptr_reset: assert final (dut.wr_ptr == 0);
                rd_ptr_reset: assert final (dut.rd_ptr == 0);
                count_reset: assert final (dut.count == 0);
                full_reset: assert final (if_c.full == 0);
                empty_reset: assert final (if_c.empty == 1);
                almostfull_reset: assert final (if_c.almostfull == 0);
                almostempty_reset: assert final (if_c.almostempty == 0);
            end
		end
    `endif
endmodule
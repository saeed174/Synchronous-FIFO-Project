import FIFO_transaction_pkg::*;
import shared_pkg::*;
module FIFO_tb(FIFO_interface.tb if_c);

    FIFO_transaction FIFO_c;

    initial begin
        test_finished = 0;
        FIFO_c = new();
        // FIFO_1
        assert_reset();
        // FIFO_2
        if_c.wr_en = 1;
        if_c.rd_en = 0;
        for(int i = 0; i < 10; i++) begin
            assert(FIFO_c.randomize());
            if_c.data_in = FIFO_c.data_in;
            @(negedge if_c.clk);
            -> driver_finished;
        end
        // FIFO_3
        if_c.wr_en = 0;
        if_c.rd_en = 1;
        for(int i = 0; i < 10; i++) begin
            assert(FIFO_c.randomize());
            if_c.data_in = FIFO_c.data_in;
            @(negedge if_c.clk);
            -> driver_finished;
        end
        // FIFO_4
        for(int i = 0; i < 980; i++) begin
            assert(FIFO_c.randomize());
            if_c.rst_n = FIFO_c.rst_n;
            if_c.data_in = FIFO_c.data_in;
            if_c.wr_en = FIFO_c.wr_en;
            if_c.rd_en = FIFO_c.rd_en;
            @(negedge if_c.clk);
            -> driver_finished;
        end

        test_finished = 1;
        $display("Test finished with %0d errors and %0d correct."
        , error_count, correct_count);

        $stop;
    end

    task assert_reset;
        if_c.rst_n = 0;
        @(posedge if_c.clk);
        if_c.rst_n = 1;
    endtask
endmodule
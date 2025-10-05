import FIFO_scoreboard_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;
module FIFO_monitor(FIFO_interface.monitor if_c);
    FIFO_transaction F_txn = new();
    FIFO_scoreboard F_scoreboard = new();
    FIFO_coverage F_coverage = new();

    initial begin
        forever begin
            wait(driver_finished.triggered);
            @(negedge if_c.clk);
            F_txn.rst_n = if_c.rst_n;
            F_txn.data_in = if_c.data_in;
            F_txn.clk = if_c.clk;
            F_txn.wr_en = if_c.wr_en;
            F_txn.rd_en = if_c.rd_en;
            F_txn.data_out = if_c.data_out;
            F_txn.wr_ack = if_c.wr_ack;
            F_txn.overflow = if_c.overflow;
            F_txn.full = if_c.full;
            F_txn.empty = if_c.empty;
            F_txn.almostfull = if_c.almostfull;
            F_txn.almostempty = if_c.almostempty;
            F_txn.underflow = if_c.underflow;

            fork
                begin
                    F_coverage.sample_data(F_txn);
                end
                begin
                    F_scoreboard.check_data(F_txn);
                end
            join
            if(test_finished == 1) begin
                break;
            end
        end
    end
endmodule
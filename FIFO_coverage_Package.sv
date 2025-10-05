package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;
    class FIFO_coverage;

        FIFO_transaction F_cvg_txn;

        covergroup fifo_cg;
            wr_en_cp: coverpoint F_cvg_txn.wr_en{
                bins zero = {0};
                bins one = {1};
            }
            rd_en_cp: coverpoint F_cvg_txn.rd_en{
                bins zero = {0};
                bins one = {1};
            }
            underflow_cp: coverpoint F_cvg_txn.underflow{
                bins zero = {0};
                bins one = {1};
            }
            wr_ack_cp: coverpoint F_cvg_txn.wr_ack{
                bins zero = {0};
                bins one = {1};
            }
            overflow_cp: coverpoint F_cvg_txn.overflow{
                bins zero = {0};
                bins one = {1};
            }
            full_cp: coverpoint F_cvg_txn.full{
                bins zero = {0};
                bins one = {1};
            }
            empty_cp: coverpoint F_cvg_txn.empty{
                bins zero = {0};
                bins one = {1};
            }
            almostempty_cp: coverpoint F_cvg_txn.almostempty{
                bins zero = {0};
                bins one = {1};
            }
            cross_wr_ack: cross wr_en_cp, rd_en_cp, wr_ack_cp{
                ignore_bins wr_en0_ack1 = binsof(wr_en_cp.zero) && binsof(wr_ack_cp.one);
            }
            cross_overflow: cross wr_en_cp, rd_en_cp, overflow_cp{
                ignore_bins wr_en0_overflow1 = binsof(wr_en_cp.zero) && binsof(overflow_cp.one);
            }
            cross_underflow: cross wr_en_cp, rd_en_cp, underflow_cp{
                ignore_bins rd_en0 = binsof(rd_en_cp.zero)&& binsof(underflow_cp.one);
            }
            cross_full: cross wr_en_cp, rd_en_cp, full_cp{
                ignore_bins rd_full = binsof(rd_en_cp.one) && binsof(full_cp.one);
            }
            cross_empty: cross wr_en_cp, rd_en_cp, empty_cp;
            cross_almostfull: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostfull;
            cross_almostempty: cross wr_en_cp, rd_en_cp, almostempty_cp;
        endgroup

        function new();
            fifo_cg = new();
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            fifo_cg.sample();
        endfunction
    endclass
endpackage
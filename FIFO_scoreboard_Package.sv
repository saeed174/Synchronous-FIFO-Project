package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*;
    import shared_pkg::*;
    class FIFO_scoreboard;
        logic [FIFO_WIDTH-1:0] data_out_ref = 0;
        logic full_ref = 0, empty_ref = 1, almostfull_ref = 0, almostempty_ref = 0, underflow_ref = 0, overflow_ref = 0, wr_ack_ref = 0;

        logic [3:0] count = 0;

        logic done = 0;

        logic [FIFO_WIDTH-1:0] mem [$];

        function void check_data(FIFO_transaction F_txn);
            reference_model(F_txn);
            if (F_txn.overflow != overflow_ref) begin
                $display("ERROR: Overflow mismatch %b != %b", F_txn.overflow, overflow_ref);
                error_count++;
            end
            else if (F_txn.underflow != underflow_ref) begin
                $display("ERROR: Underflow mismatch %b != %b", F_txn.underflow, underflow_ref);
                error_count++;
            end
            else if (F_txn.wr_ack != wr_ack_ref) begin
                $display("ERROR: Wr_ack mismatch %b != %b", F_txn.wr_ack, wr_ack_ref);
                error_count++;
            end
            else if (F_txn.full != full_ref) begin
                $display("ERROR: Full mismatch %b != %b", F_txn.full, full_ref);
                error_count++;
            end
            else if (F_txn.empty != empty_ref) begin
                $display("ERROR: Empty mismatch %b != %b", F_txn.empty, empty_ref);
                error_count++;
            end
            else if (F_txn.almostfull != almostfull_ref) begin
                $display("ERROR: Almostfull mismatch %b != %b", F_txn.almostfull, almostfull_ref);
                error_count++;
            end
            else if (F_txn.almostempty != almostempty_ref) begin
                $display("ERROR: Almostempty mismatch %b != %b", F_txn.almostempty, almostempty_ref);
                error_count++;
            end
            else if (F_txn.data_out != data_out_ref) begin
                $display("ERROR: Data mismatch %h != %h", F_txn.data_out, data_out_ref);
                error_count++;
            end
            else begin
                correct_count++;
            end
        endfunction

        function void reference_model(FIFO_transaction F_txn);
            done = 0;
            if (!F_txn.rst_n) begin
                wr_ack_ref     = 0;
                overflow_ref   = 0;
                data_out_ref   = 0;
                underflow_ref  = 0;
                mem.delete();
            end
            else begin
                if(F_txn.wr_en && F_txn.rd_en) begin
                    if(full_ref) begin
                        data_out_ref = mem.pop_front();
                        underflow_ref = 0;
                        overflow_ref = 1;
                        wr_ack_ref = 0;
                        done = 1;
                    end
                    else if(empty_ref) begin
                        mem.push_back(F_txn.data_in);
                        wr_ack_ref = 1;
                        overflow_ref = 0;
                        underflow_ref = 1;
                        done = 1;
                    end
                end
                
                if(!done) begin
                    if (F_txn.wr_en && mem.size() < FIFO_DEPTH) begin
                        mem.push_back(F_txn.data_in);
                        wr_ack_ref = 1;
                        overflow_ref = 0;
                    end
                    else begin
                        wr_ack_ref = 0;
                        if (full_ref && F_txn.wr_en)
                            overflow_ref = 1;
                        else
                            overflow_ref = 0;
                    end
                
                    if (F_txn.rd_en && mem.size() != 0) begin
                        data_out_ref = mem.pop_front();
                        underflow_ref = 0;
                    end
                    else if(F_txn.rd_en && mem.size() == 0) begin
                        underflow_ref = 1;
                    end
                    else begin
                        underflow_ref = 0;
                    end
                end
            end
            
            full_ref      = (mem.size() == FIFO_DEPTH) ? 1 : 0;
            empty_ref     = (mem.size() == 0) ? 1 : 0;
            almostfull_ref  = (mem.size() == FIFO_DEPTH - 1) ? 1 : 0;
            almostempty_ref = (mem.size() == 1) ? 1 : 0;
        endfunction

    endclass
endpackage
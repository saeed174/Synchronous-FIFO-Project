package FIFO_transaction_pkg;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    parameter max_fifo_addr = $clog2(FIFO_DEPTH);

    class FIFO_transaction;
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic clk, rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

        constraint reset_c {
            rst_n dist {0:/5 , 1:/95};
        }
        constraint wr_en_c {
            wr_en dist {0:/(100-WR_EN_ON_DIST) , 1:/WR_EN_ON_DIST};
        }
        constraint rd_en_c {
            rd_en dist {0:/(100-RD_EN_ON_DIST) , 1:/RD_EN_ON_DIST};
        }

        function new(int RD_EN_ON_DIST = 30, int WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction

    endclass
endpackage
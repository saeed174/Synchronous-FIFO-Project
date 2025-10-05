interface FIFO_interface (input clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    

    modport dut (
        input clk,
        input rst_n,
        input wr_en,
        input rd_en,
        input data_in,
        output data_out,
        output wr_ack,
        output overflow,
        output full,
        output empty,
        output almostfull,
        output almostempty,
        output underflow
    );

    modport tb (
        input clk,
        output rst_n,
        output wr_en,
        output rd_en,
        output data_in,
        input data_out,
        input wr_ack,
        input overflow,
        input full,
        input empty,
        input almostfull,
        input almostempty,
        input underflow
    );

    modport monitor (
        input clk,
        input rst_n,
        input wr_en,
        input rd_en,
        input data_in,
        input data_out,
        input wr_ack,
        input overflow,
        input full,
        input empty,
        input almostfull,
        input almostempty,
        input underflow
    );
endinterface
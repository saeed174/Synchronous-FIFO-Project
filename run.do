vlib work
vlog -f src_files.list +define+SIM -cover bcesf +cover +acc -covercells
vsim -coverage -voptargs=+acc FIFO_top -cover
add wave *
add wave -position insertpoint  \
sim:/FIFO_top/if_c/rst_n \
sim:/FIFO_top/if_c/wr_en \
sim:/FIFO_top/if_c/rd_en \
sim:/FIFO_top/if_c/data_in \
sim:/FIFO_top/if_c/data_out \
sim:/FIFO_top/if_c/full \
sim:/FIFO_top/if_c/empty \
sim:/FIFO_top/if_c/almostfull \
sim:/FIFO_top/if_c/almostempty \
sim:/FIFO_top/if_c/underflow \
sim:/FIFO_top/if_c/overflow \
sim:/FIFO_top/if_c/wr_ack

add wave -position insertpoint  \
sim:/shared_pkg::correct_count \
sim:/shared_pkg::error_count

add wave -position insertpoint  \
sim:/FIFO_top/monitor/F_scoreboard


coverage save FIFO_top.ucdb -onexit
run 0
run -all
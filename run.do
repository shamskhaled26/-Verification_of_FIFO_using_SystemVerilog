vlib work
vlog fifo_interface.sv FIFO.sv shared_pkg.sv fifo_transaction.sv fifo_monitor.sv fifo_coverage.sv  fifo_scoreboard.sv fifo_tb.sv top.sv +cover +define+SIM
vsim -voptargs=+acc work.top -cover
add wave -position insertpoint sim:/top/fifo_if/*
add wave -position insertpoin  sim:/top/fifo_monitor/fifo_scr
coverage save top.ucdb -onexit
run -all
vcover report top.ucdb -details -annotate -all -output coverage_report.txt


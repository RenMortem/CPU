# Search Path and Logic Library Setup
#set_app_var search_path "$search_path . ./rtl/rtl ./libs"
set_app_var search_path "$search_path . ./rtl /evprj198/projects/skywater/sky130/lib/sky130_fd_sc_hd/db_nldm/"
#set_app_var target_library "sky130_fd_sc_hd__ff_100C_1v95.db sky130_fd_sc_hd__ss_100C_1v40.db"
#set_app_var link_library "* $target_library"
set_app_var target_library "sky130_fd_sc_hd__ff_100C_1v95.db \
			    sky130_fd_sc_hd__tt_025C_1v80.db \
			    sky130_fd_sc_hd__tt_100C_1v80.db \
			    sky130_fd_sc_hd__ff_n40C_1v76.db \
			    sky130_fd_sc_hd__ss_n40C_1v76.db \
			    sky130_fd_sc_hd__ff_100C_1v65.db \
			    sky130_fd_sc_hd__ff_n40C_1v65.db \
 			    sky130_fd_sc_hd__ss_100C_1v60.db \
  			    sky130_fd_sc_hd__ff_n40C_1v56.db \
   			    sky130_fd_sc_hd__ss_n40C_1v44.db \
			    sky130_fd_sc_hd__ss_100C_1v40.db \
			    sky130_fd_sc_hd__ss_n40C_1v40.db \
   			    sky130_fd_sc_hd__ss_n40C_1v35.db \
   			    sky130_fd_sc_hd__ss_n40C_1v28.db "

set_app_var link_library "* $target_library"
#
# RTL Reading and Link
analyze -format sverilog {top.sv control.sv memory.sv mux_2.sv ALU.sv mux4.sv register_2bits.sv register_bank.sv register_bank2.sv register_bank3.sv}
elaborate top -parameters "WIDTH=8"
link

#return
####### Constraints Setup II
set clk_val 30
create_clock -period $clk_val [get_ports clk]
set_clock_uncertainty -setup [expr  $clk_val*0.1] [get_clock clk]
set_clock_transition -max [expr  $clk_val*0.1] [get_clock clk]
set_clock_latency -source -max  [expr  $clk_val*0.05] [get_clock clk]
set_clock_latency -max  [expr  $clk_val*0.03] [get_clock clk]
#set_input_delay -max [expr $clk_val*0.4] -clock clk [get_ports [remove_from_collection [all_inputs] clk]]
#set_output_delay -max [expr $clk_val*0.5] -clock clk [get_ports [all_outputs]]
set_input_delay -max [expr  $clk_val*0.4] -clock clk [remove_from_collection [all_inputs] clk]
set_output_delay -max [expr  $clk_val*0.5] -clock clk [all_outputs]
set_load -max [expr {40/1000}] [all_outputs]
set_input_transition -min [expr  $clk_val*0.01] [remove_from_collection [all_inputs] clk]
set_input_transition -max [expr  $clk_val*0.1]  [remove_from_collection [all_inputs] clk]
# Pre-compile Report
report_clock > reports/report_clock.rpt
report_clock -skew > reports/report_clock_skew.rpt
report_port -verbose > reports/report_clock_verbose.rpt
check_timing
check_design
# crear el no mapeado
write_file -format verilog -hier -out unmapped.v
# Compile/Synthesis
#compile_ultra -no_autoungroup 
compile_ultra
# Post-compile Reports
report_qor > reports/report_qor.rpt
report_constraints -all_violators > reports/report_cons.rpt
report_timing > reports/report_timing.rpt
report_power > reports/report_pow.rpt
# Save Design
write_file -format verilog -hier -out mapped.v
write_sdc mapped.sdc
write_file -format ddc -hier -out mapped.ddc
# Exit
report_constraints -all_violators
return

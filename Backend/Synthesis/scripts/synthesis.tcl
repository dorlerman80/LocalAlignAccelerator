############## Synthesis Script ##############

##############################################
# Set Variables
##############################################

set company    "TSMC"
set designer   "Goel Samuel"
set TSMC65_DIR "/tools/kits/TSMCPDK/TSMC65/TSMCHOME/digital/Front_End/timing_power_noise/NLDM"
set SYNOPSYS   "/eda/synopsys/2020-21/RHELx86/SYN_2020.09-SP2"
set TECH       tsmc65

define_design_lib WORK -path "."
set search_path [concat $search_path "." "$TSMC65_DIR/tcbn65lplvt_220a"]

set plot_command "lpr -Pbp"
set verilogout_no_tri  true
set verilog_show_unconnected_pins  true
set verilog_unconnected_Prefix  true
set hdlout_internal_busses  true
set bus_inference_style  {%s[%d]}
set verilogout_single_bit  false
set bus_naming_style  {%s[%d]}
set TopModule top

###############################################
# Set Technology Libraries
###############################################

set target_library "tcbn65lplvttc1d0.db"
set synthetic_library "dw_foundation.sldb"
set link_library [concat * $target_library $synthetic_library]

###############################################
# Analyze, Elaborate and Linking Design
###############################################

puts -nonewline "\033\[1;31m"; #RED
puts "STARTING ELABORATION"
puts -nonewline "\033\[0m"; #Reset
puts ""

analyze -format sverilog -library WORK {
../../RTL/design_variables.vh \
../../RTL/controller.sv \
../../RTL/sequence_buffer.sv \
../../RTL/matrix_calculation.sv \
../../RTL/processing_unit.sv \
../../RTL/processing_element.sv \
../../RTL/max.sv \
../../RTL/max_of_n.sv \
../../RTL/matrix_memory.sv \
../../RTL/max_registers.sv \
../../RTL/traceback.sv
../../RTL/inverter.sv \
../../RTL/flipflop.sv \
../../RTL/top.sv
}

elaborate ${TopModule} -architecture verilog -library WORK

puts -nonewline "\033\[1;31m"; #RED
puts "FINISHED ELABORATION"
puts -nonewline "\033\[0m"; #Reset
puts ""

# Post Elaborate Reports
set filename "../report/post_elaborate.rpt"
redirect $filename { report_timing -delay_type max }
redirect -append $filename { report_timing -delay_type min }
redirect -append $filename { report_constraint -all_violators -verbose}
redirect -append $filename { report_qor }
redirect -append $filename { check_design }

link

###############################################
# Synthesize Design
###############################################

puts -nonewline "\033\[1;31m"; #RED
puts "STARTING SYNTHESIS"
puts -nonewline "\033\[0m"; #Reset
puts ""

# Read SDC (constraints) File
source ../datain/${TopModule}.sdc

# Create input, output and feed through groups so the tool will focus on each path type separately
set ports_clock_root [filter_collection [get_attribute [get_clocks] sources] object_class==port]
group_path -name IN -from [remove_from_collection [all_inputs] $ports_clock_root]
group_path -name OUT -to [all_outputs]
group_path -name FEEDTHR -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]

# compile_ultra settings
set compile_delete_unloaded_sequential_cells true
set compile_seqmap_propagate_constants false
set compile_seqmap_propagate_high_effort false
set compile_ultra_ungroup_dw false

# Add buffers to prevent direct connection between input/output ports
set compile_fix_multiple_port_nets true

# Enable constant propagation through combinatorial cells (not FFs) -> realistic timing analysis
set case_analysis_with_logic_constants true
set template_separator_style "_"

# Disable register merging, LEC will pass easier
set_register_merging [get_designs ${TopModule}] false

# Define clock gating
set_clock_gating_style -sequential_cell latch -minimum_bitwidth 3
insert_clock_gating -exclude "/*"
insert_clock_gating -through top/matrix_memory


compile -map_effort high -gate_clock

puts -nonewline "\033\[1;31m"; #RED
puts "FINISHED SYNTHESIS"
puts -nonewline "\033\[0m"; #Reset
puts ""

# Post Compile Reports
set filename "../report/post_compile.rpt"
redirect $filename { report_timing -delay_type max }
redirect -append $filename { report_timing -delay_type min }
redirect -append $filename { report_constraint -all_violators -verbose }
redirect -append $filename { report_qor }
redirect -append $filename { check_design }

###############################################
# Scan Chains Configuration
###############################################

puts -nonewline "\033\[1;31m"; #RED
puts "STARTING SCAN CHAINS CONFIGURATION"
puts -nonewline "\033\[0m"; #Reset
puts ""

# Don't ignore shift registers
set_scan_configuration -style multiplexed_flip_flop
set compile_seqmap_identify_shift_registers false

# Create scan ports
create_port -dir in scan_en
create_port -dir in {scan_in1 scan_in2}
create_port -dir out {scan_out1 scan_out2}

# Match scan ports to pins
set_dft_signal -view existing_dft -type MasterClock -port clk -timing {45 55};
set_dft_signal -view existing_dft -type ScanEnable -port scan_en -active_state 1
set_dft_signal -view existing_dft -type ScanDataIn -port {scan_in1 scan_in2}
set_dft_signal -view existing_dft -type ScanDataOut -port {scan_out1 scan_out2}

set_scan_configuration -chain_count 2

# Do scan synthesis
create_test_protocol -infer_asynch
dft_drc -verbose
set_dft_configuration -scan enable
set_dft_configuration -fix_set enable
insert_dft

# Show all chains created in a file name scanfed
write_scan_def -output ../dataout/scandef

puts -nonewline "\033\[1;31m"; #RED
puts "FINISHED SCAN CHAINS CONFIGURATION"
puts -nonewline "\033\[0m"; #Reset
puts ""

# Post Scan Chains Reports
set filename "../report/post_scan_chain.rpt"
redirect $filename { report_timing -delay_type max }
redirect -append $filename { report_timing -delay_type min }
redirect -append $filename { report_constraint -all_violators -verbose }
redirect -append $filename { report_qor }
redirect -append $filename { check_design }

###############################################
# Output Results
###############################################

write -format verilog -hierarchy -output ../dataout/${TopModule}.v
write_sdc -nosplit ../dataout/${TopModule}.sdc
write_test_protocol -out ../dataout/${TopModule}.spf

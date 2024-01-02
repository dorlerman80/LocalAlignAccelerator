##### synthesis script #####
# setup vars
# setup for typical cells
set company    "TSMC"
set designer   "Goel Samuel"
set TSMC65_DIR "/tools/kits/TSMCPDK/TSMC65/TSMCHOME/digital/Front_End/timing_power_noise/NLDM"
set SYNOPSYS "/eda/synopsys/2020-21/RHELx86/SYN_2020.09-SP2"
set TECH        tsmc65

define_design_lib WORK -path "."

set search_path   [concat $search_path "." "$TSMC65_DIR/tcbn65lplvt_220a"]
set plot_command "lpr -Pbp"

set verilogout_no_tri  true
set verilog_show_unconnected_pins  false
set verilog_unconnected_Prefix  true
set hdlout_internal_busses   true
set bus_inference_style  {%s[%d]}
set verilogout_single_bit  false
set bus_naming_style  {%s[%d]}

set TopModule top

###############################################
# List here ALL libraries you are going to use
# no need to add IO PADs libs here
# review library list with your supervisor
###############################################

# target library is standard cell library which will be used to map your const bit design (datain)
# if you have more than one target library, make sure that all libraries are in the process corner (typical or slow fast)

set target_library "tcbn65lplvttc1d0.db"
#set target_library "tcbn65lplvttc.db"

# do not remove dw_foundation.sldb
set synthetic_library "dw_foundation.sldb"
#set synthetic_library "dw01.sldb dw02.sldb dw03.sldb dw04.sldb dw05.sldb dw06.sldb dw_foundation.sldb"

set link_library [concat * $target_library $synthetic_library]

puts "STARTING SYNTHESIS"
puts ""

################################################################ 
# List here your datain RTL files to be synthesized
# defines and constraints files (if exist) should be listed first.
# Top Module file should be just after defines and constants
################################################################

analyze -library WORK -format sverilog {
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

elaborate ${TopModule} -architecture verilog -library WORK -update
current_design ${TopModule}

set filename "../report/post_elaborate.rpt"
redirect $filename { report_timing -delay_type max}
redirect -append $filename { report_timing -delay_type min}
redirect -append $filename { report_area }
redirect -append $filename { report_constraint -all_violators}
redirect -append $filename { check_design }

link

# read SDC
source ../datain/${TopModule}.sdc
current_design ${TopModule}

# create input, output and feed through groups so the tool will focus on each path type separately
set ports_clock_root [filter_collection [get_attribute [get_clocks] sources] object_class==port]
group_path -name OUT -to [all_outputs]
group_path -name IN -from [remove_from_collection [all_inputs] $ports_clock_root]
group_path -name FEEDTHR -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]

# Compile ultra settings
# leave unloaded sequential cells ( FFs )
# 1. good for early stages of design , when some FFs are mistakenly disconnected
# 2. good for last minute ECO when we want you use previously unused FFs
set compile_delete_unloaded_sequential_cells true
set compile_seqmap_propagate_constants false
set compile_seqmap_propagate_high_effort false
set compile_ultra_ungroup_dw false

# enable constant propagation through combinatorial cells (not FFs ) -> realistic timing analysis
set case_analysis_with_logic_constants true
set template_separator_style "_"

# disable register merging, LEC will pass easier
set_register_merging [ get_designs ${TopModule} ] false

# First Compile
puts -nonewline "\033\[1;31m"; #RED
puts "##### STRATING COMPILATION #####"
puts -nonewline "\033\[0m"; #Reset
puts ""
compile
puts -nonewline "\033\[1;31m"; #RED
puts "##### FINISHED COMPILATION #####"
puts -nonewline "\033\[0m"; #Reset
puts ""

# reports

set filename "../report/post_compile.rpt"
redirect $filename { report_timing -delay_type max}
redirect -append $filename { report_timing -delay_type min}
redirect -append $filename { report_area }
redirect -append $filename { report_constraint -all_violators}
redirect -append $filename { check_design }

#enter scan chain, don't ignore Shift-registers

set_scan_configuration -style multiplexed_flip_flop
set compile_seqmap_identify_shift_registers false

# create scan ports
create_port -dir in scan_en
#create_port -dir in scan_reset //not a must have
create_port -dir in {scan_in1 scan_in2 scan_in3}
create_port -dir out {scan_out1 scan_out2 scan_out3}

#set_dft_signal -view spec -type Reset -port scan_reset -active_state 1 //not a must have
set_dft_signal -view existing_dft -type MasterClock -port clk -timing {45 55};
set_dft_signal -view existing_dft -type ScanEnable -port scan_en -active_state 1
set_dft_signal -view existing_dft -type ScanDataIn -port {scan_in1 scan_in2 scan_in3}
set_dft_signal -view existing_dft -type ScanDataOut -port {scan_out1 scan_out2 scan_out3}

set_scan_configuration -chain_count 3

#do scan synthesis
create_test_protocol -infer_asynch
dft_drc -verbose
set_dft_configuration -scan enable
set_dft_configuration -fix_set enable
insert_dft

#show all chains created in a file name scanfed
write_scan_def -output ../dataout/scandef

# reports
set filename "../report/post_scan_chain.rpt"
redirect $filename { report_timing -delay_type max}
redirect -append $filename { report_timing -delay_type min}
redirect -append $filename { report_area }
redirect -append $filename { report_constraint -all_violators}
redirect -append $filename { check_design }

set verilogout_no_tri true
set verilog_show_unconnected_pins false
set verilog_unconnected_Prefix true
set hdlout_internal_busses true
set bus_inference_style {%s[%d]}
set verilogout_single_bit false
set bus_naming_style {%s[%d]}

write -format verilog -hierarchy -output ../dataout/${TopModule}.v
write_sdc -nosplit ../dataout/${TopModule}.sdc
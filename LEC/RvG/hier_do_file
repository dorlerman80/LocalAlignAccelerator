//open a logfile and replace the existing logfile (if exists)
set log file ../logfile/out.log -replace

set compare effort low

read library -Both -Replace -sensitive -Statetable -Liberty /tools/kits/TSMCPDK/TSMC65/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn65lplvt_220a/tcbn65lplvttc.lib

read lef file -Both /tools/kits/TSMCPDK/TSMC65/TSMCHOME/digital/Back_End/lef/tcbn65lplvt_200a/lef/tcbn65lplvt_9lmT2.lef

// CHANGE TO YOURE GOLDEN RTL
//GOLDEN RTL
read design ../datain/RTL/controller.sv ../datain/RTL/sequence_buffer.sv ../datain/RTL/matrix_calculation.sv ../datain/RTL/processing_unit.sv ../datain/RTL/processing_element.sv ../datain/RTL/max.sv ../datain/RTL/max_of_n.sv ../datain/RTL/matrix_memory.sv ../datain/RTL/max_registers.sv ../datain/RTL/traceback.sv ../datain/RTL/design_variables.vh ../datain/RTL/inverter.sv ../datain/RTL/flipflop.sv ../datain/RTL/top.sv -SYS -Golden -continuousassignment Bidirectional -nokeep_unreach -norangeconstraint

//CHANGE TO YOUR REVISED NETLIST
//REVISED NETLIST
read design ../datain/netlist/top.v -Verilog -Revised -sensitive -continuousassignment Bidirectional -nokeep_unreach -nosupply

//CHANGE TO YOURE ADDED SCAN CHAINS
//SCAN CHAINS
//ignore scan insertion - not in the RTL
add pin constraints 0 scan_in1 scan_in2 -Revised
add ignore outputs scan_out1 scan_out2 -Revised
add pin constraints 0 scan_en -Revised

// Disregard gated clocks as a reason for non-equivalance
set flatten model -gated_clock

uniquify -all

// Write Hierarchical dofile with wordlevel (reverse engineering algorithm that takes longer)
write hier_compare dofile hier.do -replace -prepend_string "analyze datapath -module -threads 4 ; analyze datapath -wordlevel -verbose" -usage

set dofile abort OFF
set compare effort low
run hier_compare hier.do
set log file

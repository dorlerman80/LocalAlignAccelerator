
// interface
`include "sw_if.sv"

package sw_pkg;

    // UVM
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // variables definitions
//    `include "../Design/RTL/design_variables.vh"

    // clk
    `include "clk/clk_pkt.sv"
	`include "clk/clk_seq.sv"
    `include "clk/clk_driver.sv"
	`include "clk/clk_cvg.sv"
    `include "clk/clk_monitor.sv"
    `include "clk/clk_sqr.sv"
	`include "clk/clk_agent.sv"
	
	// rst
	`include "rst/rst_pkt.sv"
	`include "rst/rst_seq.sv"
	`include "rst/rst_driver.sv"
	`include "rst/rst_cvg.sv"
	`include "rst/rst_monitor.sv"
	`include "rst/rst_sqr.sv"
	`include "rst/rst_agent.sv"

	// rst & clk coverage collector
	`include "clk_rst_cvg_collector.sv"
	
	// virtual sequence
	`include "virtual_seq.sv"
	
	// env
	`include "sw_env.sv"

endpackage

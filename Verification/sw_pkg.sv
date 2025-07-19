// interface
`include "sw_if.sv"

package sw_pkg;

	// UVM
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	// utils
	`include "verif_utils.vh"

	// variables definitions
	`include "design_variables.sv"
	
	`include "base_seq_in_pkt.sv"

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

	// start
	`include "start/start_pkt.sv"
	`include "start/start_seq.sv"
	`include "start/start_driver.sv"
	`include "start/start_cvg.sv"
	`include "start/start_monitor.sv"
	`include "start/start_sqr.sv"
	`include "start/start_agent.sv"
	
	// score
	`include "score/score_cvg.sv"
	`include "score/score_monitor.sv"
	`include "score/score_agent.sv"
	

	// database
	`include "db_seq_in_pkt.sv"
	`include "db_seq_in_seq.sv"
	`include "db_seq_in_driver.sv"
	`include "db_seq_in_monitor.sv"
	`include "db_seq_in_sqr.sv"
	`include "db_seq_in_agent.sv"
	`include "db_seq_out_monitor.sv"
	`include "db_seq_out_agent.sv"
	
	// query
	`include "qry_seq_in_pkt.sv"
	`include "qry_seq_in_seq.sv"
	`include "qry_seq_in_driver.sv"
	`include "qry_seq_in_monitor.sv"
	`include "qry_seq_in_sqr.sv"
	`include "qry_seq_in_agent.sv"
	`include "qry_seq_out_monitor.sv"
	`include "qry_seq_out_agent.sv"
	
	// overage collector
	`include "clk_rst_cvg_collector.sv"
	`include "control_cvg_collector.sv"
	`include "letters_cvg.sv"

	// virtual sequence
	`include "letters_ctrl.sv"
	`include "virtual_seq.sv"
	
	// ref model
	`include "sw_ref_model.sv"

	// env
	`include "sw_env.sv"
	
	// scoreboard
	`include "sw_scoreboard.sv"
	

endpackage

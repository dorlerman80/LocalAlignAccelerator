class score_agent extends uvm_agent;

	`uvm_component_param_utils(score_agent)

	score_monitor score_monitor_h;
	
	uvm_analysis_port#(int unsigned) score_analysis_port_h;

	function new(string name = "score_agent", uvm_component parent = null);
		super.new(name, parent);
		score_analysis_port_h = new("score_analysis_port_h", this);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		score_monitor_h = score_monitor::type_id::create("score_monitor_h", this);
		`uvm_info("BUILD", {"Created score_monitor_h instance: ", score_monitor_h.get_full_name()}, UVM_HIGH)

		if (get_is_active()) begin 
			`uvm_info("BUILD", {"score_agent is active: ", get_full_name()}, UVM_HIGH)
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		`uvm_info("CONNECT", {"linking db_seq_out_monitor_h to db_out_analysis_port_h"}, UVM_HIGH);
		score_monitor_h.score_analysis_port.connect(score_analysis_port_h);
		
		if (get_is_active()) begin 
			`uvm_info("CONNECT", {"score_agent is connecting components for ", get_full_name()}, UVM_HIGH)
			// Add connection logic here if needed
		end
	endfunction 

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase

endclass : score_agent

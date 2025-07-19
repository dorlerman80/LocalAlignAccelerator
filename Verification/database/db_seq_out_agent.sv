class db_seq_out_agent extends uvm_agent;

	`uvm_component_param_utils(db_seq_out_agent)

	db_seq_out_monitor db_seq_out_monitor_h;
	
	uvm_analysis_port#(out_seq_t) db_out_analysis_port_h;

	function new(string name = "db_seq_out_agent", uvm_component parent = null);
		super.new(name, parent);
		db_out_analysis_port_h = new("db_out_analysis_port_h", this);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		db_seq_out_monitor_h = db_seq_out_monitor::type_id::create("db_seq_out_monitor_h", this);
		`uvm_info("BUILD", {"Created db_seq_out_monitor_h instance: ", db_seq_out_monitor_h.get_full_name()}, UVM_HIGH)

	endfunction

	function void connect_phase(uvm_phase phase);
		`uvm_info("CONNECT", {"linking db_seq_out_monitor_h to db_out_analysis_port_h"}, UVM_HIGH);
		db_seq_out_monitor_h.db_analysis_port.connect(db_out_analysis_port_h);
		
		if (get_is_active()) begin 
			`uvm_info("CONNECT", {"score_agent is connecting components for ", get_full_name()}, UVM_HIGH)
			// Add connection logic here if needed
		end
	endfunction 

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase

endclass : db_seq_out_agent

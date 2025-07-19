class qry_seq_out_agent extends uvm_agent;

	`uvm_component_param_utils(qry_seq_out_agent)

	qry_seq_out_monitor qry_seq_out_monitor_h;
	
	uvm_analysis_port#(out_seq_t) qry_out_analysis_port_h;

	function new(string name = "qry_seq_out_agent", uvm_component parent = null);
		super.new(name, parent);
		qry_out_analysis_port_h = new("qry_out_analysis_port_h", this);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		qry_seq_out_monitor_h = qry_seq_out_monitor::type_id::create("qry_seq_out_monitor_h", this);
		`uvm_info("BUILD", {"Created qry_seq_out_monitor_h instance: ", qry_seq_out_monitor_h.get_full_name()}, UVM_HIGH)

	endfunction

	function void connect_phase(uvm_phase phase);
		`uvm_info("CONNECT", {"linking qry_seq_out_monitor_h to qry_out_analysis_port_h"}, UVM_HIGH);
		qry_seq_out_monitor_h.qry_analysis_port.connect(qry_out_analysis_port_h);
		
		if (get_is_active()) begin 
			`uvm_info("CONNECT", {"score_agent is connecting components for ", get_full_name()}, UVM_HIGH)
			// Add connection logic here if needed
		end
	endfunction 

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase

endclass : qry_seq_out_agent

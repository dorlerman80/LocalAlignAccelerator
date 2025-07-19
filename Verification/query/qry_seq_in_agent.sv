class qry_seq_in_agent extends uvm_agent;
	
	`uvm_component_param_utils(qry_seq_in_agent)
	
	qry_seq_in_sqr qry_seq_in_sqr_h;
	qry_seq_in_driver qry_seq_in_driver_h;
	qry_seq_in_monitor qry_seq_in_monitor_h;
	
	uvm_analysis_port#(seq_t) qry_analysis_port_h;
	
	function new(string name = "qry_seq_in_agent", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		qry_seq_in_monitor_h = qry_seq_in_monitor::type_id::create("qry_seq_in_monitor_h", this);
		qry_analysis_port_h = new("qry_analysis_port_h", this);
		
		if(get_is_active()) begin
			`uvm_info(get_type_name(), {"qry agent is active: ", get_full_name()}, UVM_HIGH);
			qry_seq_in_sqr_h = qry_seq_in_sqr::type_id::create("qry_seq_in_sqr_h", this);
			qry_seq_in_driver_h = qry_seq_in_driver::type_id::create("qry_seq_in_driver_h", this);
			`uvm_info("BUILD", {"Created qry_seq_in_sqr_h instance: ", qry_seq_in_sqr_h.get_full_name()}, UVM_HIGH);
			`uvm_info("BUILD", {"Created qry_seq_in_driver_h instance: ", qry_seq_in_driver_h.get_full_name()}, UVM_HIGH);
		end
		
	endfunction
	
	function void connect_phase(uvm_phase phase);
		`uvm_info("CONNECT", {"linking qry_seq_in_monitor to qry_analysis_port"}, UVM_HIGH);
		qry_seq_in_monitor_h.qry_analysis_port.connect(qry_analysis_port_h);
		
		if(get_is_active()) begin
			`uvm_info("CONNECT", {"linking qry_seq_in_driver to qry_seq_in_sqr"}, UVM_HIGH);
			qry_seq_in_driver_h.seq_item_port.connect(qry_seq_in_sqr_h.seq_item_export);
		end
	endfunction
	
	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH);
	endfunction : start_of_simulation_phase
	
endclass : qry_seq_in_agent

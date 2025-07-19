class db_seq_in_agent extends uvm_agent;

	`uvm_component_param_utils(db_seq_in_agent)

	db_seq_in_sqr db_seq_in_sqr_h;
	db_seq_in_driver db_seq_in_driver_h;
	db_seq_in_monitor db_seq_in_monitor_h;

	// Analysis port for forwarding transactions
	uvm_analysis_port#(seq_t) db_analysis_port_h;

	function new(string name = "db_seq_in_agent", uvm_component parent = null);
		super.new(name, parent);
		db_analysis_port_h = new("db_analysis_port_h", this);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Create the monitor
		db_seq_in_monitor_h = db_seq_in_monitor::type_id::create("db_seq_in_monitor_h", this);
		`uvm_info("BUILD", {"Created db_seq_in_monitor_h instance: ", db_seq_in_monitor_h.get_full_name()}, UVM_HIGH)

		// If the agent is active, create the sequencer and driver
		if(get_is_active()) begin 
			db_seq_in_sqr_h = db_seq_in_sqr::type_id::create("db_seq_in_sqr_h", this);
			db_seq_in_driver_h = db_seq_in_driver::type_id::create("db_seq_in_driver_h", this);
			`uvm_info("BUILD", {"Created db_seq_in_sqr_h instance: ", db_seq_in_sqr_h.get_full_name()}, UVM_MEDIUM)
			`uvm_info("BUILD", {"Created db_seq_in_driver_h instance: ", db_seq_in_driver_h.get_full_name()}, UVM_MEDIUM)
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		// Connect the monitor's analysis port to the agent's analysis port
		db_seq_in_monitor_h.db_analysis_port.connect(db_analysis_port_h);
		
		// Connect the sequencer to the driver if the agent is active
		if(get_is_active()) begin 
			db_seq_in_driver_h.seq_item_port.connect(db_seq_in_sqr_h.seq_item_export);
			`uvm_info("CONNECT", {"Connected db_seq_in_driver_h.seq_item_port to db_seq_in_sqr_h.seq_item_export for ", get_full_name()}, UVM_MEDIUM)
		end
	endfunction 

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH);
	endfunction : start_of_simulation_phase
	
endclass : db_seq_in_agent

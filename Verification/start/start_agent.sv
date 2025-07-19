class start_agent extends uvm_agent;

	`uvm_component_param_utils(start_agent)

	start_sqr start_sequencer_h;
	start_driver start_driver_h;
	start_monitor start_monitor_h;

	function new(string name = "start_agent", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		start_monitor_h = start_monitor::type_id::create("start_monitor_h", this);
		`uvm_info("BUILD", {"Created start_monitor_h instance: ", start_monitor_h.get_full_name()}, UVM_HIGH);

		if (get_is_active()) begin 
			`uvm_info("BUILD", {"Start agent is active: ", get_full_name()}, UVM_HIGH);
			start_sequencer_h = start_sqr::type_id::create("start_sequencer_h", this);
			start_driver_h = start_driver::type_id::create("start_driver_h", this);
			`uvm_info("BUILD", {"Created start_sequencer_h instance: ", start_sequencer_h.get_full_name()}, UVM_HIGH);
			`uvm_info("BUILD", {"Created start_driver_h instance: ", start_driver_h.get_full_name()}, UVM_HIGH);
		end
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		if (get_is_active()) begin 
			start_driver_h.seq_item_port.connect(start_sequencer_h.seq_item_export);
			`uvm_info("CONNECT", {"Connected start_driver_h to start_sequencer_h for ", get_full_name()}, UVM_HIGH);
		end
	endfunction : connect_phase 

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH);
	endfunction : start_of_simulation_phase

endclass : start_agent

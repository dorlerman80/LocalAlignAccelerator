class rst_agent extends uvm_agent;
	
	`uvm_component_param_utils(rst_agent)
	
	rst_sqr rst_sequencer_h;
	rst_driver rst_driver_h;
	rst_monitor rst_monitor_h;
	
	function new(string name = "rst_agent", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rst_monitor_h = rst_monitor::type_id::create("rst_monitor_h", this);
		`uvm_info("BUILD", {"Created rst_monitor_h instance: ", rst_monitor_h.get_full_name()}, UVM_HIGH)
		
		if (get_is_active()) begin
			`uvm_info("BUILD", {"rst agent is active: ", get_full_name()}, UVM_HIGH)
			rst_sequencer_h = rst_sqr::type_id::create("rst_sequencer_h", this);
			rst_driver_h = rst_driver::type_id::create("rst_driver_h", this);
			`uvm_info("BUILD", {"Created rst_sequencer_h instance: ", rst_sequencer_h.get_full_name()}, UVM_HIGH)
			`uvm_info("BUILD", {"Created rst_driver_h instance: ", rst_driver_h.get_full_name()}, UVM_HIGH)
		end
	endfunction
	
	function void connect_phase(uvm_phase phase);
		if (get_is_active()) begin
			rst_driver_h.seq_item_port.connect(rst_sequencer_h.seq_item_export);
			`uvm_info("CONNECT", {"Connected rst_driver_h.seq_item_port to rst_sequencer_h.seq_item_export for ", get_full_name()}, UVM_HIGH)
		end
	endfunction
	
	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase
	
endclass : rst_agent

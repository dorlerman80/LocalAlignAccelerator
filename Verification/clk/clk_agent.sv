class clk_agent extends uvm_agent;

	`uvm_component_param_utils(clk_agent)

	clk_sqr clk_sequencer_h;
	clk_driver clk_driver_h;
	clk_monitor clk_monitor_h;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		clk_monitor_h = clk_monitor::type_id::create("clk_monitor_h", this);
		`uvm_info("BUILD", {"Created clk_monitor_h instance: ", clk_monitor_h.get_full_name()}, UVM_HIGH)

		if (get_is_active()) begin
			clk_sequencer_h = clk_sqr::type_id::create("clk_sequencer_h", this);
			clk_driver_h = clk_driver::type_id::create("clk_driver_h", this);
			`uvm_info("BUILD", {"Created clk_sequencer_h instance: ", clk_sequencer_h.get_full_name()}, UVM_HIGH)
			`uvm_info("BUILD", {"Created clk_driver_h instance: ", clk_driver_h.get_full_name()}, UVM_HIGH)
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		if (get_is_active()) begin
			clk_driver_h.seq_item_port.connect(clk_sequencer_h.seq_item_export);
			`uvm_info("CONNECT", {"Connected clk_driver_h.seq_item_port to clk_sequencer_h.seq_item_export for ", get_full_name()}, UVM_HIGH)
		end
	endfunction

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION", {"Start of simulation for ", get_full_name()}, UVM_HIGH)
	endfunction : start_of_simulation_phase

endclass : clk_agent

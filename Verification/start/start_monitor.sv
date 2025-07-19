class start_monitor extends uvm_monitor;

	`uvm_component_param_utils(start_monitor)

	virtual interface sw_if sw_vif;
	start_cvg start_cvg_h;

	function new(string name = "start_monitor", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Build phase executed for ", get_full_name()}, UVM_HIGH);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "*", "sw_if", sw_vif)) begin
			`uvm_error(get_type_name(), "Could not get sw_if handle from config DB");
		end
		`uvm_info("CONNECT", "Connect phase executed", UVM_HIGH);
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Run phase executed for ", get_full_name()}, UVM_HIGH);
		monitor_start();
	endtask

	virtual task monitor_start();
		int start_duration_ns;

		forever begin
			get_start_duration(start_duration_ns);
			start_cvg_h.start_cg.sample(start_duration_ns);
			`uvm_info("MONITOR", $sformatf("Captured start_duration_ns: %0d ns", start_duration_ns), UVM_MEDIUM);
		end
	endtask

	virtual task get_start_duration(output int start_duration_ns);
		time begin_time_start;
		time end_time_start;
		@(posedge sw_vif.start);
		begin_time_start = $time;

		@(negedge sw_vif.start);
		end_time_start = $time;

		start_duration_ns = int'(end_time_start - begin_time_start);
		`uvm_info("GET_DURATION", $sformatf("Measured start duration: %0d ns", start_duration_ns), UVM_MEDIUM);
	endtask

endclass : start_monitor

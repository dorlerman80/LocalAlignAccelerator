class score_monitor extends uvm_monitor;

	`uvm_component_param_utils(score_monitor)

	virtual sw_if sw_vif;
	score_cvg score_cvg_h;
	
	uvm_analysis_port#(int unsigned) score_analysis_port;

	function new(string name = "score_monitor", uvm_component parent = null);
		super.new(name, parent);
		score_analysis_port = new("score_analysis_port", this);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Build phase executed for ", get_full_name()}, UVM_HIGH)
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "*", "sw_if", sw_vif)) begin
			`uvm_error(get_type_name(), "Could not get sw_if handle from config DB")
		end
		`uvm_info("CONNECT", {"Connect phase executed for ", get_full_name()}, UVM_HIGH)
	endfunction : connect_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Run phase executed for ", get_full_name()}, UVM_HIGH)
		monitor_score();
	endtask

	virtual task monitor_score();
		int unsigned score_value;

		fork begin
			forever begin
				get_score_value(score_value);
				score_cvg_h.score_cg.sample(score_value);
				score_analysis_port.write(score_value);
			end
		end
		join_none

	endtask

	virtual task get_score_value(output int unsigned score_value);
		@(posedge sw_vif.output_valid);
		score_value = sw_vif.score;

		`uvm_info("SCORE", $sformatf("Captured score value: %0d for %s", score_value, get_full_name()), UVM_MEDIUM)
	endtask

endclass : score_monitor

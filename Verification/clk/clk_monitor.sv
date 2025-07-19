class clk_monitor extends uvm_monitor;
	
	`uvm_component_param_utils(clk_monitor)
	
	virtual sw_if sw_vif;
	clk_cvg clk_cvg_h;
	
	function new(string name = "clk_monitor", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Building clk_monitor instance: ", get_full_name()}, UVM_HIGH)
	endfunction : build_phase
	
	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "*", "sw_if", sw_vif)) begin
			`uvm_error(get_type_name(), "Could not get sw_if handle from config DB")
		end else begin
			`uvm_info("CONNECT", {"Connected virtual interface sw_if for ", get_full_name()}, UVM_HIGH)
		end
	endfunction : connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Starting run phase for ", get_full_name()}, UVM_HIGH)
		monitor_clk();
	endtask
	
	virtual task monitor_clk();
		real last_posedge_time = 0.0;
		real last_negedge_time = 0.0;
		real high_time_ns = 0.0;
		real low_time_ns = 0.0;
		real clk_period_ns = 0.0;
		real duty_cycle_percent = 0.0;
		int is_clk_on = 0;
		
		`uvm_info("MONITOR", {"Monitoring clock signals in ", get_full_name()}, UVM_HIGH)
		
		// Initialize times
		last_posedge_time = 0.0;
		last_negedge_time = 0.0;
		
		fork
			// Monitor both edges in a single loop
			forever begin
				@(posedge sw_vif.clk or negedge sw_vif.clk);
				
				if (sw_vif.clk) begin
					// Handle posedge
					if (last_posedge_time != 0.0) begin
						low_time_ns = $realtime - last_negedge_time;
						clk_period_ns = $realtime - last_posedge_time;
						duty_cycle_percent = (high_time_ns * 100.0) / clk_period_ns;
						`uvm_info("DIFF_DUTY_CYCLE", $sformatf("Monitored Duty Cycle (posedge): %0.2f%%", duty_cycle_percent), UVM_HIGH);
					end
					last_posedge_time = $realtime;
					is_clk_on = 1;
					
				end else begin
					// Handle negedge
					if (last_negedge_time != 0.0) begin
						high_time_ns = $realtime - last_posedge_time;
					end
					last_negedge_time = $realtime;
					is_clk_on = 0;
					
					`uvm_info("DIFF_DUTY_CYCLE", $sformatf("Monitored Duty Cycle (negedge): %0.2f%%", duty_cycle_percent), UVM_HIGH);
				end
				
				`uvm_info("SAMPLE", $sformatf("Sampling clk_cg: Period: %0.2f ns, Duty Cycle: %0.2f%%, Is CLK On: %0d for %s",
						clk_period_ns, duty_cycle_percent, is_clk_on, get_full_name()), UVM_HIGH);
				
				// Update coverage
				if (clk_cvg_h != null) begin
					clk_cvg_h.clk_cg.sample(clk_period_ns, duty_cycle_percent, is_clk_on);
				end
			end
		join_none
	endtask
	
endclass: clk_monitor

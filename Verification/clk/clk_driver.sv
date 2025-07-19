class clk_driver extends uvm_driver #(clk_pkt);
	
	`uvm_component_param_utils(clk_driver)
	
	virtual interface sw_if sw_vif;
	
	function new(string name = "clk_driver", uvm_component parent);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Building clk_driver instance: ", get_full_name()}, UVM_HIGH)
	endfunction : build_phase
	
	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "", "sw_if", sw_vif)) begin
			`uvm_error(get_type_name(), "Could not get sw_if handle from config DB")
		end else begin
			`uvm_info("CONNECT", {"Connected virtual interface sw_if for ", get_full_name()}, UVM_HIGH)
		end
	endfunction : connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Starting run phase for ", get_full_name()}, UVM_HIGH)
		run_clk();
	endtask
	
	virtual task run_clk();
		clk_pkt clk_seq_item;
		
		real high_time_ns = 5.0;
		real low_time_ns = 5.0;
		bit clk_on = 1;
		
		fork
			forever begin
				retrieve_clk_pkt(clk_seq_item, clk_on, high_time_ns, low_time_ns);
			end
		join_none
		
		forever begin
			drive_clock(clk_on, high_time_ns, low_time_ns);
		end
	endtask
	
	virtual task retrieve_clk_pkt(output clk_pkt clk_seq_item, output bit clk_on, output real high_time_ns, output real low_time_ns);
		seq_item_port.get_next_item(clk_seq_item);
		clk_on = clk_seq_item.clk_on;
		`uvm_info("RETRIEVE", $sformatf("Retrieved clk_on value: %0b for %s", clk_on, get_full_name()), UVM_HIGH)
		set_high_and_low_time(clk_seq_item.clk_period_ns, clk_seq_item.duty_cycle_percent, high_time_ns, low_time_ns);
		seq_item_port.item_done();
	endtask
	
	// Task for driving the clock
	virtual task drive_clock(input bit clk_on, input real high_time_ns, input real low_time_ns);
		if (clk_on) begin
			sw_vif.clk = 1'b0;
			#(low_time_ns);
			sw_vif.clk = 1'b1;
			#(high_time_ns);
		end else begin
			sw_vif.clk = 1'b0;
			#(low_time_ns);
			#(high_time_ns);
		end
		`uvm_info("DRIVE", $sformatf("Driving clock with high time: %.2f ns, low time: %.2f ns for %s", high_time_ns, low_time_ns, get_full_name()), UVM_HIGH)
	endtask
	
	virtual task set_high_and_low_time(input int clk_period_ns, input int duty_cycle_percent, output real high_time_ns, output real low_time_ns);
		high_time_ns = clk_period_ns * (real'(duty_cycle_percent) / 100.0);
		low_time_ns = clk_period_ns - high_time_ns;
		
		`uvm_info("SET TIME", $sformatf("Calculated high time: %.2f ns, low time: %.2f ns for [SET TIME] %s", high_time_ns, low_time_ns, get_full_name()), UVM_HIGH)
	endtask
	
endclass : clk_driver

class clk_driver extends uvm_driver #(clk_pkt);
	
	`uvm_object_utils(clk_driver)
	
	virtual sw_if sw_vif;
	
	function new(string name = "clk_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase
	
	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "", "sw_vif", sw_vif)) begin
			`uvm_error(get_type_name(), "Could not get sw_if handle from config DB")
		end
	endfunction : connect_phase
	
	virtual task run_phase(uvm_phase phase);
		run_clk();
	endtask
	
	virtual task run_clk();
		clk_pkt clk_seq_item;
		
		int high_time_ns;
		int low_time_ns;
		bit clk_on;
		
		forever begin
			seq_item_port.get_next_item(clk_seq_item);
			set_high_and_low_time(clk_seq_item.clk_period_ns, clk_seq_item.duty_cycle_percent, high_time_ns, low_time_ns);
			seq_item_port.item_done();
		end
		
		forever begin
			if (clk_on) begin
				sw_vif.clk = 1'b0;
				#(low_time_ns);
				sw_vif.clk = 1'b1;
				#(high_time_ns);
			end else begin
				sw_vif.clk = 1'b0;
			end
		end
	endtask
	
	virtual task set_high_and_low_time(input int clk_period_ns, input int duty_cycle_percent, output int high_time_ns, output int low_time_ns);
		high_time_ns = clk_period_ns * duty_cycle_percent / 100;
		low_time_ns = clk_period_ns - high_time_ns;
		
		`uvm_info(get_type_name(), $sformatf("High time: %0d ns, Low time: %0d ns", high_time_ns, low_time_ns), UVM_MEDIUM)
	endtask
	
endclass : clk_driver

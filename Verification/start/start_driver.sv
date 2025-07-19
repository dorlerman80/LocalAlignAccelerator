class start_driver extends uvm_driver #(start_pkt);

	`uvm_component_param_utils(start_driver)

	virtual interface sw_if sw_vif;
	start_pkt start_seq_item;

	function new(string name = "start_driver", uvm_component parent = null);
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
	endfunction: connect_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Run phase executed for ", get_full_name()}, UVM_HIGH);
		run_start();
	endtask

	virtual task run_start();
		int start_duration_ns;
		fork begin
			forever begin
				seq_item_port.get_next_item(start_seq_item);
				start_duration_ns = start_seq_item.start_duration_ns;
				apply_start(start_duration_ns);
				seq_item_port.item_done();
			end
		end
		join_none
	endtask

	virtual task apply_start(input int start_duration_ns);
		wait(sw_vif.rst_n == 1);
		`uvm_info(get_type_name(), $sformatf("Applying start for %0d ns", start_duration_ns), UVM_MEDIUM);
		
		sw_vif.start = 1'b1;
		#(start_duration_ns);
		sw_vif.start = 1'b0;
		`uvm_info(get_type_name(), "Start applied", UVM_MEDIUM);
	endtask

endclass : start_driver

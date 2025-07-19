class rst_driver extends uvm_driver #(rst_pkt);
	
	`uvm_component_param_utils(rst_driver)
	
	virtual interface sw_if sw_vif;
	rst_pkt rst_seq_item;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Building rst_driver instance: ", get_full_name()}, UVM_HIGH)
	endfunction : build_phase
	
	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "*", "sw_if", sw_vif)) begin
			`uvm_error(get_type_name(), "Could not get sw_if handle from config DB")
		end
		//		`uvm_info("CONNECT", {"Connected to sw_if: ", sw_vif.get_full_name()}, UVM_HIGH)
	endfunction : connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Starting run phase for ", get_full_name()}, UVM_HIGH)
		run_rst();
	endtask
	
	virtual task run_rst();
		int rst_duration_ns;
		fork begin
			forever begin
				seq_item_port.get_next_item(rst_seq_item);
				
				rst_duration_ns = rst_seq_item.rst_duration_ns;
				apply_rst(rst_duration_ns);
				
				seq_item_port.item_done();
			end
		end
		join_none
	endtask
	
	virtual task apply_rst(input int rst_duration_ns);
		`uvm_info("RST", {"Applying reset for ", $sformatf("%0d ns", rst_duration_ns)}, UVM_MEDIUM)
		
		sw_vif.rst_n = 1'b0;
		#(rst_duration_ns);
		sw_vif.rst_n = 1'b1;
		`uvm_info("RST", {"Reset applied for ", get_full_name()}, UVM_MEDIUM)
	endtask
	
endclass

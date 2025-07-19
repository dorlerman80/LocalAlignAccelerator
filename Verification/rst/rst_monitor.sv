class rst_monitor extends uvm_monitor;
	
	`uvm_component_param_utils(rst_monitor)
	
	virtual sw_if sw_vif;
	rst_cvg rst_cvg_h;
	
	function new(string name = "rst_monitor", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Created instance of ", get_full_name()}, UVM_HIGH)
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Build phase executed for ", get_full_name()}, UVM_HIGH)
	endfunction: build_phase
	
	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "*", "sw_if", sw_vif)) begin
			`uvm_error("ERROR", "Could not get sw_if handle from config DB")
		end
		`uvm_info("CONNECT", {"Connect phase executed for ", get_full_name()}, UVM_HIGH)
	endfunction: connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Run phase executed for ", get_full_name()}, UVM_HIGH)
		monitor_rst();
	endtask
	
	virtual task monitor_rst();
		int rst_duration_ns;
		
		forever begin
			get_rst_duration(rst_duration_ns);
			rst_cvg_h.rst_cg.sample(rst_duration_ns);
			`uvm_info("RST", $sformatf("Detected reset duration: %0d ns for %s", rst_duration_ns, get_full_name()), UVM_HIGH)
		end
	endtask
	
	virtual task get_rst_duration(output int rst_duration_ns);
		time begin_time_rst;
		time end_time_rst;
		@(negedge sw_vif.rst_n);
		begin_time_rst = $time;
		
		@(posedge sw_vif.rst_n);
		end_time_rst = $time;
		
		rst_duration_ns = int'(end_time_rst - begin_time_rst);
	endtask
	
endclass : rst_monitor

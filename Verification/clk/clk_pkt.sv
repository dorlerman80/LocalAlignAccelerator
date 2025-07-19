class clk_pkt extends uvm_sequence_item;

	`uvm_object_param_utils(clk_pkt)

	int clk_period_ns = 10;
	int duty_cycle_percent = 50;
	bit clk_on;

	function new(string name = "clk_pkt");
		super.new(name);
		`uvm_info("NEW", $sformatf("Creating instance of %s with initial values: clk_period_ns = %0d, duty_cycle_percent = %0d, clk_on = %0b",
			get_full_name(), clk_period_ns, duty_cycle_percent, clk_on), UVM_HIGH)
	endfunction : new
	
endclass : clk_pkt

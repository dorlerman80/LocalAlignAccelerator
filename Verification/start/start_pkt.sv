class start_pkt extends uvm_sequence_item;

	`uvm_object_param_utils(start_pkt)

	int start_duration_ns;

	function new(string name = "start_pkt");
		super.new(name);
		`uvm_info("NEW", {"Created instance of ", get_full_name()}, UVM_HIGH)
	endfunction
endclass : start_pkt

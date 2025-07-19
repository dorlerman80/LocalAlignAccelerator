class rst_pkt extends uvm_sequence_item;

	`uvm_object_param_utils(rst_pkt)

	int rst_duration_ns;

	function new(string name = "rst_pkt");
		super.new(name);
		`uvm_info("NEW", {"Created instance of ", get_full_name()}, UVM_HIGH)
	endfunction

endclass : rst_pkt

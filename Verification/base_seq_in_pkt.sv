class base_seq_in_pkt extends uvm_sequence_item;
	`uvm_object_param_utils(base_seq_in_pkt)

	// Shared random letters field
	rand bit [design_variables::INPUT_WIDTH-1:0] seq_in_letters;

	function new(string name = "base_seq_in_pkt");
		super.new(name);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction
endclass : base_seq_in_pkt

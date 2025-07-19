class db_seq_in_pkt extends base_seq_in_pkt;

	`uvm_object_param_utils(db_seq_in_pkt)

	function new(string name = "db_seq_in_pkt");
		super.new(name);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction

endclass : db_seq_in_pkt

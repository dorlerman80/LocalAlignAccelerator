class virtual_seq extends uvm_component;

	`uvm_component_param_utils(virtual_seq)
	
	rst_seq rst_seq_h;
	clk_seq clk_seq_h;
	
	db_seq_in_seq db_seq_in_seq_h;
	qry_seq_in_seq qry_seq_in_seq_h;
	
	start_seq start_seq_h;
	
	letters_ctrl letters_ctrl_h;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rst_seq_h = rst_seq::type_id::create("rst_seq_h", this);
		clk_seq_h = clk_seq::type_id::create("clk_seq_h", this);
		db_seq_in_seq_h = db_seq_in_seq::type_id::create("db_seq_in_seq_h", this);
		qry_seq_in_seq_h = qry_seq_in_seq::type_id::create("qry_seq_in_seq_h", this);
		start_seq_h = start_seq::type_id::create("start_seq_h", this);
		
		letters_ctrl_h = letters_ctrl::type_id::create("letters_ctrl_h", this);
		
		// Pass references of the FIFOs to the sequences
		db_seq_in_seq_h.db_fifo = letters_ctrl_h.db_fifo;
		qry_seq_in_seq_h.qry_fifo = letters_ctrl_h.qry_fifo;
		
	endfunction

	virtual task start_and_trigger_seq(ref clk_sqr clk_sqr_inst, 
									   ref rst_sqr rst_sqr_inst, 
									   ref db_seq_in_sqr db_seq_in_sqr_inst, 
									   ref qry_seq_in_sqr qry_seq_in_sqr_inst,
									   ref start_sqr start_sqr_inst);
		fork
			begin
				`uvm_info("CONNECT", "clock sequence with clock sequencer", UVM_HIGH)
				clk_seq_h.start(clk_sqr_inst);
			end

			begin
				`uvm_info("CONNECT", "reset sequencer with reset sequence", UVM_HIGH)
				rst_seq_h.start(rst_sqr_inst);
			end
			
			begin
				`uvm_info("CONNECT", "DB sequence with DB sequencer", UVM_HIGH)
				db_seq_in_seq_h.start(db_seq_in_sqr_inst);
			end

			begin
				`uvm_info("CONNECT", "QRY sequence with QRY sequencer", UVM_HIGH)
				qry_seq_in_seq_h.start(qry_seq_in_sqr_inst);
			end
			
			begin
				`uvm_info("CONNECT", "start sequence with start sequencer", UVM_HIGH)
				start_seq_h.start(start_sqr_inst);
			end
			
		join_none
	endtask

endclass : virtual_seq

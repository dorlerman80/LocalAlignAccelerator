class qry_seq_in_monitor extends uvm_monitor;
	
	`uvm_component_param_utils(qry_seq_in_monitor)
	
	virtual sw_if sw_vif;
	
	int seq_num_letters;
	
	seq_t query_seq;  // Use typedef for the array declaration
	uvm_analysis_port#(seq_t) qry_analysis_port;
	
	function new(string name = "qry_seq_in_monitor", uvm_component parent = null);
		super.new(name, parent);
		qry_analysis_port = new("qry_analysis_port", this);
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
		
		// Retrieve seq_num_letters from the config_db
		if (!uvm_config_db#(int)::get(null, "", "seq_num_letters", seq_num_letters)) begin
			`uvm_error("CFG_ERR", "Failed to get seq_num_letters from config_db");
		end else begin
			`uvm_info("CONNECT", {"Retrieved seq_num_letters: ", seq_num_letters}, UVM_HIGH);
		end
	endfunction: connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Run phase executed for ", get_full_name()}, UVM_HIGH);
		monitor_query_letters();
	endtask
	
	virtual task monitor_query_letters();
		qry_seq_in_pkt seq_in_pkt;
		
		int pkt_num_letters = design_variables::INPUT_WIDTH / design_variables::LETTER_WIDTH;
		int num_transactions = seq_num_letters / pkt_num_letters;
		
		`uvm_info("MONITOR", $sformatf("Total packets to monitor: %0d", num_transactions), UVM_HIGH);
		
		fork begin
			forever begin
				wait (sw_vif.rst_n == 1);
				`uvm_info("MONITOR", "Waiting for reset to deassert...", UVM_HIGH);
				
				// Wait for the falling edge of 'ready' and 'start' that symbolizes a handshake
				wait (sw_vif.ready == 1 && sw_vif.start == 1);
				wait (sw_vif.ready == 0 && sw_vif.start == 0); // TODO: delete this later
				`uvm_info("MONITOR", "Handshake detected, starting to monitor query letters...", UVM_HIGH);
				
				for (int i = 0; i < num_transactions; i++) begin
					@(negedge sw_vif.clk);
					query_seq.data[i] = sw_vif.query_seq_in;
					`uvm_info("MONITOR", $sformatf("Captured query letter for transaction %0d: %0h", i, query_seq.data[i]), UVM_HIGH);
				end
				
				query_seq.typ = 0;
				qry_analysis_port.write(query_seq);
				`uvm_info("MONITOR", "Sent captured query sequence to analysis port.", UVM_HIGH);
			end
		end
		join_none
		
	endtask
	
endclass: qry_seq_in_monitor

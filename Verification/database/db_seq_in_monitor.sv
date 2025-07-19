class db_seq_in_monitor extends uvm_monitor;
	
	`uvm_component_param_utils(db_seq_in_monitor)
	
	virtual sw_if sw_vif;
	
	int seq_num_letters;
	
	seq_t database_seq;  // Use typedef for the array declaration
	
	uvm_analysis_port#(seq_t) db_analysis_port;
	
	function new(string name = "db_seq_in_monitor", uvm_component parent = null);
		super.new(name, parent);
		db_analysis_port = new("db_analysis_port", this);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Build phase executed for ", get_full_name()}, UVM_HIGH);
	endfunction: build_phase
	
	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "*", "sw_if", sw_vif)) begin
			`uvm_error("CFG_ERR", {"Could not get sw_if handle from config DB for ", get_full_name()});
		end
		
		// Retrieve seq_num_letters from the config_db
		if (!uvm_config_db#(int)::get(null, "", "seq_num_letters", seq_num_letters)) begin
			`uvm_error("CFG_ERR", {"Failed to get seq_num_letters from config_db for ", get_full_name()});
		end else begin
			`uvm_info("CONNECT", {"Retrieved seq_num_letters: ", $sformatf("%0d", seq_num_letters), " for ", get_full_name()}, UVM_HIGH);
		end
	endfunction: connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", $sformatf("Run phase executed for %s", get_full_name()), UVM_HIGH);
		monitor_database_letters();
	endtask
	
	virtual task monitor_database_letters();
		db_seq_in_pkt seq_in_pkt;
		
		int pkt_num_letters = design_variables::INPUT_WIDTH / design_variables::LETTER_WIDTH;
		int num_transactions = seq_num_letters / pkt_num_letters;
		
		`uvm_info("MONITOR", {"Monitoring database letters, num_transactions: ", $sformatf("%0d", num_transactions), " for ", get_full_name()}, UVM_HIGH);
		
		fork begin
			forever begin
				wait (sw_vif.rst_n == 1);
				
				// Wait for the falling edge of 'ready' and 'start' that symbolizes a handshake
				wait (sw_vif.ready == 1 && sw_vif.start == 1);
				wait (sw_vif.ready == 0 && sw_vif.start == 0);
				
				for (int i = 0; i < num_transactions; i++) begin
					@(negedge sw_vif.clk);
					database_seq.data[i] = sw_vif.database_seq_in;
				end
				
				// Send the collected database sequence via the analysis port
				database_seq.typ = 1;
				db_analysis_port.write(database_seq);
				`uvm_info("MONITOR", {"Sent database sequence via analysis port for ", get_full_name()}, UVM_HIGH);
			end
		end
		join_none
		
	endtask : monitor_database_letters
	
endclass: db_seq_in_monitor

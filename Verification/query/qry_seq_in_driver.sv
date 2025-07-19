class qry_seq_in_driver extends uvm_driver #(qry_seq_in_pkt);
	
	`uvm_component_param_utils(qry_seq_in_driver)
	
	virtual interface sw_if sw_vif;
	
	int seq_num_letters;
	
	function new(string name = "qry_seq_in_driver", uvm_component parent);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD", {"Building ", get_full_name()}, UVM_HIGH);
	endfunction : build_phase
	
	virtual function void connect_phase(uvm_phase phase);
		if (!uvm_config_db#(virtual sw_if)::get(this, "", "sw_if", sw_vif)) begin
			`uvm_error(get_type_name(), "Could not get sw_if handle from config DB");
		end
		
		// Retrieve full_seq_length from the config_db
		if (!uvm_config_db#(int)::get(null, "", "seq_num_letters", seq_num_letters)) begin
			`uvm_error("CFG_ERR", "Failed to get seq_num_letters from config_db");
		end else begin
			`uvm_info("CONNECT", {"Retrieved seq_num_letters: ", seq_num_letters}, UVM_HIGH);
		end
	endfunction : connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Starting run phase for ", get_full_name()}, UVM_HIGH);
		send_query_letters();
	endtask
	
	virtual task send_query_letters();
		qry_seq_in_pkt seq_in_pkt;
		
		int pkt_num_letters = design_variables::INPUT_WIDTH / design_variables::LETTER_WIDTH;
		int num_transactions = seq_num_letters / pkt_num_letters;

		`uvm_info("SEND_QUERY", $sformatf("Total packets to send: %0d", seq_num_letters), UVM_HIGH);
		
		fork begin
			forever begin
				wait (sw_vif.rst_n == 1);
				`uvm_info("SEND_QUERY", "Waiting for the reset to deassert...", UVM_HIGH);

				// Wait for the falling edge of 'ready' that symbolizes a handshake
				@(negedge sw_vif.ready);
				`uvm_info("SEND_QUERY", "Ready signal detected, beginning packet transmission...", UVM_HIGH);
			
				for (int i = 0; i < num_transactions; i++) begin
					@(negedge sw_vif.clk);
					
					seq_item_port.get_next_item(seq_in_pkt);
					`uvm_info("SEND_PKT", $sformatf("START sending query packet number %0d", i), UVM_HIGH);
					
					sw_vif.query_seq_in = seq_in_pkt.seq_in_letters;
					
					seq_item_port.item_done();
					`uvm_info("SEND_PKT", $sformatf("END sending query packet number %0d", i), UVM_HIGH);
				end
			end
		end
		join_none
	endtask
	
endclass : qry_seq_in_driver

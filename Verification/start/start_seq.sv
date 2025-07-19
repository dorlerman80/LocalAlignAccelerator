class start_seq extends uvm_sequence #(start_pkt);
	`uvm_object_param_utils(start_seq)
	
	// Parameters for the sequence
	int unsigned start_pkt_num;
	
	// Enum for configuration values
	start_cfg_enum start_cfg_val;
	
	function new(string name = "start_sequence");
		super.new(name);
		
		// Retrieve start_pkt_num from the config_db
		if (!uvm_config_db#(int)::get(null, "*", "start_pkt_num", start_pkt_num)) begin
			`uvm_error("CFG_ERR", "Failed to get start_pkt_num from config_db");
		end else begin
			`uvm_info("CFG_INFO", $sformatf("Retrieved start_pkt_num: %0d", start_pkt_num), UVM_HIGH);
		end
		
		// Retrieve the configuration from the config_db
		if (!uvm_config_db#(start_cfg_enum)::get(null, "", "start_cfg_val", start_cfg_val)) begin
			`uvm_error("CFG_ERR", "Failed to get start_cfg_val from config_db");
		end else begin
			`uvm_info("CFG_INFO", $sformatf("Retrieved start_cfg_val: %s", start_cfg_val.name()), UVM_HIGH);
		end
	endfunction
	
	virtual task body();
		`uvm_info("SEQ_BODY", "Starting to send start packets", UVM_HIGH);
		send_start_pkts(start_pkt_num, start_cfg_val);
	endtask
	
	virtual task send_start_pkts(input int start_pkt_num, input start_cfg_enum start_cfg_val);
		start_pkt pkt;
		int delay;
		
		for (int i = 0; i < start_pkt_num; i++) begin
			pkt = start_pkt::type_id::create($sformatf("start_pkt_%0d", i));
			
			`uvm_info("PKT_SEND", $sformatf("Sending packet: %s", pkt.get_full_name()), UVM_HIGH);
			start_item(pkt);
			set_start_pkt(pkt);
			finish_item(pkt);
			
			delay = $urandom_range(300, 4000);
			`uvm_info("PKT_DELAY", $sformatf("Delaying for %0d ns before sending next packet", delay), UVM_HIGH);
			#delay;
		end
	endtask
	
	virtual task set_start_pkt(start_pkt pkt);
		`uvm_info("SET_PKT", $sformatf("Setting packet duration based on configuration: %s", start_cfg_val.name()), UVM_HIGH);
		
		case (start_cfg_val)
			START_CFG_DEFAULT: begin
				pkt.start_duration_ns = 10;
				`uvm_info("SET_PKT", "Using default start duration: 10 ns", UVM_HIGH);
			end
			
			DIFF_DURATION_START: begin
				int min_start_duration_ns, max_start_duration_ns;
				if (!uvm_config_db#(int)::get(null, "*", "min_start_duration_ns", min_start_duration_ns))
					min_start_duration_ns = 10;
				
				if (!uvm_config_db#(int)::get(null, "*", "max_start_duration_ns", max_start_duration_ns))
					max_start_duration_ns = 100;
				
				pkt.start_duration_ns = $urandom_range(min_start_duration_ns, max_start_duration_ns);
				`uvm_info("SET_PKT", $sformatf("Using random start duration: %0d ns", pkt.start_duration_ns), UVM_HIGH);
			end
			
			default: begin
				`uvm_error("CFG_ERR", "Must set one of the configuration values");
			end
		endcase
	endtask
	
endclass : start_seq

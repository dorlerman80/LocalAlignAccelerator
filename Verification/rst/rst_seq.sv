class rst_seq extends uvm_sequence #(rst_pkt);
	`uvm_object_param_utils(rst_seq)

	// Parameters for the sequence
	int unsigned rst_pkt_num;

	// Enum for configuration values
	rst_cfg_enum rst_cfg_val;

	function new(string name = "rst_sequence");
		super.new(name); 

		// Retrieve rst_pkt_num from the config_db
		if (!uvm_config_db#(int)::get(null, "*", "rst_pkt_num", rst_pkt_num)) begin
			`uvm_error("CFG_ERR", "Failed to get rst_pkt_num from config_db")
		end else begin
			`uvm_info("NEW", {"rst_pkt_num set to ", $sformatf("%0d", rst_pkt_num)}, UVM_HIGH)
		end

		// Retrieve the configuration from the config_db
		if (!uvm_config_db#(rst_cfg_enum)::get(null, "", "rst_cfg_val", rst_cfg_val)) begin
			`uvm_error("CFG_ERR", "Failed to get rst_cfg_val from config_db")
		end else begin
			`uvm_info("NEW", {"rst_cfg_val set to ", $sformatf("%0d", rst_cfg_val)}, UVM_HIGH)
		end
	endfunction

	virtual task body();
		`uvm_info("RUN", {"Starting body of sequence for ", get_full_name()}, UVM_HIGH)
		send_rst_pkts(rst_pkt_num, rst_cfg_val);
	endtask

	virtual task send_rst_pkts(input int rst_pkt_num, input rst_cfg_enum rst_cfg_val);
		rst_pkt pkt;
		int delay;

		for (int i = 0; i < rst_pkt_num; i++) begin
			pkt = rst_pkt::type_id::create($sformatf("rst_pkt_%0d", i));

			start_item(pkt);
			set_rst_pkt(pkt);
			finish_item(pkt);

			`uvm_info("RUN", {"Sent reset packet: ", pkt.get_full_name()}, UVM_HIGH)

			if (rst_cfg_val != RST_CFG_DEFAULT) begin
				delay = $urandom_range(300, 4000);
				#delay;
				`uvm_info("RUN", {"Delay after sending packet: ", $sformatf("%0d ns", delay)}, UVM_HIGH)
			end
		end
	endtask

	virtual task set_rst_pkt(rst_pkt pkt);
		`uvm_info("RUN", {"Setting reset packet configuration for ", pkt.get_full_name()}, UVM_HIGH)

		case (rst_cfg_val)
			RST_CFG_DEFAULT: begin
				pkt.rst_duration_ns = 10;
				`uvm_info("RUN", {"RST_CFG_DEFAULT: Duration set to 10 ns for ", pkt.get_full_name()}, UVM_HIGH)
			end

			DIFF_DURATION: begin
				int min_rst_duration_ns, max_rst_duration_ns;
				if (!uvm_config_db#(int)::get(null, "*", "min_rst_duration_ns", min_rst_duration_ns)) min_rst_duration_ns = 10;
				if (!uvm_config_db#(int)::get(null, "*", "max_rst_duration_ns", max_rst_duration_ns)) max_rst_duration_ns = 100;
				pkt.rst_duration_ns = $urandom_range(min_rst_duration_ns, max_rst_duration_ns);
				`uvm_info("RUN", {"DIFF_DURATION: Duration set to ", $sformatf("%0d ns", pkt.rst_duration_ns), " for ", pkt.get_full_name()}, UVM_HIGH)
			end

			default: begin
				`uvm_error("CFG_ERR", "Must set one of the configuration values")
			end
		endcase
	endtask
	
endclass : rst_seq

class qry_seq_out_monitor extends uvm_monitor;
	
	`uvm_component_param_utils(qry_seq_out_monitor)
	
	virtual sw_if sw_vif;
	
	out_seq_t qry_out;
	
	uvm_analysis_port#(out_seq_t) qry_analysis_port;
	
	function new(string name = "qry_seq_out_monitor", uvm_component parent = null);
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
	endfunction: connect_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("RUN", {"Run phase executed for ", get_full_name()}, UVM_HIGH);
		monitor_query_letters_out();
	endtask
	
	virtual task monitor_query_letters_out();
		
		
		fork begin
			bit [2:0] qry_output_letters[$];
			
			forever begin
				
				@(posedge sw_vif.output_valid);
				wait (sw_vif.output_valid == 1 && sw_vif.query_seq_out == START_OUTPUT);
				qry_output_letters = {};
				
				while(sw_vif.output_valid) begin
					@(negedge sw_vif.clk);
					if (sw_vif.output_valid == 1) begin
						qry_output_letters.push_back(sw_vif.query_seq_out);
					end
				end
				
				// Print the collected letters in binary (like FIFO print)
				`uvm_info("MONITOR", "Collected sequence in binary:", UVM_HIGH);
				foreach (qry_output_letters[i]) begin
					`uvm_info("MONITOR", $sformatf("qry_output_letters[%0d] = %b", i, qry_output_letters[i]), UVM_HIGH);
				end
				
				qry_out.out_letters = qry_output_letters;
				qry_analysis_port.write(qry_out);
				
				`uvm_info("MONITOR", "Sent captured query sequence to analysis port.", UVM_HIGH);
			end
		end
		join_none
		
	endtask
	
endclass: qry_seq_out_monitor

`include "verif_utils.vh"
import verif_utils::*;

class clk_seq extends uvm_sequence #(clk_pkt);
	`uvm_object_param_utils(clk_seq)
	
	// Parameters for the sequence
	int unsigned clk_pkt_num;
	
	// Enum for configuration values
	clk_cfg_enum clk_cfg_val;
	
	function new(string name = "clk_sequence");
		super.new(name);
		
		// Retrieve clk_pkt_num from the config_db
		if (!uvm_config_db#(int)::get(null, "*", "clk_pkt_num", clk_pkt_num)) begin
			`uvm_error("CFG_ERR", "Failed to get clk_pkt_num from config_db")
		end
		
		// Retrieve the configuration from the config_db
		if (!uvm_config_db#(clk_cfg_enum)::get(null, "*", "clk_cfg_val", clk_cfg_val)) begin
			`uvm_error("CFG_ERR", "Failed to get clk_cfg_val from config_db")
		end
		
		`uvm_info("NEW", {"Created instance of ", get_full_name(), " with clk_pkt_num = ", $sformatf("%0d", clk_pkt_num), ", clk_cfg_val = ", $sformatf("%0d", clk_cfg_val)}, UVM_HIGH);
	endfunction : new
	
	virtual task body();
		send_clk_pkts(clk_pkt_num, clk_cfg_val);
	endtask
	
	virtual task send_clk_pkts(input int clk_pkt_num, clk_cfg_enum clk_cfg_val);
		clk_pkt pkt;
		int delay;
		
		`uvm_info("SEQ_INFO", $sformatf("Sending %0d Clk Packets with config %0d", clk_pkt_num, clk_cfg_val), UVM_HIGH)
		
		for (int i = 0; i < clk_pkt_num; i++) begin
			pkt = clk_pkt::type_id::create($sformatf("clk_pkt_%0d", i));
			
			start_item(pkt);
			set_clk_pkt(pkt, clk_cfg_val);
			finish_item(pkt);
			
			if(clk_cfg_val != CLK_CFG_DEFAULT) begin
				delay = $urandom_range(300, 4000);
				#delay;
			end
		end
	endtask
	
	virtual task set_clk_pkt(clk_pkt pkt, clk_cfg_enum clk_cfg_val);
		int min_period, max_period;
		int min_duty_cycle, max_duty_cycle;
		
		case (clk_cfg_val)
			CLK_CFG_DEFAULT: begin
				pkt.clk_period_ns = 10;
				pkt.duty_cycle_percent = 50;
				pkt.clk_on = 1;
			end
			
			RND_GATED_CLK: begin
				pkt.clk_period_ns = 10;
				pkt.duty_cycle_percent = 50;
				pkt.clk_on = $urandom_range(0, 1);
			end
			
			DIFF_PERIOD: begin
				if (!uvm_config_db#(int)::get(null, "*", "min_period", min_period)) min_period = 2;
				if (!uvm_config_db#(int)::get(null, "*", "max_period", max_period)) max_period = 300;
				
				pkt.clk_period_ns = $urandom_range(min_period, max_period);
				pkt.duty_cycle_percent = 50;
				pkt.clk_on = 1;
			end
			
			DIFF_DUTY_CYCLE: begin
				if (!uvm_config_db#(int)::get(null, "*", "min_duty_cycle", min_duty_cycle)) min_duty_cycle = 30;
				if (!uvm_config_db#(int)::get(null, "*", "max_duty_cycle", max_duty_cycle)) max_duty_cycle = 70;
				
				pkt.clk_period_ns = 10;
				pkt.duty_cycle_percent = $urandom_range(min_duty_cycle, max_duty_cycle);
				`uvm_info("DIFF_DUTY_CYCLE", $sformatf("Chosen Duty Cycle: %0d%%", pkt.duty_cycle_percent), UVM_HIGH);
				pkt.clk_on = 1;
			end
			
			DIFF_BOTH: begin
				if (!uvm_config_db#(int)::get(null, "*", "min_period", min_period)) min_period = 2;
				if (!uvm_config_db#(int)::get(null, "*", "max_period", max_period)) max_period = 300;
				if (!uvm_config_db#(int)::get(null, "*", "min_duty_cycle", min_duty_cycle)) min_duty_cycle = 30;
				if (!uvm_config_db#(int)::get(null, "*", "max_duty_cycle", max_duty_cycle)) max_duty_cycle = 70;
				
				pkt.clk_period_ns = $urandom_range(min_period, max_period);
				pkt.duty_cycle_percent = $urandom_range(min_duty_cycle, max_duty_cycle);
				pkt.clk_on = 1;
			end
			
			DIFF_BOTH_CLK_RND: begin
				if (!uvm_config_db#(int)::get(null, "*", "min_period", min_period)) min_period = 2;
				if (!uvm_config_db#(int)::get(null, "*", "max_period", max_period)) max_period = 300;
				if (!uvm_config_db#(int)::get(null, "*", "min_duty_cycle", min_duty_cycle)) min_duty_cycle = 30;
				if (!uvm_config_db#(int)::get(null, "*", "max_duty_cycle", max_duty_cycle)) max_duty_cycle = 70;
				
				pkt.clk_period_ns = $urandom_range(min_period, max_period);
				pkt.duty_cycle_percent = $urandom_range(min_duty_cycle, max_duty_cycle);
				pkt.clk_on = $urandom_range(0, 1);
			end
			
			default: begin
				`uvm_error("CFG_ERR", "Must set one of the configuration values")
			end
		endcase
	endtask
	
endclass : clk_seq

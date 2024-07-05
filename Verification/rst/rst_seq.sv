`include "verif_utils.vh"
import verif_utils::*;
class rst_seq extends uvm_sequence #(rst_pkt);
    `uvm_object_utils(rst_seq)

    // Parameters for the sequence
    int unsigned rst_pkt_num;

    // Enum for configuration values
    rst_cfg_enum rst_cfg_val;

    function new(string name = "rst_sequence");
        super.new(name); 
        
        // Retrieve rst_pkt_num from the config_db
        if (!uvm_config_int::get(null, "*", "rst_pkt_num", rst_pkt_num)) begin
            `uvm_error("CFG_ERR", "Failed to get rst_pkt_num from config_db")
        end

        // Retrieve the configuration from the config_db
        if (!uvm_config_db#(rst_cfg_enum)::get(null, "", "rst_cfg_val", rst_cfg_val)) begin
            `uvm_error("CFG_ERR", "Failed to get rst_cfg_val from config_db")
        end
    endfunction

    virtual task body();
        send_rst_pkts(rst_pkt_num, rst_cfg_val);
    endtask

    virtual task send_rst_pkts(input int unsigned rst_pkt_num, input rst_cfg_enum rst_cfg_val);
        rst_pkt pkt;

        for (int i = 0; i < rst_pkt_num; i++) begin
            
            pkt = rst_pkt::type_id::create($sformatf("rst_pkt_%0d", i));

            start_item(pkt);
            set_rst_pkt(pkt);
            finish_item(pkt);

            if (rst_cfg_val != RST_CFG_DEFAULT) begin
                int unsigned delay;
                delay = $urandom_range(300, 4000);
                #delay;
            end
        end
    endtask

    virtual task set_rst_pkt(rst_pkt pkt);

        case (rst_cfg_val)
			RST_CFG_DEFAULT: begin
                pkt.rst_duration_ns = 20;
            end

            DIFF_DURATION: begin
                int unsigned min_rst_duration_ns , max_rst_duration_ns;
//                if (!uvm_config_int::get(this, "*", "min_rst_duration_ns", min_rst_duration_ns)) min_rst_duration_ns = 10;
//                if (!uvm_config_int::get(this, "*", "max_rst_duration_ns", max_rst_duration_ns)) max_rst_duration_ns = 100;
				
				min_rst_duration_ns = 10;
				max_rst_duration_ns = 100;
                pkt.rst_duration_ns = $urandom_range(min_rst_duration_ns, max_rst_duration_ns);
            end

            default: begin
                `uvm_error("CFG_ERR", "Must set one of the configuration values")
            end
        endcase
    endtask
    
endclass : rst_seq

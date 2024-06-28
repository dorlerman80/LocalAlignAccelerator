class rst_seq extends uvm_sequence #(rst_pkt);
    `uvm_object_utils(rst_seq)

    function new(string name = "rst_sequence");
        super.new(name); 
        // uvm_config_int::get(null, "*", "rst_pkt_num", clk_pkt_num);
        // uvm_config_int::get(null, "*", "is_default_clk_seq", is_default_seq);
    endfunction


    
endclass
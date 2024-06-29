class clk_rst_test extends base_test;

    `uvm_component_utils(clk_rst_test)  

    function new(string name, uvm_component parent);
       super.new(name,parent);
    endfunction:new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set(null, "*", "rst_pkt_num", 1);
        uvm_config_int::set(null, "*", "clk_pkt_num", 30);
        uvm_config_int::set(null, "*", "clk_cfg_val", DEFAULT);
        uvm_config_int::set(null, "*", "rst_cfg_val", DEFAULT);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction 

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

endclass : clk_rst_test

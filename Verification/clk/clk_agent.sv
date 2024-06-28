class clk_agent extends uvm_agent;
    
    `uvm_component_utils(clk_agent)

    clk_sqr sequencer;
    clk_driver driver;
    clk_monitor monitor;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(get_is_active()) begin 
            sequencer = clk_sqr::type_id::create("sequencer",this);
            driver = clk_driver::type_id::create("driver",this);
            monitor = clk_monitor::type_id::create("monitor",this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction 

endclass : clk_agent

    



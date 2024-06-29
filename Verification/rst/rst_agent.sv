class rst_agent extends uvm_agent;
    
    `uvm_component_utils(rst_agent)

    rst_sqr sequencer;
    rst_driver driver;
    rst_monitor monitor;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = rst_sqr::type_id::create("sequencer",this);
        driver = rst_driver::type_id::create("driver",this);
        monitor = rst_monitor::type_id::create("monitor",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction 

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()} , UVM_HIGH)
    endfunction : start_of_simulation_phase

endclass : rst_agent

    



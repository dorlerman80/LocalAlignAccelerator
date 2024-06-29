class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    sw_env sw_env_h;

    function new(string name, uvm_component parent);
       super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       sw_env_h = sw_env::type_id::create("sw_env_h",this);
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
         uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    task run_phase(uvm_phase phase);

        phase.raise_objection(.obj(this));

        sw_env_h.v_seq.start_and_trigger_seq(sw_env_h.clk_agent_h.sequencer, sw_env_h.rst_agent_h.sequencer)
        #1000

        phase.drop_objection(.obj(this));
        
    endtask

endclass:base_test

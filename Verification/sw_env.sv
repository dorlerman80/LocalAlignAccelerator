class sw_env extends uvm_env;

  `uvm_component_utils(sw_env)

  clk_agent clk_agent_h;
  rst_agent rst_agent_h;
  clk_rst_cvg_collector clk_rst_cov_h;

  virtual_seq v_seq;
 

  function new(string name,uvm_component parent);
      super.new(name,parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    clk_agent_h = clk_agent::type_id::create("clk_agent_h", this);
    reset_agent_h = rst_agent::type_id::create("reset_agent_h", this);
    clk_rst_cov_h = clk_rst_cvg_collector::type_id::create("clk_rst_cov_h", this);
    v_seq = virtual_seq::type_id::create("v_seq", this);
  endfunction



  function void connect_phase(uvm_phase phase);
      super.build_phase(phase);
      rst_agent_h.monitor.rst_cvg_h = clk_rst_cov_h.rst_cvg_h;
      clk_agent_h.monitor.clk_cvg_h = clk_rst_cov_h.clk_cvg_h;
  endfunction


  function void start_of_simulation_phase(uvm_phase phase);
     
  `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()} , UVM_HIGH)
  
  endfunction : start_of_simulation_phase

endclass : sw_env




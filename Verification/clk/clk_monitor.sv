class clk_monitor extends uvm_monitor;
    
    `uvm_object_utils(clk_monitor)

    virtual sw_if sw_vif;
    clk_cvg clk_cvg_h;

    function new(string name = "clk_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual sw_if)::get(this, "", "sw_vif", sw_vif)) begin
            `uvm_error(get_type_name(), "Could not get sw_if handle from config DB")
        end
    endfunction: connect_phase

    virtual task run_phase(uvm_phase phase);
        monitor_clk();
    endtask

    virtual task monitor_clk();

        time last_posedge_time = 0;
        time last_negedge_time = 0;
        int high_time_ns;
        int low_time_ns;
        int clk_period_ns;
        int duty_cycle_percent;
        int is_clk_on;

        forever begin
            is_clk_on = 0;
            get_clk_time_info(sw_vif.clk, last_posedge_time, last_negedge_time, high_time_ns, 
                                low_time_ns, clk_period_ns, duty_cycle_percent, is_clk_on);

            clk_cvg_h.clk_cg.sample(clk_period_ns, duty_cycle_percent, is_clk_on); // TODO: how to implement coverage
        end

    endtask

    virtual task get_clk_time_info(input clk, inout time last_posedge_time, inout time last_negedge_time, 
                                   output time high_time_ns, output time low_time_ns, 
                                   output time clk_period_ns, output int duty_cycle_percent, inout int is_clk_on);
        @ (posedge clk);
        is_clk_on = 1;
        if (last_posedge_time != 0) begin
            low_time_ns = int'($time - last_negedge_time);
            clk_period_ns = int'($time - last_posedge_time);
            duty_cycle_percent = (high_time_ns * 100) / clk_period_ns;
        end
        last_posedge_time = $time;

        @ (negedge clk);
        if (last_negedge_time != 0) begin
            high_time_ns = int'($time - last_posedge_time);
        end
        last_negedge_time = $time;


        `uvm_info(get_type_name(), $sformatf("High time: %0d ns, Low time: %0d ns, Clock period: %0d ns, Duty cycle: %0d%%",
               high_time_ns, low_time_ns, clk_period_ns, duty_cycle_percent), UVM_MEDIUM);
    endtask

endclass: clk_monitor
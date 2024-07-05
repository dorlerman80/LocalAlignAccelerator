class rst_monitor extends uvm_monitor;
    
    `uvm_object_utils(rst_monitor)

    virtual sw_if sw_vif;
    rst_cvg rst_cvg_h;

    function new(string name = "rst_monitor", uvm_component parent = null);
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
        monitor_rst();
    endtask

    virtual task monitor_rst();
        int rst_duration_ns;

        forever begin
            get_rst_duration(rst_duration_ns);
            rst_cvg_h.rst_cg.sample(rst_duration_ns);
        end

    endtask

    virtual task get_rst_duration(input rst_duration_ns);
		time begin_time_rst;
		time end_time_rst;
        @(negedge sw_vif.rst_n);
        begin_time_rst = $time;

        @(posedge sw_vif.rst_n);
        end_time_rst = $time;

        rst_duration_ns = int'(end_time_rst - begin_time_rst);
            
    endtask

endclass: rst_monitor
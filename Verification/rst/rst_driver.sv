class rst_driver extends uvm_driver #(rst_pkt);
    
    `uvm_object_utils(rst_driver)

    virtual sw_if sw_vif;

    function new(string name, uvm_component parent);
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
        run_rst();
    endtask

    virtual task run_rst();
        rst_pkt rst_seq_item;

        int rst_duration_ns;

        forever begin
            seq_item_port.get_next_item(rst_seq_item);
        
            rst_duration_ns = rst_seq_item.rst_duration_ns;
            apply_rst(rst_duration_ns);

            seq_item_port.item_done();
        end
    endtask

    virtual task apply_rst(input rst_duration_ns);
        sw_if.rst_n = 1'b1;
        #(rst_duration_ns);
        sw_if.rst_n = 1'b0;
        `uvm_info(get_type_name(), "Reset applied", UVM_MEDIUM)
    endtask
    
endclass

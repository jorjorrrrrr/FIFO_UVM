class test_base extends uvm_test;

    fifo_env env;
    virtual fifo_io vif;

    `uvm_component_utils(test_base)
    
    function new(string name = "test_base", uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        env = fifo_env::type_id::create("env", this);

        uvm_resource_db#(virtual fifo_io)::read_by_type("fifo_vif", vif, this);
        uvm_config_db#(virtual fifo_io)::set(this, "env.f_agt", "vif", vif);
    endfunction: build_phase

    virtual task shutdown_phase(uvm_phase phase);
        super.shutdown_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
        phase.raise_objection(this);
        env.sb.wait_for_done();
        phase.drop_objection(this);

    endtask: shutdown_phase

    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (uvm_report_enabled(UVM_MEDIUM, UVM_INFO, "TOPOLOGY")) begin
            uvm_root::get().print_topology();
        end
        if (uvm_report_enabled(UVM_MEDIUM, UVM_INFO, "FACTORY")) begin
            uvm_factory::get().print();
        end
    endfunction: final_phase

endclass: test_base


class test_only_write_inst extends test_base;

    `uvm_component_utils(test_only_write_inst);

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        //set_inst_override_by_type("env.f_agt.sqr*", fifo_item::get_type(), fifo_item_ow::get_type());
        set_inst_override_by_type("env.f_agt.sqr.fifo_sequence.req", fifo_item::get_type(), fifo_item_ow::get_type());
    endfunction: build_phase

endclass: test_only_write_inst

class test_times_100_seq extends test_base;

    `uvm_component_utils(test_times_100_seq);

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        uvm_config_db#(int)::set(this, "env.f_agt.sqr.fifo_sequence", "item_times", 100);
        uvm_config_db#(int)::set(this, "env.sb", "item_times", 100);
    endfunction: build_phase

endclass: test_times_100_seq



class fifo_env extends uvm_env;

    fifo_agent f_agt;
    fifo_scoreboard sb;

    `uvm_component_utils(fifo_env);

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        
        f_agt = fifo_agent::type_id::create("f_agt", this);
        sb = fifo_scoreboard::type_id::create("sb", this);
        
        uvm_config_db #(uvm_object_wrapper)::set(this, "f_agt.sqr.main_phase", "default_sequence", fifo_sequence::get_type());
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        f_agt.analysis_port.connect(sb.analysis_export);
    endfunction: connect_phase

    //virtual task reset_phase(uvm_phase phase);
    //    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //    phase.raise_objection(this);

    //    vif.rst_n = 1'b0;
    //    repeat(5) @(vif.cb);
    //    vif.cb.rst_n <= 1'b1;
    //    repeat(2) @(vif.cb);

    //    phase.drop_objection(this);
    //endtask: reset_phase

endclass: fifo_env

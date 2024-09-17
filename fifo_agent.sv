class fifo_agent extends uvm_agent;

    `uvm_component_utils(fifo_agent);

    typedef uvm_sequencer#(fifo_item) fifo_item_sequencer;

    virtual fifo_io     vif;
    fifo_item_sequencer sqr;
    fifo_driver         drv;
    fifo_monitor        mon;

    uvm_analysis_port #(fifo_item) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

        if (is_active == UVM_ACTIVE) begin
            sqr = fifo_item_sequencer::type_id::create("sqr", this);
            drv = fifo_driver::type_id::create("drv", this);
        end
        mon = fifo_monitor::type_id::create("mon", this);
       
        analysis_port = new("analysis_port", this);

        uvm_config_db #(virtual fifo_io)::get(this, "", "vif", vif);
        uvm_config_db #(virtual fifo_io)::set(this, "*", "vif", vif);
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end

        mon.analysis_port.connect(this.analysis_port);
    endfunction: connect_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Driver DUT interface not set");
        end
    endfunction: end_of_elaboration_phase

endclass: fifo_agent

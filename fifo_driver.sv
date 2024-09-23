class fifo_driver extends uvm_driver #(fifo_item);
    
    virtual fifo_io vif;

    `uvm_component_utils(fifo_driver);

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        uvm_config_db #(virtual fifo_io)::get(this, "", "vif", vif);
    endfunction: build_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Driver DUT interface not set");
        end
    endfunction: end_of_elaboration_phase

    virtual task run_phase(uvm_phase phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        repeat(8) @(vif.cb); // for reset
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            `uvm_info("DRV_RUN", {"\n", req.sprint()}, UVM_MEDIUM);
            seq_item_port.item_done();
        end
    endtask: run_phase

    virtual task drive(fifo_item tr);
        vif.cb.wr_n <= tr.wr_n;
        vif.cb.rd_n <= tr.rd_n;
        vif.cb.din  <= tr.din;
        tr.dout = vif.dout;
        tr.full = vif.full;
        tr.empty = vif.empty;
        @(vif.cb);
    endtask: drive

endclass: fifo_driver

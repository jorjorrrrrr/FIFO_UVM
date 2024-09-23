class fifo_monitor extends uvm_monitor;

    virtual fifo_io vif;

    `uvm_component_utils(fifo_monitor);

    uvm_analysis_port #(fifo_item) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        
        uvm_config_db #(virtual fifo_io)::get(this, "", "vif", vif);

        analysis_port = new("anaylsis_port", this);

    endfunction: build_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Driver DUT interface not set");
        end
    endfunction: end_of_elaboration_phase

    virtual task run_phase(uvm_phase phase);
        fifo_item tr;
        tr = fifo_item::type_id::create("tr", this);
            
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        repeat(8) @(vif.cb);  // for reset
        forever begin
            tr.din  = vif.din;
            tr.wr_n = vif.wr_n;
            tr.rd_n = vif.rd_n;
            tr.dout = vif.dout;
            tr.empty = vif.empty;
            tr.full  = vif.full;
            
            @(vif.cb);
            if (tr.rd_n == 0) begin
                `uvm_info("READ_DATA", {"\n", tr.sprint()}, UVM_MEDIUM);
            end
            else if (tr.wr_n == 0) begin
                `uvm_info("SEND_DATA", {"\n", tr.sprint()}, UVM_MEDIUM);
            end
            analysis_port.write(tr);
        end
    endtask: run_phase

endclass: fifo_monitor

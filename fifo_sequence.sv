class fifo_sequence extends uvm_sequence #(fifo_item);

    int item_times = 20;

    `uvm_object_utils(fifo_sequence)

    function new(string name = "fifo_sequence");
        super.new(name);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        `ifndef UVM_VERSION_1_1
            set_automatic_phase_objection(1);
        `endif
    endfunction: new

    virtual task body();
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        repeat(item_times) begin
            `uvm_do(req);
        end
    endtask: body



    virtual task pre_start();
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        `ifdef UVM_VERSION_1_1
        if ((get_parent_sequence() == null) && (starting_phase != null)) begin
            starting_phase.raise_objection(this);
        end
        `endif
        //if (!uvm_config_db#(int)::get(this, "", "item_times", item_times)) begin
        if (!uvm_config_db#(int)::get(get_sequencer(), get_type_name(), "item_times", item_times)) begin
          `uvm_warning("CFGERR", "item_times not set, using default value of 20.")
        end
        else begin
          `uvm_info("CFG", $sformatf("item_times set to %0d", item_times), UVM_MEDIUM)
        end
    endtask: pre_start

    `ifdef UVM_VERSION_1_1
    
    virtual task post_start();
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if ((get_parent_sequence() == null) && (starting_phase != null)) begin
            starting_phase.drop_objection(this);
        end
    endtask: post_start

    `endif

endclass: fifo_sequence


class fifo_scoreboard extends uvm_scoreboard;

    uvm_analysis_imp #(fifo_item, fifo_scoreboard)  analysis_export;

    fifo_item queue[$];
    bit [7:0] write_mem [$];
    bit [7:0] read_mem [$];
    
    int count_read = 0;
    int count_write = 0;
    int count = 0;
    int item_times = 20;

    real timeout = 10us;

    `uvm_component_utils(fifo_scoreboard)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        
        analysis_export = new("anaylsis_export", this);
        
        if (!uvm_config_db#(int)::get(this, "", "item_times", item_times)) begin
          `uvm_warning("CFGERR", "item_times not set, using default value of 20.")
        end
        else begin
          `uvm_info("CFG", $sformatf("item_times set to %0d", item_times), UVM_MEDIUM)
        end

    endfunction: build_phase
    
    virtual function void write(fifo_item item);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        item.print();
        queue.push_back(item);
    endfunction: write

    virtual task run_phase(uvm_phase phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        forever begin
            fifo_item tr;

            wait (queue.size() > 0);
            tr = queue.pop_front();
            compare(tr);
            count++;
        end
    endtask: run_phase

    virtual task compare(fifo_item tr);
        if (tr.ren) begin    // Assert to read
            `uvm_info("TOTAL_COMPARE", {"\n", tr.sprint()}, UVM_MEDIUM);
            if (count_write == count_read) begin    // underflow occur
                if (tr.empty == 1) begin
                    `uvm_info("MATCH", $sformatf("(DETECT EMPTY) %s\n%m", tr.sprint()), UVM_MEDIUM);
                end
                else begin
                    `uvm_error("MISMATCH", $sformatf("(DETECT EMPTY) %s\n%m", tr.sprint()));
                end
            end
            else begin
                if (tr.dout === write_mem[count_read]) begin
                    `uvm_info("MATCH", $sformatf("(READ) %s\n%m", tr.sprint()), UVM_MEDIUM);
                end
                else begin
                    `uvm_error("MISMATCH", $sformatf("(READ) output=%h, expect[%0d]=%h \n%m", tr.dout, count_read, write_mem[count_read]));
                end
                count_read++;
            end
        end
        else if (tr.wen) begin    // Assert to write
            if (count_write == count_read+16) begin    // overflow occur
                `uvm_info("TOTAL_COMPARE", {"\n", tr.sprint()}, UVM_MEDIUM);
                if (tr.full == 1) begin
                    `uvm_info("MATCH", $sformatf("(DETECT FULL) %s\n%m", tr.sprint()), UVM_MEDIUM);
                end
                else begin
                    `uvm_error("MISMATCH", $sformatf("(DETECT FULL) %s\n%m", tr.sprint()));
                end
            end
            else begin
                write_mem[count_write] = tr.din;
                `uvm_info("WRITE_DATA", $sformatf("write_mem[%0d] = %h\n%m", count_write, write_mem[count_write]), UVM_MEDIUM);
                count_write++;
            end
        end
    endtask: compare

    virtual task wait_for_done();
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        fork
            begin
                fork
                    wait(count == item_times);
                    begin
                      #timeout;
                      `uvm_warning("TIMEOUT", $sformatf("Scoreboard has %0d unprocessed expected objects", count));
                    end
                join_any
                disable fork;
            end
        join
    endtask: wait_for_done


endclass: fifo_scoreboard

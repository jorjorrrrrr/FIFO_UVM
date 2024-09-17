class fifo_item_ow extends fifo_item;

    `uvm_object_utils(fifo_item_ow)
    

    constraint limit_wr_n {
        wr_n == 1'b0;
        rd_n == 1'b1;
    }
    
    function new(string name = "fifo_item_ow");
        super.new(name);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

endclass: fifo_item_ow

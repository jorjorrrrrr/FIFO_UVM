class fifo_item extends uvm_sequence_item;

    rand bit [7:0]  din;
    rand bit        wr_n;
    rand bit        rd_n;
    bit             empty;
    bit             full;
    bit      [7:0]  dout;

    `uvm_object_utils_begin(fifo_item)
        `uvm_field_int(din, UVM_ALL_ON);
        `uvm_field_int(wr_n, UVM_ALL_ON);
        `uvm_field_int(rd_n, UVM_ALL_ON);
    `uvm_object_utils_end

    // partice constraint the input range of dut
    constraint limit_din {
        din inside { [15:25] };
    }

    function new(string name = "fifo_item");
        super.new(name);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

endclass

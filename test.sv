program automatic test;

    import uvm_pkg::*;
    import fifo_test_pkg::*;

    initial begin
        uvm_resource_db#(virtual fifo_io)::set("fifo_vif", "", fifo_test_top.ff_io);
        $timeformat(-9, 1, "ns", 10);
        run_test();;
    end

endprogram: test

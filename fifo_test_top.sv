`timescale 1ns/100ps

module fifo_test_top;

int simulation_time = 100;
bit SystemClock = 0;

fifo_io ff_io (SystemClock);

//test top_test (ff_io);

fifo_dut dut (
    .clk    (SystemClock),  // Clock Source
    .rst_n  (ff_io.rst_n),  // Active low asynchronous reset
    .wr_n   (ff_io.wr_n),   // Active low Write Enable
    .rd_n   (ff_io.rd_n),   // Active low Read Enable
    .din    (ff_io.din),    // Data in
    .dout   (ff_io.dout),   // Data out
    .full   (ff_io.full),   // FIFO is empty
    .empty  (ff_io.empty)   // FIFO is full 
);

initial begin
    $fsdbDumpvars;
    $fsdbDumpMDA;
end

initial begin
    ff_io.rst_n = 1'b0;
    repeat(5) @(ff_io.cb);
    ff_io.cb.rst_n <= 1'b1;
    repeat(2) @(ff_io.cb);
end

always #(simulation_time / 2) SystemClock = ~SystemClock;

endmodule: fifo_test_top

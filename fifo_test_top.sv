`timescale 1ns/100ps

module fifo_test_top;

int simulation_time = 100;
bit SystemClock = 0;

fifo_io ff_io (SystemClock);

fifo_dut dut (
    .clk    (SystemClock),  // Clock Source
    .rst_n  (ff_io.rst_n),  // Active low asynchronous reset
    .wen    (ff_io.wen),    // Active High Write Enable
    .ren    (ff_io.ren),    // Active High Read Enable
    .din    (ff_io.din),    // Data in
    .dout   (ff_io.dout),   // Data out
    .full   (ff_io.full),   // FIFO is empty
    .empty  (ff_io.empty)   // FIFO is full 
);

initial begin
    $fsdbDumpvars;
end

initial begin
    ff_io.rst_n = 1'b0;
    repeat(5) @(ff_io.cb);
    ff_io.cb.rst_n <= 1'b1;
    repeat(2) @(ff_io.cb);
end

always #(simulation_time / 2) SystemClock = ~SystemClock;

endmodule: fifo_test_top

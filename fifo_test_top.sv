`timescale 1ns/100ps

module fifo_test_top;

int simulation_time = 100;
bit SystemClock = 0;

fifo_io ff_io (SystemClock);

//test top_test (ff_io);

fifo_dut dut (
    .clk        (SystemClock),          // Clock Source
    .rst_n      (ff_io.rst_n),          // Active low asynchronous reset
    .wr_n       (ff_io.wr_n),           // Active low Write Enable
    .rd_n       (ff_io.rd_n),           // Active low Read Enable
    .din        (ff_io.din),            // Data in
    .dout       (ff_io.dout),           // Data out
    .under_flow (ff_io.under_flow),     // Empty and read enable asserts
    .over_flow  (ff_io.over_flow)       // Full and wirte enable asserts
);

initial begin
    $fsdbDumpvars;
end

initial begin
    ff_io.rst_n = 1'b0;
    @(ff_io.cb) ff_io.cb.rst_n <= 1'b1;
end

always #(simulation_time / 2) SystemClock = ~SystemClock;

endmodule: fifo_test_top

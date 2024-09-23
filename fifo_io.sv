interface fifo_io(input bit clk);

    logic       rst_n;
    logic       wen;
    logic       ren; 
    logic [7:0] din;      
    logic [7:0] dout;      
    logic       full;
    logic       empty;

    clocking cb @(posedge clk);
        default input #1ns output #1ns;
        output rst_n;
        output wen; 
        output ren;
        output din;      
        input  dout;      
        input  full;
        input  empty;
    endclocking

    modport TB(clocking cb, output rst_n);

endinterface: fifo_io

interface fifo_io(input bit clk);

    logic       rst_n;
    logic       wr_n;
    logic       rd_n; 
    logic [7:0] din;      
    logic [7:0] dout;      
    logic       under_flow;
    logic       over_flow;

    clocking cb @(posedge clk);
        default input #1ns output #1ns;
        output rst_n;
        output wr_n;
        output rd_n; 
        output din;      
        input  dout;      
        input  under_flow;
        input  over_flow;
    endclocking

    modport TB(clocking cb, output rst_n);

endinterface: fifo_io

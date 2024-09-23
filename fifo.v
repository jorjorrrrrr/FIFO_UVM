// ======================================================================
//
// Module Name  : Synchronous FIFO (using pointer comparison)
// Author       : jorjor
// Company      : NKUST NCLAB
// Created Date : 2024.07.29
//
// ======================================================================

`timescale 1ns/100ps

module fifo_dut #(
    parameter FIFO_DEPTH = 16,
              DATA_WIDTH = 8
) (
    input                           clk,        // Clock Source
    input                           rst_n,      // Active low asynchronous reset
    input                           wr_n,       // Active low Write Enable
    input                           rd_n,       // Active low Read Enable
    input       [DATA_WIDTH-1:0]    din,        // Data in
    output reg  [DATA_WIDTH-1:0]    dout,       // Data out
    output reg                      empty,      // FIFO is empty
    output reg                      full        // FIFO is full
);

localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

// FIFO (Memory) Body
reg     [DATA_WIDTH-1:0]    fifo_mem [0:FIFO_DEPTH-1] ;

// Pointers
reg     [PTR_WIDTH-1:0]     read_ptr;       // Read pointer
reg     [PTR_WIDTH-1:0]     write_ptr;      // Write Pointer
    
// FIFO content detection condition variables
reg     [PTR_WIDTH-1:0]     write_ptr_next; // Determine the next write pointer
wire                        empty_w;        // FIFO is empty
wire                        full_w;         // FIFO is full

integer i;

// Reading and Writing operation of Pointer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_ptr    <= 0;
        write_ptr   <= 0;
    end
    else begin
        if (!rd_n) begin
            if (!empty_w) begin
                if (read_ptr == FIFO_DEPTH-1) begin
                    read_ptr <= 0;
                end
                else begin
                    read_ptr <= read_ptr + 1;
                end
            end
        end
        else if (!wr_n) begin
            if (!full_w) begin
                if (write_ptr == FIFO_DEPTH-1) begin
                    write_ptr <= 0;
                end
                else begin
                    write_ptr <= write_ptr + 1;
                end
            end
        end
    end
end

// Writing operation of FIFO
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < FIFO_DEPTH; i=i+1) begin
            fifo_mem[i] <= 0;
        end
    end
    else begin
        // Write data when wr_n is asserted and the fifo_mem is not full
        if ((rd_n) && (!wr_n) && (!full_w)) begin
            fifo_mem[write_ptr] <= din;
        end
    end
end

// Make sure the next position of write pointer
always @(*) begin
    if (write_ptr == FIFO_DEPTH-1) begin
        write_ptr_next = 0;
    end
    else begin
        write_ptr_next = write_ptr + 1;
    end
end

// If read_ptr is equal to write_ptr, means it is empty
// If (write_ptr+1) is equal to read_ptr, means it is full
assign empty_w = (read_ptr == write_ptr);
assign full_w = (write_ptr_next == read_ptr);


// ------------------------------------------------------------------
// Module Output Signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout <= 0;
        empty <= 0; 
        full  <= 0;
    end
    else begin
        empty <= empty_w; 
        full  <= full_w;
        if ((!rd_n) && (!empty_w)) begin
            dout <= fifo_mem[read_ptr];
        end
        else begin
            dout <= 16'hx;
        end
    end
end



endmodule

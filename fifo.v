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
    output reg                      under_flow, // Empty and read enable asserts
    output reg                      over_flow   // Full and wirte enable asserts
);

localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

// FIFO (Memory) Body
reg     [DATA_WIDTH-1:0]    fifo_mem [0:FIFO_DEPTH-1] ;

// Pointers
reg     [PTR_WIDTH-1:0]     read_ptr;       // Read pointer
reg     [PTR_WIDTH-1:0]     write_ptr;      // Write Pointer
    
// FIFO content detection condition variables
reg     [PTR_WIDTH-1:0]     write_ptr_next; // Determine the next write pointer
wire                        empty;          // FIFO is empty
wire                        full;           // FIFO is full

integer i;

// Reading and Writing of Pointer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_ptr    <= 0;
        write_ptr   <= 0;
    end
    else begin
        if ((!rd_n) && (!empty)) begin
            if (read_ptr == FIFO_DEPTH-1) begin
                read_ptr <= 0;
            end
            else begin
                read_ptr <= read_ptr + 1;
            end
        end
        if ((!wr_n) && (!full)) begin
            if (write_ptr == FIFO_DEPTH-1) begin
                write_ptr <= 0;
            end
            else begin
                write_ptr <= write_ptr + 1;
            end
        end
    end
end

// Reading and Writing of FIFO
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        over_flow   <= 1'b0;
        under_flow  <= 1'b0;
        for (i = 0; i < FIFO_DEPTH; i=i+1) begin
            fifo_mem[i] <= 0;
        end
    end
    else begin
        // Read operation and Underflow error handling
        if (!rd_n) begin
            if (empty) begin
                under_flow <= 1'b1;
            end
            else begin
                under_flow <= 1'b0;
                dout <= fifo_mem[read_ptr];
            end
        end
        // Make Condition complete
        else begin
            under_flow <= 1'b0;
        end

        // Write operation and Overflow error handling
        if (!wr_n) begin
            if (full) begin
                over_flow <= 1'b1;
            end
            else begin
                over_flow <= 1'b0;
                fifo_mem[write_ptr] <= din;
            end
        end
        // Make Condition complete
        else begin
            over_flow <= 1'b0;
        end
    end
end

// If read_ptr is equal to write_ptr, means it is empty
// If (write_ptr+1) is equal to read_ptr, means it is full
assign empty    = (read_ptr == write_ptr);
assign full     = (write_ptr_next == read_ptr);

always @(*) begin
    if (write_ptr == FIFO_DEPTH-1) begin
        write_ptr_next = 0;
    end
    else begin
        write_ptr_next = write_ptr + 1;
    end
end


endmodule

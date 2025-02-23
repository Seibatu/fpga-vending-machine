`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 28.01.2025 22:54:08
// Design Name: 
// Module Name: clkDiv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/*
    This module **reduces the system clock frequency 100MHz** to a slower, manageable clock 10Hz, suitable for FSM operations in the vending machine.
    
    Functionality
    - The module uses a counter to divide the input clock frequency 100MHz.
    - Reduces FPGA clock speed to **10Hz** for stable vending machine operation.
    
    Usage in Top-Level Module
    - Instantiated in `topModule.v` to provide a slow clock signal.
*/
// Dependencies: 
    // Used by `topModule.v` (Top-level module)
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clkDiv
  #(parameter N = 10_000_000) // Number of clk cycles to make one slow_CLK (10 Hz)
    (
    input CLK,
    input RST,
    output reg slow_CLK
);

reg [$clog2(N/2)-1:0] tmp_count; // 23-bit counter for 10Hz generation

always @ (posedge CLK or posedge RST) begin
    if (RST) begin 
        tmp_count <= 0;
        slow_CLK <= 0;
    end 
    else if (tmp_count == ((N/2) - 1)) begin  // Toggle slow_CLK every N/2 cycles
        slow_CLK <= ~slow_CLK;        
        tmp_count <= 0;    
    end 
    else 
        tmp_count <= tmp_count + 1;
end

endmodule  

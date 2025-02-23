`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 28.01.2025 23:07:17
// Design Name: 
// Module Name: topModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/* 
    This is the top-level module for the Vending Machine. It integrates all sub-modules, 
    including the FSM control unit, clcok divider.
    
    Usage
    //   Ensure all required modules are included in your Verilog project before simulating or synthesizing.
*/
// Dependencies: 

   // - ``clkDiv.v` (Clock control logic)
   // - `FSMVending.v` (FSM vending operation logic)
  
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module topModule(
    input CLK,           // 100 MHz system clock
    input RST,           // Reset
    input [3:0] SW,      // Switch input: [1:0] Coin, [2] Candy, [3] Soda
    input BTN_sensor,
    output [1:0] LEDS,   // LEDs for dispense signals
    output [7:0] seg_7_disp, // 7-segment display output
    output [7:0] AN  // Active-low digit selection
);
    
    // Slow clock signal (10 Hz)
    wire slow_CLK;

    // Instantiate Clock Divider (controlUnit)
    controlUnit clk_divider (
        .CLK(CLK),       // 100 MHz input clock
        .RST(RST),       // Reset
        .slow_CLK(slow_CLK) // Output: 10 Hz clock
    );
        
    // Instantiate FSM Unit
    FSMUnit fsm_vend (
        .CLK(CLK), // 100MHz for fast digit refresh
        .slow_CLK(slow_CLK),  // 10Hz clock signal
        .RST(RST),            // Reset signal
        .Coin_insert(SW[1:0]), // Coin insertion (00: none, 01: 1 coin, 10: 2 coins)
        .C_A(SW[2]),         // Candy selection
        .S_A(SW[3]),         // Soda selection
        .BTN_sensor(BTN_sensor),
        .C_D(LEDS[0]),       // Candy dispense LED
        .S_D(LEDS[1]),       // Soda dispense LED
        .seg_7_disp(seg_7_disp), // 7-segment display data
        .AN(AN)              // Active-low digit select
    );
    
endmodule

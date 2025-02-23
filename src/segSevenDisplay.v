`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 28.01.2025 23:09:47
// Design Name: 
// Module Name: segSevenDisplay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/* 
    This module **drives a seven-segment display** to show the amount inserted and the change remaining.
    
    Functionality
        - Uses **time-division multiplexing** to display multiple digits.
        - Converts binary input values to **7-segment encoded output**.
    
    Usage in Top-Level Module
        - Instantiated in `FSMVending.v` to visually show the vending machine status.
*/ 
// Dependencies: 
    // Used by `FSMVending.v` (Top-level module)
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module segSevenDisplay(
    input CLK, RST,
    input candy_price, soda_price, candy_change_left,
    output reg [7:0] seg_7_disp, // 7-bit signal for controlling the segments.
    output reg [7:0] AN //Controls which digit is active.
);
    
    //Taking a refresh rate of 62Hz 
    reg [16:0] display_count;
    reg [2:0] digit_to_pick;
    reg [3:0] current_digit;
    reg decimal_enable; 
    reg [15:0] number; // 0000_0000_0000_0000
    // if C_P 0000_0000_0010_0101
    // if S_P 0000_0000_0101_0000
    
    // Counting block to select each digit, a refresh rate of 1KHz 
    always @(posedge CLK or posedge RST) begin 
        if (RST) begin 
            display_count <= 0;
            digit_to_pick <= 0;
        end 
        else begin 
            if (display_count == (100_000 - 1)) begin  // 1ms refresh rate
                digit_to_pick <= digit_to_pick + 1; // Cycle through digits
                display_count <= 0;
            end 
            else display_count <= display_count + 1;
        end 
    end 
    
    // Digit Activation (Common Anode, Active LOW)
    always @(*) begin
        case (digit_to_pick)
            3'b000: AN = 8'b1111_1110;  // Activate rightmost digit (5 or 0)
            3'b001: AN = 8'b1111_1101;  // Activate second digit (2 or 5)
            3'b010: AN = 8'b1111_1011;  // Activate third digit (0 with decimal)
            default: AN = 8'b1111_1111; // Turn off other digits
        endcase
    end
    
     // Selecting the Number to Display
    always @ (*) begin
        if (candy_price) 
            number = 16'b0000_0000_0010_0101;  // 0.25 (0, 2, 5)
        else if (soda_price) 
            number = 16'b0000_0000_0101_0000;  // 0.50 (0, 5, 0)
        else if (candy_change_left) 
            number = 16'b0000_0000_0010_0101;  // 0.25 (0, 2, 5)
        else  
            number = 16'b0000_0000_0000_0000;  // Default: Blank or Error Display

        // Extract digit based on the current position
        case (digit_to_pick)
            3'b000: begin 
                current_digit = number[3:0];   // Ones place (5 or 0)
                decimal_enable = 1'b0;
            end 
            3'b001: begin 
                current_digit = number[7:4];   // Tens place (2 or 5)
                decimal_enable = 1'b0;
            end 
            3'b010: begin 
                current_digit = number[11:8];  // Hundreds place (0) with decimal point
                decimal_enable = 1'b1;
            end 
            default: begin 
                current_digit = 4'h0;
                decimal_enable = 1'b0;
            end 
        endcase
    end
    
    always @ (*) begin 
        // seg-7 is CA,CB,CC,CD,CE,CF,CG,DP -- DP is decimal point 
        // Active low
        case (current_digit)
            4'h0 : begin 
                // display 0 with decimal if decimal is enabled 
                seg_7_disp = decimal_enable ? 8'b0100_0000: 8'b1100_0000; 
                end 
            4'h2 : seg_7_disp = 8'b1010_0100; // display 
            4'h5 : seg_7_disp = 8'b10010010; // display 
            default: seg_7_disp = 8'b1111_1111; // Blank display
        endcase
    end
endmodule

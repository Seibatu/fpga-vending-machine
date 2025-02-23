`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 28.01.2025 20:54:23
// Design Name: 
// Module Name: FSMVending
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/*
    This module implements a **Finite State Machine (FSM)** to control the vending machine's operations based on user input. 
    It manages state transitions and determines when a product should be dispensed.
    
    This module also has the instantiation of the seven segment display, `segSevenDisplay.v`. 

    Functionality
        1. Waits in **Idle State** for user input.
        2. If a coin is inserted, updates the internal balance.
        3. Dispenses **candy** if $0.25 is inserted and **soda** if $0.5 is inserted.
        4. Give change of $0.25 when candy is dispensed but a $0.5 is inserted. 
        4. Returns to **Idle State** after dispensing.
    
    Usage in Top-Level Module
    This module is instantiated in `topModule.v` to handle state transitions for the vending machine.
*/ 
// Dependencies: 
    // Needs the `segSevenDisplay.v` module 
    // This modules in used in the `topModule.v` 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FSMVending (
    input CLK, // 100MHz clock for 7-segment display refresh
    input slow_CLK,      // 10Hz clock signal
    input RST,           // Reset signal
    input [1:0] Coin_insert, // Coin insertion (00: none, 01: 1 coin, 10: 2 coins)
    input C_A, S_A,      // Candy and Soda selection
    input BTN_sensor,
    output reg C_D, S_D, // Candy and Soda dispense
    output reg C_P, S_P, // Candy and Soda price display
    output reg C_E,       // Coin ejection display of remaing 0.25
    output [7:0] seg_7_disp, // 7-segment display output
    output [7:0] AN // Active-low digit selection
);

    // Instantiate Seg-7 display 
    segSevenDisplay price_display (
        .CLK(CLK), // Use 100MHz clock for digit multiplexing
        .RST(RST),
        .candy_price(C_P),
        .soda_price(S_P),
        .candy_change_left(C_E),
        .seg_7_disp(seg_7_disp),
        .AN(AN)
    );
    
    localparam IDLE_st = 3'b000,
               CANDY_st = 3'b001,
               SODA_st = 3'b010,
               CANDY_CHANGE_st = 3'b011,
               ERROR_st = 3'b100;
               
    reg [2:0] state;         // Current state
    reg [2:0] Count;         // Counter for state transitions
                  
    always @ (posedge slow_CLK or posedge RST) begin
        if (RST) begin    
            state <= IDLE_st;    
            C_D <= 1'b0;    
            S_D <= 1'b0;    
            C_P <= 1'b0; 
            S_P <= 1'b0;
            C_E <= 1'b0;
            Count <= 0;   
        end
        else begin
            case (state )        
                IDLE_st : begin        
                    C_D <= 1'b0;    
                    S_D <= 1'b0;
                    C_P <= 1'b0;
                    S_P <= 1'b0;
                    C_E <= 1'b0;  
                    Count <= 0; 
                    if (BTN_sensor) begin                                         
                        if (Coin_insert == 2'b01) begin     // Inserts 1 coin
                            C_P <= 1'b1;                    // see money of SEG-7 display, 0.25
                            if (C_A && ~S_A)                       // chooses candy
                                state <= CANDY_st;
                            else if (S_A && ~C_A) begin        // chooses soda
                                C_P <= 1'b0;
                                state <= ERROR_st;           // go to error state
                                end 
                            else begin 
                                C_P <= 1'b1;
                                state <= IDLE_st;   // customer has not choose anything
                            end
                        end
    
                        else if (Coin_insert == 2'b10) begin       // Inserts 2 coins
                            S_P <= 1'b1;                      // see money of SEG-7 display, 0.50
                            if (S_A && ~C_A)              // chooses soda
                                state <= SODA_st;
                            else if (C_A && ~S_A) begin     // chooses candy, give 1 candy and chnage
                                S_P <= 1'b0;
                                C_E <= 1'b1;
                                state <= CANDY_CHANGE_st;
                                end 
                            else begin 
                                S_P <= 1'b1;
                                state <= IDLE_st;
                            end 
                        end
    
                        else if (Coin_insert == 2'b00 && (S_A || C_A)) begin      //insert no coin, selects candy or soda
                            state <= ERROR_st;           // go to error state
                        end   
                            
                        else state <= IDLE_st;    // stay in idle ate if no coins is inserted 
                   end        
                end
            
                CANDY_st : begin        
                    C_D <= 1'b1;                
                    S_D <= 1'b0;
                    C_E <= 1'b0;
                    if (Count == 5) begin        
                        C_D <= 1'b0;
                        state <= IDLE_st;  //return to Idle stae when Count reaches 2
                        Count <= 0;    // reset Count as zero
                    end  
                    else Count <= Count + 1;                                                         
                end
            
                SODA_st : begin
                    C_D <= 1'b0;
                    S_D <= 1'b1;        
                    C_E <= 1'b0;
                    if (Count == 5) begin        
                        S_D <= 1'b0;
                        state <= IDLE_st;  //return to Idle stae when Count reaches 2
                        Count <= 0;    // reset Count as zero
                    end  
                    else Count <= Count + 1; 
                end
                
                // issue here does not know what to display  
                CANDY_CHANGE_st: begin
                    S_P <= 1'b0; // Turn off soda_price 
                    C_P <= 1'b0; // Turn off candy_price
                    C_D <= 1'b1; // Dispense candy
                    C_E <= 1'b1; // Eject change display 0.25
                    if (Count == 5) begin
                        C_D <= 1'b0;
                        state <= IDLE_st;
                        Count <= 0;
                    end 
                    else Count <= Count + 1;
                end
                
                // error state issue 
                ERROR_st : begin            
                    C_D <= 1'b0;            
                    S_D <= 1'b0;            
                    C_E <= 1'b0;
                    C_P <= 1'b0; // Turn off price display
                    S_P <= 1'b0; // Turn off price display  
                    if (Count == 5) begin        
                        state <= IDLE_st;  //return to Idle stae when Count reaches 2
                        Count <= 0;    // reset Count as zero
                    end 
                    else Count <= Count + 1;                                       
                end
                
                default : state <= IDLE_st;
            endcase
        end
    end

endmodule

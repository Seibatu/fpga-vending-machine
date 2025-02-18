# FPGA Vending Machine 🚀

## Overview
This project implements a **Verilog-based vending machine** using a **finite state machine (FSM)** approach. The vending machine accepts **quarters** as input and dispenses either **soda (0.5$) or candy (0.25$)** based on the amount inserted. The design is implemented on a Nexys-4 artix-7 fpga board and includes a **seven-segment display** for more user interaction.

## Features
✅ **Finite State Machine (FSM)** to control vending logic  
✅ **Clock Divider Module** for FPGA timing control  
✅ **Seven-Segment Display Driver** to show inserted amount  
✅ **Supports Multiple Inputs** – Coin Insertion, Product Selection  
✅ **Testbench Verification** using simulation tools like Vivado 

---

## 📌 System Architecture
This project consists of the following Verilog modules:

1. **FSM Control Module (`FSMVending.v`)**  
   - Manages state transitions based on coin insertion and product selection.
   - Outputs control signals for soda or candy dispense or coin change remaining.

2. **Clock Divider (`clkDiv.v`)**  
   - Reduces the FPGA clock frequency for timing stability.

3. **Seven-Segment Display Driver (`segSevenDisplay.v`)**  
   - Displays the amount inserted, vending status and remaing change.

4. **Top-Level Module (`topModule.v`)**  
   - Instantiates all sub-modules and connects inputs/outputs.

---

## 🛠️ How to Run It
### 1️⃣ Simulation
To test the design before FPGA implementation:
1. Open **Vivado Simulator**.
2. Load `topModule.v` and include all submodules (`FSMVending.v`, `clkDiv.v`, `segSevenDisplay.v`).
3. Compile and run the testbench (`testbench.v`).
4. Observe the waveform in the built-in waveform viewer.

### 2️⃣ FPGA Implementation (Nexys4 Board)
1. Open **Xilinx Vivado**.
2. Create a new project and add all Verilog files.
3. Assign FPGA board pins according to your hardware setup using a Constraints XDC file.
4. Run Synthesis, implementation, and generate the bitstream.
5. Program your bitstream to the FPGA and test using the physical switches.

---

## 📂 Repository Structure
```
📂 src/				# Verilog source files 
   ├── topModule.v		# Top-level module 
   	├── FSMVending.v       # FSM vending controller  
   	├── clkDiv.v    	# Clock divider  
   	├── segSevenDisplay.v  # Seven-segment display driver  
             

📂 testbench/      # Testbenches and simulations  
📂 waveforms/      # Simulation waveform images  
📂 docs/           # Documentation 
```

---

## 📸 Simulation Waveform

---

## ✉️ Contact
For any questions or improvements or collaborations, feel free to connect:
- **GitHub:** [Seibatu](https://github.com/Seibatu)
- **LinkedIn:** [Seiba Abdul Rahman](https://www.linkedin.com/in/seiba-abdul-rahman)

APB3 Master-Slave Implementation Using Verilog HDL

Project Overview

This project implements an AMBA APB3 (Advanced Peripheral Bus 3) Master-Slave architecture using Verilog HDL and Xilinx Vivado.

The design demonstrates communication between an APB3 master and slave through multiple read and write transactions.

Features

- APB3 Master using a Finite State Machine (FSM)
- APB3 Slave with four memory-mapped registers
- Read and write operations
- Wait-state handling using PREADY
- Error response detection using PSLVERR
- Verilog testbench for functional verification
- Multiple read/write transactions

Tools Used

- Verilog HDL
- Xilinx Vivado
- Vivado Behavioural Simulation

Project Files

File| Description
apb3_master.v| APB3 Master module
apb3_slave.v| APB3 Slave module
apb3_top.v| Top-level integration
apb3_testbench.v| Simulation testbench

Simulation Results

The design was verified using Vivado behavioural simulation.

Three read/write transaction pairs were tested:

1. Write 50 and read from address 0x08.
2. Write 100 and read from address 0x04.
3. Write 25 and read from address 0x0C, with error response detection.

Verification Summary

- Transaction 1: PASSED
- Transaction 2: PASSED
- Transaction 3: PSLVERR detected successfully
- Wait-state handling: Verified
- Overall test result: ALL TESTS PASSED

Learning Outcomes

Through this project, I gained practical experience in:

- APB3 protocol fundamentals
- FSM-based RTL design
- Verilog module integration
- Memory-mapped register operations
- Simulation and functional verification
- Bus wait-state and error-response handling

Verification Note

This project was verified through Vivado behavioural simulation. Physical FPGA hardware testing has not been performed.

Author
    Maithri U

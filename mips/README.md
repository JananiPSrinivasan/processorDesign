# MIPS SoC for IRIS Classification using Feedforward Neural Network

This project involves designing a System-on-Chip (SoC) with a simple pipelined MIPS processor, an on-chip neural network accelerator, and bootloader logic for deploying a quantized IRIS dataset model. The system supports weight loading from SPI flash and real-time inference on FPGA or ASIC platforms.

The project initially began with a simple Verilog prototype. Based on that experience, the architecture is now being rewritten in **SystemVerilog** to take advantage of enhanced modeling, debugging, and modular design.

## Phase 1: ML Model Development and Quantization


### Neural Network Design
- Architecture: Input (4) → Hidden (5) → Output (3)
- Activation Functions:
  - Hidden: ReLU
  - Output: Softmax

### Training and Quantization
- Framework: TensorFlow
- Quantize weights and activations to 8-bit fixed-point (INT8)
- Export weights in `.hex`  format for hardware


## Phase 2: SoC Architecture and Memory Design

### Processor Core
- **MIPS pipelined processor** (5-stage: IF → ID → EX → MEM → WB)
- Written in **SystemVerilog**

### Memory Subsystem
- Simple cache (direct-mapped)
- On-Chip SRAM Buffers:
  - Store input features, model weights, and intermediate activations
  - Implemented using dual-port RAMs

### Bootloader and SPI Flash
- Store `.hex` weights in SPI NOR flash (e.g., Micron N25Q032)
- On reset, bootloader loads weights into SRAM
- SPI controller and FSM written in **SystemVerilog**
- Flash is programmed via FTDI FT2232H (USB to SPI)

### I/O Interfaces
- Feature input via host interface (PCIe)
- Output class displayed via LED 

## Phase 3: Hardware Implementation using SystemVerilog

### Core Modules
- MIPS Core: ALU, Register File, Control, Hazard Unit, Forwarding Unit
- ML Accelerator: Matrix-vector multiply + ReLU + classifier logic
- SRAM and DMA controllers
- SPI flash controller
- Bootloader FSM

### Interconnect
- Wishbone or AXI bus for internal communication

### Simulation and Debugging
- Simulate using Cadence Xcelium
- Debug with waveform viewers, assertions, and transaction-level monitoring

### RTL Synthesis
- Use Cadence Genus for synthesis
- Perform:
  - Timing analysis
  - Area and power estimation
  - Clock gating and logic optimization

## Phase 5: Deployment and Testing

### FPGA Deployment
- Flash SPI with quantized model weights
- Configure FPGA with synthesized design
- Validate bootloading, inference, and classification output

## SystemVerilog vs. Verilog

This project started with a simple MIPS prototype written in **Verilog**. However, for SoC-scale complexity, **SystemVerilog is now used** because it provides:

- Strong typing, interfaces, enumerated types, and `typedef`s
- Support for assertions and constrained-random testing
- Easier module hierarchy management and parameterization
- Better support for testbenches, synthesis, and simulation

The use of SystemVerilog significantly improves **debugging speed**, **readability**, and **scalability**.

---

## Why MIPS? Why Consider RISC-V?

### Advantages of Using MIPS
- Simple, well-documented 5-stage RISC pipeline
- Academic support (used widely in teaching processor design)
- Stable and predictable ISA for prototyping

### Limitations of MIPS
- Limited or outdated ecosystem
- Not open-source in full (license restrictions may apply)
- Less extensible/customizable than modern needs demand

### Why Consider RISC-V in the Future
- Fully open-source and extensible ISA
- Modern toolchain and simulation support
- Large ecosystem (SiFive, Andes, lowRISC, etc.)
- Ideal for flexible, reconfigurable ML hardware systems


---

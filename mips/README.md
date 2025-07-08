# MIPS SoC for IRIS Classification using Feedforward Neural Network

This project involves designing a System-on-Chip (SoC) with a flexible MIPS processor, an on-chip neural network accelerator, DMA engines, and bootloader logic for deploying a quantized IRIS dataset model. The system supports weight loading from SPI flash and real-time inference on FPGA or ASIC platforms.

The project initially began with a simple Verilog prototype. Based on that experience, the architecture is now being rewritten in **SystemVerilog** to take advantage of enhanced modeling, debugging, and modular design.

---

## Phase 1: ML Model Development and Quantization

### Dataset Preparation
- Dataset: IRIS (150 samples, 4 features, 3 classes)
- Normalize feature values to [0, 1]
- Split into training and test sets

### Neural Network Design
- Architecture: Input (4) → Hidden (e.g., 8 or 16) → Output (3)
- Activation Functions:
  - Hidden: ReLU
  - Output: Softmax

### Training and Quantization
- Framework: PyTorch or TensorFlow
- Target accuracy: ≥ 95% before quantization
- Quantize weights and activations to 8-bit fixed-point (INT8)
- Post-quantization accuracy goal: ≥ 90%
- Export weights in `.hex` or `.mif` format for hardware

### Fixed-Point Design
- Choose format (e.g., Q4.4, Q2.6)
- Apply saturation and rounding
- Generate MAC-friendly weight layout

---

## Phase 2: SoC Architecture and Memory Design

### Processor Core
- **MIPS pipelined processor** (5-stage: IF → ID → EX → MEM → WB)
- Written in **SystemVerilog**
- Supports optional custom instructions

### Memory Subsystem
- DDR/LPDDR for program/data storage
- Simple cache (direct-mapped or 2-way set associative)
- On-Chip SRAM Buffers:
  - Store input features, model weights, and intermediate activations
  - Implemented using dual-port RAMs

### Bootloader and SPI Flash
- Store `.hex` weights in SPI NOR flash (e.g., Micron N25Q032)
- On reset, bootloader loads weights into SRAM
- SPI controller and FSM written in **SystemVerilog**
- Flash is programmed via FTDI FT2232H (USB to SPI)

### DMA Engines
- Automatically transfer data between DDR and SRAM
- Load model weights from flash or DDR into SRAM
- Stream feature vectors to accelerator without CPU intervention

### I/O Interfaces
- Feature input via host interface (PCIe or UART)
- Output class displayed via LED or debug UART

---

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

---

## Phase 4: Synthesis and Physical Design

### RTL Synthesis
- Use Cadence Genus for synthesis
- Perform:
  - Timing analysis
  - Area and power estimation
  - Clock gating and logic optimization

### Physical Implementation (Optional)
- Use Cadence Innovus for place and route
- Floorplanning, CTS, routing
- Generate GDSII for ASIC tape-out

---

## Phase 5: Deployment and Testing

### FPGA Deployment
- Flash SPI with quantized model weights
- Configure FPGA with synthesized design
- Validate bootloading, inference, and classification output

### Flexibility Features
- Model weights can be reprogrammed in flash
- MIPS core allows dynamic configuration and layer-level control
- Architecture supports software-driven reconfiguration

---

## Summary of Features

| Feature                  | Description                                           |
|--------------------------|-------------------------------------------------------|
| Core                     | Pipelined MIPS processor (SystemVerilog)              |
| Neural Network           | Quantized FFNN for IRIS classification                |
| Accelerator              | Matrix-vector multiply with ReLU and classifier       |
| Memory                   | DDR, simple cache, on-chip dual-port SRAM             |
| DMA                      | High-speed transfers between memory and accelerator   |
| Bootloader               | SPI flash boot logic for weight loading               |
| I/O                      | Feature input via host, output via LED/UART           |
| Interconnect             | Wishbone or AXI                                       |
| Development Tools        | SystemVerilog, Cadence Xcelium, Genus, Innovus        |
| Deployment               | FPGA or ASIC                                          |

---

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

**Future work** may explore replacing the MIPS core with a lightweight RISC-V processor to take advantage of custom instructions and open-source tools.

---

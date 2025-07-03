# MIPS Processor for MNIST Classification with On-Chip ML Accelerator

A hardware-software co-design project to implement a pipelined MIPS processor with an on-chip neural network accelerator for real-time MNIST classification using ReLU-based FFNN. Built using SystemVerilog and Cadence tools.

---

## PHASE 1: ML Model Development & Quantization

### Download & Preprocess the Dataset
- Dataset: MNIST (28×28 grayscale images)
- Normalize pixel values to [0, 1]
- Split into training and testing sets

### Design Feed-Forward Neural Network (FFNN)
- Architecture: Input (784) → Hidden Layer (128) → Output (10)
- Activations:
  - Hidden Layers: ReLU
  - Output Layer: Softmax

### Train the Model
- Framework: TensorFlow or PyTorch
- Goal: ~98% test accuracy

### Quantization
- Convert weights and activations to 8-bit fixed-point (INT8)
- Accuracy goal post-quantization: ≥ 95%
- Export model weights as `.txt` or `.hex` for hardware

### Fixed-Point Design Planning
- Choose fixed-point format (e.g., Q4.4 or Q2.6)
- Generate lookup tables or MAC arrays for efficient implementation

---

## PHASE 2: Hardware Design – Pipelined MIPS + ML Accelerator

### 2.1 Top-Level System Architecture

#### Components
- MIPS Core: 5-stage pipeline (IF → ID → EX → MEM → WB)
- Memory System:
  - DDR/LPDDR main memory
  - Simple cache (direct-mapped or 2-way set associative)
  - On-Chip SRAM Buffers:
    - Buffers for input images, weights, and activations
    - Dual-port SRAM macros or FPGA-inferred blocks
    - Mapped to Wishbone interface

#### Communication
- Wishbone Bus: Interconnect between CPU, DMA, ML accelerator, memory
- PCIe: Interface for external peripherals (e.g., camera)

#### I/O
- Camera Input: Via PCIe or AXI-to-Wishbone bridge
- Monitor/LED Output: Display predicted digit (0–9)

---

### 2.2 ML Accelerator Module
- Inputs: 784 INT8 values (flattened image)
- Operations: Matrix multiply + ReLU + classifier
- Output: Predicted class index (0–9)

---

### 2.3 On-Chip SRAM Buffers
- Purpose: Minimize latency by storing data locally
- Use Cases:
  - Camera image buffering (28×28 bytes)
  - Local weight storage for hidden/output layers
  - Intermediate activation buffers

---

### 2.4 DMA Engines
- Purpose: Automatic data transfer between DDR/LPDDR and SRAM
- Usage:
  - Boot-time weight loading
  - Streaming camera input into SRAM
  - Storing result to output port
- Controlled via CPU-configured registers or interrupts

---

## PHASE 3: SystemVerilog Implementation (Cadence Tools)

### MIPS Core
- Modules:
  - ALU
  - Register File
  - Control Unit
  - Hazard Detection
  - Forwarding Unit

### ML Accelerator
- RTL for:
  - Matrix-vector multiply
  - ReLU logic
  - Classification logic
- Memory-mapped weight/activation buffers (SRAM interface)

### Memory & I/O Infrastructure
- Wishbone bus interconnect
- PCIe peripheral interface for camera input
- DDR/LPDDR controller + simple cache
- DMA controller
- On-chip dual-port SRAM wrappers

---

## PHASE 4: Simulation, Synthesis, and Verification

### Functional Verification
- Simulate using Cadence Xcelium or QuestaSim
- Testbench with dummy MNIST image vectors
- Verify correctness of accelerator and DMA flows

### Synthesis
- Use Cadence Genus
- Perform timing analysis, logic optimization
- Analyze:
  - Area
  - Power
  - Performance

### Physical Design (Optional)
- Use Cadence Innovus
- Floorplanning and place-and-route
- Generate GDSII for ASIC tape-out

---

## PHASE 5: Deployment (Optional)

- Target platform: FPGA or ASIC
- Interface with real camera via PCIe/UART
- Real-time prediction displayed via LED or HDMI monitor
- Full system integration and throughput testing

---

## Summary of Key Features

| Component           | Description                                        |
|--------------------|----------------------------------------------------|
| MIPS Core          | 5-stage pipelined processor                        |
| ML Accelerator     | FFNN-based INT8 inference engine                   |
| On-Chip SRAM       | Dual-port buffers for fast data access             |
| DMA Engines        | Memory-to-memory transfers without CPU             |
| Memory             | DDR/LPDDR with simple cache                        |
| Communication      | Wishbone (on-chip), PCIe (peripheral)              |
| I/O Devices        | Camera (input), LED/Monitor (output)               |
| Tools Used         | SystemVerilog, Cadence Genus/Xcelium/Innovus       |

---

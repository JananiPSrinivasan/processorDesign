# Parallel RISC-V Softcore Processor (SystemVerilog)

This project walks you through building a **multi-core RISC-V RV32I softcore processor** in **SystemVerilog**, with a shared-memory architecture and a simple Wishbone-style bus. It is designed for learners who want an industry-style, hands-on experience with processor microarchitecture, parallel execution, and hardware-level system design.

Each 32-bit processor core supports a **5-stage pipeline** and communicates with shared memory and optional peripherals through a bus interconnect. The system executes hardcoded programs from instruction memory and demonstrates parallelism by running multiple threads across cores.

##  Machine Learning Model: Tiny Feedforward Neural Network

We implement the following model:
### Forward Pass:
1. Hidden Layer:
   \[
   h_i = \text{ReLU}\left(\sum_{j=1}^{N} x_j \cdot w_{ji} + b_i\right)
   \]
2. Output Layer:
   \[
   y = \text{step}\left(\sum_{i=1}^{H} h_i \cdot w_i + b\right)
   \]

- Inference runs entirely in software using fixed-point arithmetic
- All weights, biases, and inputs are stored in **shared memory**
- Each RISC-V core executes part of the pipeline for parallel inference


---

## Architecture Overview

        +-------------------+
        |  Core 0 (RV32I)   |
        |   (pipelined)     |
        +--------+----------+
                 |
        +--------v----------+
        |  Bus Interconnect |
        +--------+----------+
                 |
        +--------v----------+     +----------------+
        |  Shared Data RAM  |<--->|   Peripherals   |
        |  (data_memory.sv) |     |  (e.g., UART)   |
        +-------------------+     +----------------+
                 ^
        +--------+----------+
        |  Core 1 (RV32I)   |
        |   (pipelined)     |
        +-------------------+

---

## System Highlights

- Dual RISC-V RV32I cores with independent instruction streams
- Shared data memory (RAM) with arbitration
- Instruction ROM for each core
- Bus interface using a simplified Wishbone protocol
- Modular SystemVerilog design (synthesizable and extensible)
- Simple peripherals (timer, UART) optional
- Basic multi-core synchronization via shared memory

---

## Memory Map for Neural Network

| Address Range     | Contents                          |
|-------------------|-----------------------------------|
| `0x1000_0000`     | Input vector `x[0..N-1]`          |
| `0x1000_0010`     | Hidden weights `W1[N][H]`         |
| `0x1000_0040`     | Hidden biases `b1[H]`             |
| `0x1000_0050`     | Output weights `W2[H]`            |
| `0x1000_0060`     | Output bias `b2`                  |
| `0x1000_0064`     | Final output `y` (0 or 1)         |

All values are stored in fixed-point (e.g., Q1.7 format) as 32-bit words.

---

## Design Steps

### Step 1: **ALU — Arithmetic and Logic**
- Create `alu.sv`
- Supports operations: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT`, `NOP`
- Purely combinational
- Parameterized by `DATA_WIDTH`
- Tested independently with assertions or basic TB

---

### Step 2: **Register File — General-Purpose Registers**
- Create `regfile.sv`
- 32 registers (R0–R31), 32-bit wide
- Two read ports, one write port per cycle
- Synchronous write on rising edge
- Read-only register x0 always returns 0

---

### Step 3: **Instruction Memory — ROM**
- Create `instruction_memory.sv`
- Holds 32-bit RISC-V instructions for each core
- Read-only: initialized via `$readmemh`
- Indexed by program counter (PC)

---

### Step 4: **Data Memory — Shared RAM**
- Create `data_memory.sv`
- 32-bit wide, byte-addressable, word-aligned
- Supports read/write from both cores
- Arbitration handled via `bus_arbiter.sv`

---

### Step 5: **Control Unit — Instruction Decoder**
- Create `control_unit.sv`
- Decodes RISC-V base instructions (RV32I)
- Outputs control signals:
  - ALU operation
  - Register write enable
  - Memory control (load/store type)
  - Branching/jump logic

---

### Step 6: **Pipeline Stages — Core Microarchitecture**
- Create separate modules:
  - `if_stage.sv`, `id_stage.sv`, `ex_stage.sv`, `mem_stage.sv`, `wb_stage.sv`
- Each stage processes one instruction per cycle
- Pipeline registers hold intermediate results
- Basic hazard detection and forwarding added later

---

### Step 7: **Bus Interface — Wishbone Protocol**
- Create `wishbone_if.sv` and `bus_arbiter.sv`
- Implements simple bus master/slave model
- Core sends request; arbiter grants access to shared RAM
- Handles load/store timing and memory access conflicts

---

### Step 8: **Top-Level Integration**
- Create `riscv_core.sv` for each core
- Create `top.sv` to instantiate:
  - Two cores
  - Shared memory
  - Bus arbitration logic
- Define memory map:
  - Instruction ROM per core
  - Shared RAM
  - Peripherals (optional)

---

### Step 9: **Testbenches and Programs**
- Write programs in assembly or C, compile with `riscv32-unknown-elf-gcc`
- Convert to `.hex` or `.mem` using `objcopy`
- Test using:
  - `core_tb.sv` — test a single core in isolation
  - `multi_core_tb.sv` — test both cores accessing shared memory

---

### Step 10: **Performance Counters (Optional)**
- Add `cycle_counter` and `instr_counter` in each core
- Compute IPC (Instructions Per Cycle)
- Dump to memory or UART

---


### Inference Program Flow:

**Core 0**
- Loads `x[]` and `W1`, `b1`
- Computes `h[] = ReLU(x ⋅ W1 + b1)`
- Stores `h[]` to shared RAM

**Core 1**
- Loads `h[]`, `W2`, `b2`
- Computes `y = step(h ⋅ W2 + b2)`
- Stores final `y` to output address

---

This project walks you through building a **single-core 8-bit softcore processor** in **Verilog**, capable of performing binary classification using a perceptron model. It is designed for learners interested in embedded machine learning, processor architecture, and RTL hardware design.

The processor executes a small, hardcoded program stored in instruction memory (ROM) to classify data using fixed-point arithmetic. The design is simple, modular, and synthesizable, making it ideal for educational use or FPGA prototyping.

---

## Machine Learning Model: Binary Perceptron Classifier

We implement the following forward-pass model:

### Forward Pass:
```math
y = \text{step}(x_1 \cdot w_1 + x_2 \cdot w_2 + \text{bias})
```
- Inference is hardcoded as an instruction program
- Inputs, weights, bias, and output are stored in data memory
- Step activation function is implemented in hardware using the ALU

             +------------------------+
             |     Program Counter    |
             |        (PC)            |
             +-----------+------------+
                         |
                         v
             +------------------------+
             |   Instruction Memory   |  
             |   (instruction_memory) |
             +-----------+------------+
                         |
             +-----------v------------+
             |      Control Unit      |  
             |       (control)        |
             +--+----+----+----+------+
                |    |    |    |
                |    |    |    +--> mem_we
                |    |    +-------> reg_we
                |    +-----------> alu_ctrl (to ALU)
                +---------------> opcode/operand

                         |
                         v
                 +-------+------+
                 |   Datapath   |   
                 +-------+------+
                         |
     +-------------------+------------------+
     |                                      |
     v                                      v

+-------------+                     +----------------+
| Register    |                    |   Data Memory   |  
| File        |            | (data_memory.v) |
| (R0–R7)     |                    +--------+--------+
+------+------+                             |
       |                                     |
       | read_data1/read_data2              | read/write
       v                                     v
+-------------+                      +-----------------+
|     ALU     |  ← Step 3            |  ALU Result     |
| (add, mul,  |<-------------------->| or Load Result  |
|  step, nop) |                      +-----------------+
+------+------+                                 |
       |                                         |
       +-------------------+---------------------+
                           v
                    +-------------+
                    | Write-Back  | (to Register File)
                    +-------------+

## System Highlights

- 8-bit datapath with fixed-point arithmetic
- Instruction-driven execution using a small ROM
- Supports basic instructions: `LOAD`, `STORE`, `ADD`, `MUL`, `ACT`, `NOP`
- Modular Verilog design for reuse and clarity
- Easy to simulate and synthesize

---

## Memory Map for Perceptron Model

| Address        | Contents            |
|----------------|---------------------|
| `0x00`         | Input `x1`          |
| `0x01`         | Weight `w1`         |
| `0x02`         | Input `x2`          |
| `0x03`         | Weight `w2`         |
| `0x04`         | Bias                |
| `0x0D`         | Output `y` (0 or 1) |

All values are 8-bit fixed-point integers.

---

## Design Steps

###  Step 1: **ALU — Core Arithmetic Logic**
- Create `alu.v`
- Supports `ADD`, `MUL`, `ACT`, `NOP`
- Purely combinational — **independent of other modules**
- Easy to unit test early

###  Step 2: **Register File — Temporary Storage**
- Create `register_file.v`
- 8 registers (`R0`–`R7`), each 8-bit wide
- Supports **2 reads**, **1 write** per cycle
- Requires clock — so test with simple `clk` and `we`

###  Step 3: **Data Memory — Input/Output Storage**
- Create `data_memory.v`
- 8-bit wide memory block for holding inputs, weights, bias, and output
- Acts as the processor’s RAM
- Optional: single-port or dual-port version depending on design

### Step 4: **Instruction Memory — Program ROM**
- Create `instruction_memory.v`
- Read-only memory with pre-defined 8-bit instructions
- Feeds instructions to the control unit
- Use `case` or memory array for ROM contents

### Step 5: **Control Unit — Decoder & Signal Generator**
- Create `control.v`
- Decodes opcode from instruction (`instr[7:4]`)
- Generates control signals:
  - `alu_ctrl`
  - `reg_we`
  - `mem_we`
- Provides `opcode` and `operand` to datapath

### Step 6: **Datapath — Integration Layer**
- Create `datapath.v`
- Connects:
  - Instruction → control
  - Register file → ALU
  - ALU ↔ Data memory
- Implements the actual flow of data per cycle
- Uses control signals from the `control.v` module

### Step 7: **Top-Level — System Integration**
- Create `top.v`
- Instantiates:
  - Program Counter (PC)
  - Instruction memory
  - Datapath
  - Control unit
  - Clock/reset handling
- This module defines the **execution flow of the processor**


## Design Strategy

| Layer         | Modules                          | Responsibility                          |
|--------------|----------------------------------|------------------------------------------|
| **Logic Layer** | `alu.v`, `register_file.v`, `data_memory.v` | Stateless logic, memory, and arithmetic |
| **Control Layer** | `control.v`                   | Instruction decoding, signal generation |
| **Storage Layer** | `instruction_memory.v`        | Stores the program itself                |
| **Execution Layer** | `datapath.v`, `top.v`          | Data routing and control integration     |


### Inference Program Flow (Instruction ROM):

1. Load `x1` and `w1` from memory
2. Compute `R2 = x1 * w1`
3. Load `x2` and `w2` from memory
4. Compute `R3 = x2 * w2`
5. Add partial products: `R4 = R2 + R3`
6. Load `bias` and add to sum: `R5 = R4 + bias`
7. Apply activation: `R6 = step(R5)`
8. Store result `R6` back to memory at `0x0D`

---
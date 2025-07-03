
## Overall Project Flow

This project demonstrates the complete flow from **training a machine learning model** to **running inference in a custom-built 8-bit Verilog processor**. The workflow is divided into four main stages:

---

### 1. Python Model Training (`perceptron_model/train_perceptron.py`)

- A simple binary classification model (Perceptron) is trained using the **Iris dataset**.
- Only two classes (`Setosa` vs `Versicolor`) and two features (`sepal length`, `sepal width`) are used.
- The model is trained using `scikit-learn` and the final weights, bias, and test input are extracted.
- These values are scaled/quantized into 8-bit integers.

---

### 2. Export to HEX File (`data.hex`)

- The quantized input (`x1`, `x2`), weights (`w1`, `w2`), and bias are saved as **hex values**, one per line:
  ```
  x1
  w1
  x2
  w2
  bias
  ```
- This file is used as an **initial memory image** for the Verilog data memory.
- Format matches `$readmemh` syntax, compatible with Verilog simulation.

---

### 3. Verilog Processor Modules (`verilog/`)

- A custom 8-bit processor is designed in Verilog with the following components:
  - `instruction_memory.v` — holds a fixed instruction sequence
  - `control.v` — decodes instructions and generates control signals
  - `register_file.v` — holds temporary values
  - `alu.v` — performs `ADD`, `MUL`, `ACT` (step), etc.
  - `data_memory.v` — reads `data.hex`, holds inputs and output
  - `datapath.v` — connects everything together
  - `top.v` — top-level integration of processor
  - `top_tb.v` — testbench for simulation

---

###  4. Compilation and Simulation

#### Compile (with Icarus Verilog):
```bash
iverilog -o cpu.vvp *.v
```

#### Run Simulation:
```bash
vvp cpu.vvp
```

- During simulation, the processor:
  - Loads `x1`, `x2`, `w1`, `w2`, and `bias` from memory
  - Executes `MUL`, `ADD`, and `step()` activation
  - Stores final binary classification result to `mem[13]`
- Output is displayed using `$display` or observed in `wave.vcd`

---

### Final Output

- `data.hex` — memory input file (from Python)
- `wave.vcd` — waveform file (optional)
- Simulation output — classification result `y = 0` or `1`

---

This project connects ML concepts with hardware design, offering hands-on experience with training, quantization, memory mapping, instruction execution, and full-cycle hardware/software co-design.

## Project Scope and Limitations

This project implements a minimal 8-bit processor in Verilog to perform a forward pass of a simple **binary perceptron model**. It demonstrates how trained machine learning parameters (inputs, weights, bias) can be encoded as memory and executed as instructions in hardware.

This is a **proof-of-concept** designed for educational and simulation purposes only.

---

### Project Scope

- Trains a simple binary classifier (Perceptron)
- Quantizes inputs, weights, and bias to 8-bit integers
- Uses a Verilog-based processor to simulate inference
- Hardcoded instruction sequence and memory mapping
- Demonstrates the full flow from ML → HEX → Hardware Execution

---

### Project Limitations

| Area | Limitation |
|------|------------|
| Instruction Flow | No support for loops, branches, conditionals (e.g., `JMP`, `BEQ`) |
| Program Flexibility | Instructions are hardcoded in Verilog (`case` block) — not loaded dynamically |
| Arithmetic Precision | Only 8-bit integer math, no Q-format, fixed-point, or overflow detection |
| Pipeline | No instruction pipelining — one operation at a time (not cycle-efficient) |
| Scalability | Cannot handle larger models, deeper layers, or vectorized operations |
| Data Movement | No memory-mapped IO, UART, external input support |
| Verilog Limitations | No modular typing (`struct`, `enum`), no assertions or formal checks |
| Interactivity | Outputs are stored into a memory location but not exposed dynamically |

---
### Why This Is a Demonstration-Only Project

This project is **not designed for real-time ML inference** or deployment in hardware. It serves as a learning tool to understand:

- How processors work at the RTL level
- How ML computations can be broken down into hardware operations
- How to pass trained model parameters into hardware using hex memory files
- How to simulate dataflow using a finite instruction set

---

> This project is intentionally minimal, and is best used to **illustrate concepts**, **teach processor basics**, and **connect ML theory to hardware practice.**

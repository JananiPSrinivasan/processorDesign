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

## Why the Output May Be Inaccurate

This project successfully demonstrates a working inference flow for a trained perceptron model. However, the output may appear "incorrect" or unreliable due to several known and expected limitations:

### Summary of Limitations Affecting Output

| Limitation | Impact |
|------------|--------|
| **Single-layer Perceptron** | Can only learn linearly separable problems. If the selected features do not allow a clear linear boundary, the model will misclassify. |
| **Feature Choice** | This demo uses only sepal length and width. These are not the most discriminative features in the Iris dataset — petal features work better. |
| **No Scaling / Precision Loss** | Weights and inputs are scaled with `scale = 1`, so decimal values are truncated. This leads to loss of important learned patterns. |
| **Step Activation** | Uses a hard `step()` function, which flips output between 0 and 1 with no smooth transition. Minor numeric shifts can change the output. |
| **No Label Comparison** | The simulation does not compare the output with the actual label of the test input, so correctness cannot be evaluated directly. |

---

### Why This Is Still Valid

This project is not intended to be a high-accuracy classifier, but rather to:

- Demonstrate the **end-to-end integration** of ML and hardware
- Show how ML models can be encoded into Verilog logic
- Provide a **working template** for building more advanced ML-capable processors

---

> This project is intentionally minimal, and is best used to **illustrate concepts**, **teach processor basics**, and **connect ML theory to hardware practice.**

# Perceptron Model for 8-bit Processor (Python)

This folder contains the ML workflow to train a **binary perceptron classifier**, extract features, quantize inputs/weights, and export a `.hex` file compatible with the Verilog-based 8-bit processor.

The trained model is not executed in Python — it is used to **generate the values that the Verilog processor will execute during simulation**, enabling you to simulate **hardware-based ML inference**.

---

## ML Model Overview

We use a **simple single-layer perceptron** for binary classification. The model computes:

```math
y = \text{step}(x_1 \cdot w_1 + x_2 \cdot w_2 + \text{bias})
```

All values (inputs, weights, bias) are converted to **8-bit fixed-point integers** and written to a `data.hex` file. This file is loaded into the processor’s data memory.

---

## Dataset and Features

We use the classic **Iris dataset**, reduced to a binary classification task:

- **Classes used**: Setosa (0) vs Versicolor (1)
- **Features selected**: Petal length and petal width

---

## Design Steps

### Step 1: **Load and Filter Dataset**
- Use `sklearn.datasets.load_iris()`
- Select only 2 classes (`y != 2`)
- Choose 2 features: `petal length` and `petal width`

---

### Step 2: **Train a Perceptron Model**
- Use `sklearn.linear_model.Perceptron`
- Train on filtered dataset
- Evaluate performance (optional)

---

### Step 3: **Quantize Inputs and Weights**
- Normalize features (optional)
- Scale all values to 8-bit range (e.g., Q1.7 format or just simple integer scaling)
- Convert inputs, weights, and bias to integers

---

### Step 4: **Export to `data.hex`**
- Write the following values into a hex file (one per line):
  - `x1`
  - `w1`
  - `x2`
  - `w2`
  - `bias`
- Example output:
  ```
  02
  03
  01
  02
  FF
  ```

---

### Step 5: **Use in Verilog Simulation**
- Place `data.hex` in the `verilog/` folder or adjust your Verilog path
- Load using `$readmemh("data.hex", mem);` inside `data_memory.v`
- Simulate the processor to verify classification result (0 or 1)

---

## Files in This Folder

| File | Purpose |
|------|---------|
| `train_perceptron.py` | Trains model and exports `data.hex` |
| `data.hex` | Memory image for Verilog processor (input/output) |
| `weights.json` *(optional)* | Saves raw model weights and bias |

---

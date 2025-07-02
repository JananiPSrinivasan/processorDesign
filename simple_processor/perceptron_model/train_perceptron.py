# Step 1: Load and prepare dataset

import pandas as pd
from sklearn.preprocessing import LabelEncoder
import os
import zipfile

print(zipfile.is_zipfile("iris.zip"))
# Path to the dataset zip
zip_path = "F:\\processor_design\\simple_processor\\perceptron_model\\iris.zip"
dataset_path = "F:\\processor_design\\simple_processor\\perceptron_model\\iris\\iris.data"  

# Automatically unzip if not already
if not os.path.exists(dataset_path):
    print("Dataset not found. Extracting...")
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall("iris")
    print("Extraction complete.")

# Load the .data file (adjust file name as needed)
df = pd.read_csv("F:\\processor_design\\simple_processor\\perceptron_model\\iris\\iris.data", header=None)

# OPTIONAL: print first few rows to understand structure
print(df.head())

# Filter only Setosa and Versicolor
df = df[df[4] != 'Iris-virginica']


# Select two features (adjust column indices as needed)
X = df[[0, 1]].values  # e.g., column 0 = x1, column 1 = x2

# Select label column (binary classification)
y = df[4].values       

# If labels are strings, encode them to 0 and 1
le = LabelEncoder()
y = le.fit_transform(y)
# Step 2: Train the model, quantize, and export to data.hex

from sklearn.linear_model import Perceptron

# Train perceptron model
model = Perceptron(max_iter=1000)
model.fit(X, y)

# Extract weights and bias
w1, w2 = model.coef_[0]
bias = model.intercept_[0]

# Pick a test input (or use fixed values)
x1, x2 = X[0]  # Use first row as test input

# Quantize to 8-bit integer values (simple scaling, e.g., scale=1 or 64 for fixed-point)
scale = 1
x1_q = int(x1 * scale)
x2_q = int(x2 * scale)
w1_q = int(w1 * scale)
w2_q = int(w2 * scale)
bias_q = int(bias * scale)

# Export to data.hex
with open("data.hex", "w") as f:
    for val in [x1_q, w1_q, x2_q, w2_q, bias_q]:
        f.write(f"{val & 0xFF:02x}\n")  # Ensure 8-bit hex values

print("Export complete: data.hex created.")

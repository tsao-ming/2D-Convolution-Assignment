# 2D Convolution Processor Design (Final Project)

This repository contains the Verilog implementation and fixed-point simulation results of a 2D Convolution Processor, developed as the final project for the [Hardware Description Languages] course.

## 🧠 Project Overview

We designed and implemented a two-dimensional convolution processor that performs kernel-based filtering on input image data. The processor supports different kernel sizes and can be configured to operate in various hardware architectures (referred to as Architecture 1, 2, and 3).

## 📌 Features

- Supports **3×3** and **5×5** kernel convolution
- Fixed-point data processing: **8-bit input → 16-bit output**
- Achieves **SQNR > 30 dB**
- Includes Verilog simulation and testbench
- Three architecture variants explored and implemented

## 📂 File Structure
.
├── src/ # Verilog source files
│ ├── conv_core.v
│ ├── line_buffer.v
│ ├── controller.v
│ └── top.v
├── tb/ # Testbench and simulation scripts
│ └── tb_top.v
├── doc/ # Fixed-point computation and SQNR report
│ └── conv_calculation.xlsx / hand_calc.png
└── README.md


## ▶️ How to Simulate

You can simulate the design using **ModelSim** or **Icarus Verilog**:

```bash
# Compile
iverilog -o sim_out src/*.v tb/tb_top.v

# Run simulation
vvp sim_out

gtkwave dump.vcd

🧪 Fixed-point Validation
Floating-point results were calculated using Python/C/Excel

Fixed-point outputs were derived and validated

Achieved SQNR (Signal-to-Quantization-Noise Ratio): > 30 dB

📘 Course Info
Final Project for Hardware Description Languages
Department of Electronic Engineering, Chung Yuan Christian University
Semester: Spring 2025
Instructor: Prof. XXX

🧑‍💻 Contributors
Xxx (Your name)

Collaborators (if any)

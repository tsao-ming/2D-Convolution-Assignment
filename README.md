# 2D Convolution Processor Design (Final Project)

This repository contains the Verilog implementation and fixed-point simulation results of a 2D Convolution Processor, developed as the final project for the **Hardware Description Languages** course.

---

## 🧠 Project Overview

We designed and implemented a two-dimensional convolution processor that performs kernel-based filtering on input image data.  
The processor supports different kernel sizes and can be configured to operate in various hardware architectures (Architecture 1, 2, and 3).

---

## 📌 Features

- Supports **3×3** and **5×5** kernel convolution
- Fixed-point data processing: **8-bit input → 16-bit output**
- Achieves **SQNR > 30 dB**
- Includes Verilog simulation and testbench
- Implements three architecture variants

---

## 📂 File Structure

```

.
├── src/                      # Verilog source files
│   ├── conv\_core.v
│   ├── line\_buffer.v
│   ├── controller.v
│   └── top.v
├── tb/                       # Testbench and simulation scripts
│   └── tb\_top.v
├── doc/                      # Fixed-point calculation and SQNR report
│   └── conv\_calculation.xlsx / hand\_calc.png
└── README.md

````

---

## ▶️ How to Simulate

You can simulate the design using **ModelSim** or **Icarus Verilog**:

```bash
# Compile
iverilog -o sim_out src/*.v tb/tb_top.v

# Run simulation
vvp sim_out

# View waveform
gtkwave dump.vcd
````

---

## 🧪 Fixed-point Validation

* Floating-point results were calculated using Python / C / Excel
* Fixed-point outputs were derived and validated
* Achieved **SQNR (Signal-to-Quantization-Noise Ratio) > 30 dB**

---

## 📘 Course Info

> Final Project for **Hardware Description Languages**
> Department of Electronic Engineering, Chung Yuan Christian University
> Semester: Spring 2025
> Instructor: Prof. TANG, SONG-NIEN

---

## 🧑‍💻 Contributors

* tsao-ming

---

## ⚠️ Academic Integrity Notice

This project was submitted as part of the coursework for the **Hardware Description Languages** class at Chung Yuan Christian University.

All contents in this repository are original and created for educational purposes.  
**Unauthorized copying, reuse, or submission of any part of this project for academic credit by others is strictly prohibited.**

Violators may be reported for academic misconduct.

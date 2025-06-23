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

## 🏗️ Architecture 3 — Extended Design Description

In this project, we adopted **Architecture 3** to implement an extendable 2D convolution processor. This architecture allows both the input feature maps (IFMD) and kernel weights (KW) to be dynamically written into internal memory by the **Testbench (TM)**, supporting flexible data loading and reuse.

To enhance functionality, we further extended the design to support the following:

---

### ✅ a. Multi-Input Feature Map Convolution ("One Layer")

Our processor supports **multiple input feature maps**, allowing it to compute the output of a full convolutional layer.

* The TM sequentially writes **N input feature maps** (e.g., 2 or 4) into the data memory.
* Each feature map is convolved with its corresponding kernel weight matrix.
* The results are accumulated internally to produce the final output feature map (OFM).
* This matches typical CNN behavior:

  $$
  OFM = \sum_{i=1}^{N} (IFMD_i \ast KW_i)
  $$

---

### ✅ b. Configurable Kernel Size (3×3 or 5×5)

We implemented a **kernel-size configurable design**, controlled by an `is_5x5` input signal:

* When `is_5x5 = 0`, the processor performs **3×3 convolution**
* When `is_5x5 = 1`, it performs **5×5 convolution**
* The data memory access and weight fetch logic automatically adjust according to the kernel size

This flexible design avoids redundant hardware, enabling runtime configurability without modifying the code.

---

### 🧠 Summary

By extending **Architecture 3**, our implementation supports both:

* **Multi-channel convolution (layer-level processing)**
* **Runtime kernel-size switching**

These features make our design more flexible and closer to real-world CNN applications.

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
iverilog -f .\filelist.txt

# Run simulation
vvp a.out

# View waveform
gtkwave .\bench_wave.vcd
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

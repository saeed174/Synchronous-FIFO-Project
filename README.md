# 🧠 Synchronous FIFO Design & Verification  
**Author:** Saeed Nabawy  
**Program:** Digital Design Diploma – with Eng. Kareem Waseem  
**Tools & Technologies:** SystemVerilog, QuestaSim, Assertion-Based Verification, Functional Coverage  

---

## 📘 Project Overview

This project focuses on the **design and verification of a Synchronous FIFO (First-In First-Out) buffer**, which is a fundamental element in digital systems for managing data flow between subsystems operating under the same clock domain.

The FIFO design ensures **data integrity, predictable timing, and robust control signaling** through comprehensive RTL and verification methodologies using **SystemVerilog**.

---

## ⚙️ Design Specifications

| Parameter | Description | Default |
|------------|--------------|----------|
| `FIFO_WIDTH` | Data input/output bus width | 16 |
| `FIFO_DEPTH` | FIFO memory depth | 8 |

### 🔑 FIFO Ports

| Port | Direction | Description |
|------|------------|-------------|
| `data_in` | Input | Data written into the FIFO |
| `data_out` | Output | Data read from the FIFO |
| `wr_en` | Input | Write enable signal |
| `rd_en` | Input | Read enable signal |
| `clk` | Input | Clock signal |
| `rst_n` | Input | Active-low asynchronous reset |
| `full` | Output | Indicates FIFO is full |
| `almostfull` | Output | Indicates one slot left before full |
| `empty` | Output | Indicates FIFO is empty |
| `almostempty` | Output | Indicates one slot left before empty |
| `overflow` | Output | Indicates write attempt when full |
| `underflow` | Output | Indicates read attempt when empty |
| `wr_ack` | Output | Write acknowledgment |

---

## 🧩 Verification Environment

The verification environment was implemented in **SystemVerilog**, consisting of reusable and modular components.

### **Testbench Structure**
- **Top Module:** Generates clock and reset, connects DUT to interface.
- **Interface:** Bundles signals between DUT, monitor, and testbench.
- **Transaction Class (`FIFO_transaction`):**
  - Holds input/output variables.
  - Defines random constraints for `wr_en` and `rd_en`.
  - Allows adjustable read/write enable distributions.
- **Coverage Class (`FIFO_coverage`):**
  - Collects **cross-functional coverage** between enable signals and all status flags.
  - Ensures complete state-space exploration.
- **Scoreboard Class (`FIFO_scoreboard`):**
  - Implements a **reference model** that compares DUT outputs against expected behavior.
  - Tracks correct vs. error counts and prints runtime summaries.
- **Monitor:**
  - Samples DUT interface signals on each clock edge.
  - Passes transactions for coverage and checking using fork-join parallelism.

---

## 🧠 Assertions & Conditional Compilation

- Added **SystemVerilog Assertions (SVA)** to check:
  - Reset behavior
  - Pointer wraparound and boundaries
  - Overflow and Underflow detection
  - Full, Empty, Almost Full, and Almost Empty flag correctness
  - Write Acknowledge behavior
- Guarded assertions using:
  ```verilog
  `ifdef SIM
  // Assertions here
  `endif

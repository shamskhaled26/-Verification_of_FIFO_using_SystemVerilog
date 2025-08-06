# Verification of Synchronous FIFO using SystemVerilog

This repository showcases the **design and verification** of a synchronous FIFO (First-In, First-Out) module using **SystemVerilog**, including both functional RTL and a robust SystemVerilog verification environment.

---

## 📚 Project Overview

A synchronous FIFO is a data buffering circuit operating within a **single clock domain**, supporting simultaneous read/write operations. It maintains **data integrity**, and flags for **empty**, **full**, **underflow**, and **overflow**, making it essential in high-speed digital systems :contentReference[oaicite:1]{index=1}.

This repository targets:
- Correct RTL design of a parametric FIFO (configurable **data width** and **depth**).
- Comprehensive verification using **SystemVerilog Assertions (SVA)** and a UVM-like modular environment.
- Detection of edge cases: simultaneous read/write, overflow, underflow, pointer wraparound, and reset behavior:contentReference[oaicite:2]{index=2}.

---

---

## ⚙️ Features & Capabilities

### Design (RTL)
- Parameterized FIFO: configurable **WIDTH** and **DEPTH**
- Two pointers (`wr_ptr`, `rd_ptr`) with wrap-around logic
- Status flags: `full`, `empty`
- Error signals: `overflow`, `underflow`
- Correct behavior during simultaneous read/write operations

### Verification (SV Testbench)
- **Interfaces** encapsulating DUT signals for cleaner connectivity
- **Random stimulus** via sequences of read/write operations
- **Scoreboard-based checking** against a reference (e.g., RTL or software model)
- **SystemVerilog Assertions** to validate:
  - Reset behavior (reset clears pointers and sets `empty`)
  - No writes when FIFO is full (`wr_en && full`)
  - No reads when FIFO is empty (`rd_en && empty`)
  - Correct pointer increments and data consistency :contentReference[oaicite:3]{index=3}
- **Functional coverage** targeting:
  - Combinations of write/read enables
  - Empty/full flag transitions
  - Overflow/underflow scenarios

---

## 🧪 Usage Instructions

### Prerequisites
- A SystemVerilog-compatible simulator (e.g. QuestaSim, VCS, XSIM)
- Support for coverage and assertions


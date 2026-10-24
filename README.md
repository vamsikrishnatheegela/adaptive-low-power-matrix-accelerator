# Adaptive Low-Power Matrix-Multiplication Accelerator

[![RTL regression](https://github.com/vamsikrishnatheegela/adaptive-low-power-matrix-accelerator/actions/workflows/rtl-regression.yml/badge.svg)](https://github.com/vamsikrishnatheegela/adaptive-low-power-matrix-accelerator/actions/workflows/rtl-regression.yml)

A staged SystemVerilog portfolio project for a signed INT8 matrix-multiplication tile and adaptive low-power control. This is a baseline scaffold; physical clock gating, power gating, DVFS hardware, and RTL-to-GDSII results are **not yet implemented or measured**.

## Contents
- `rtl/mac_tile_2x2.sv`: combinational signed INT8 2×2 matrix multiply.
- `rtl/matrix_accelerator.sv`: sequential start/busy/done wrapper around the tile.
- `rtl/adaptive_power_manager.sv`: power-state and operating-point control-plane FSM.
- `tb/`: self-checking testbenches for arithmetic, control sequencing, and the sequential wrapper.
- `scripts/run_iverilog.sh`: reproducible simulation regression.
- `docs/`: architecture, roadmap, and results template.

## Run
Requirements: Icarus Verilog (`iverilog`, `vvp`), Bash; GNU Make is optional.

```bash
bash scripts/run_iverilog.sh
# or
make test
```

The script builds in a temporary directory and removes artifacts on exit.

## Datapath
For signed 2×2 matrices, `C=A×B`. Each input is signed 8-bit; each output is signed 17-bit, sufficient for the sum of two signed 8×8 products:
```text
c00 = a00*b00 + a01*b10    c01 = a00*b01 + a01*b11
c10 = a10*b00 + a11*b10    c11 = a10*b01 + a11*b11
```
This is a small verification-friendly starting point, not a production accelerator.

## Low-power implementation boundaries
- `compute_enable` is an enable intent, not a gated clock. ASIC implementation should use a library ICG cell or supported clock-gating transformation; do not AND a clock with a combinational signal.
- `power_domain_on` is a request, not a physical power switch. Real power gating needs power switches, isolation, reset/retention policy, sequencing, and supported power intent such as UPF.
- DVFS is modeled through operating-point request/acknowledge. RTL alone does not change voltage or guarantee safe clock frequencies.
- Report only measured tool outputs; do not invent area, timing, power, or energy savings.

## Project status
| Feature | Status |
|---|---|
| Signed INT8 2×2 tile | Baseline RTL included |
| Datapath testbench | Passing in GitHub Actions (103 vectors) |
| Power-manager FSM | Baseline RTL and testbench passing in CI |
| Sequential start/busy/done wrapper | RTL and testbench passing in CI |\n| ICG mapping / physical gated clock | Not implemented |
| UPF, switches, isolation, retention | Not implemented |
| Physical DVFS | Not implemented |
| Synthesis / RTL-to-GDSII PPA | Not measured |

See [architecture](docs/ARCHITECTURE.md), [roadmap](docs/ROADMAP.md), and [results template](docs/RESULTS_TEMPLATE.md).

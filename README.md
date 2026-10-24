# Adaptive Low-Power Matrix-Multiplication Accelerator

[![RTL regression](https://github.com/vamsikrishnatheegela/adaptive-low-power-matrix-accelerator/actions/workflows/rtl-regression.yml/badge.svg)](https://github.com/vamsikrishnatheegela/adaptive-low-power-matrix-accelerator/actions/workflows/rtl-regression.yml)

A SystemVerilog portfolio project for a signed INT8 matrix-multiplication tile and adaptive low-power control. The RTL regression passes, and an OpenLane 2.3.10 SKY130A RTL-to-GDSII flow has completed. The physical low-power mechanisms remain control-plane models; see the [physical-design results and signoff gaps](docs/PHYSICAL_DESIGN_RESULTS.md).

## Contents
- `rtl/mac_tile_2x2.sv`: combinational signed INT8 2×2 matrix multiply.
- `rtl/matrix_accelerator.sv`: sequential start/busy/done wrapper around the tile.
- `rtl/adaptive_power_manager.sv`: power-state and operating-point control-plane FSM.
- `tb/`: self-checking testbenches, including a 502-vector independent arithmetic scoreboard.
- `scripts/run_iverilog.sh`: reproducible simulation regression.
- `docs/`: architecture, roadmap, results template, and [physical-design results](docs/PHYSICAL_DESIGN_RESULTS.md).
- `openlane_config.json`: reproducible OpenLane configuration for the integrated top module.

## Run
Requirements: Icarus Verilog (`iverilog`, `vvp`), Bash; GNU Make is optional.

```bash
bash scripts/run_iverilog.sh
# or
make test
```

The script builds in a temporary directory and removes artifacts on exit. The independent arithmetic scoreboard uses a fixed seed for reproducibility.

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
| Datapath testbench | Directed/random test (103 vectors); independent scoreboard (502 vectors) |
| Power-manager FSM | Baseline RTL and testbench passing in CI |
| Sequential start/busy/done wrapper | RTL and testbench passing in CI |
| ICG mapping / physical gated clock | Not implemented; enable intent only |
| UPF, switches, isolation, retention | Not implemented; power control is a model |
| Physical DVFS | Not implemented; request/ack control-plane model only |
| Generic synthesis | Completed with Yosys; generic cell count is not physical area |\n| OpenLane RTL-to-GDSII | Flow completed; GDS/DEF/LEF generated, LVS and DRC passed |\n| Physical signoff | Open: antenna, slew/fanout/capacitance issues and dedicated signoff SDC remain |

See [architecture](docs/ARCHITECTURE.md), [roadmap](docs/ROADMAP.md), [results template](docs/RESULTS_TEMPLATE.md), and [physical-design results](docs/PHYSICAL_DESIGN_RESULTS.md).

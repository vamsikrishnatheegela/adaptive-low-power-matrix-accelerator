# Roadmap

## Stage 1 — Baseline
- [x] Signed INT8 2×2 tile and testbench
- [x] Power-manager FSM scaffold and testbench
- [x] Reproducible Icarus Verilog script
- [ ] Run regression locally and fix all failures
- [ ] Add CI regression

## Stage 2 — Integration and verification
- [ ] Add sequential wrapper with start/ready/busy/done
- [ ] Add independent reference scoreboard
- [ ] Add quiesce/idle acknowledgement and defined reset behavior
- [ ] Add assertions and functional coverage
- [ ] Test wake-up and operating-point changes under busy/idle conditions

## Stage 3 — Low-power implementation
- [ ] Integrate ICG cell or supported clock-gating mapping
- [ ] Add isolation, reset/retention controls, and power intent
- [ ] Verify power sequencing with compatible tools
- [ ] Define clock/voltage operating-point constraints

## Stage 4 — Physical flow
- [ ] Select target PDK/library and compatible RTL-to-GDSII flow
- [ ] Add constraints and pin/clock planning
- [ ] Run synthesis, floorplanning, placement, CTS, routing, and checks where supported
- [ ] Save tool versions, scripts, logs, and reports

## Stage 5 — Evaluation
Compare always-active, clock-gated, power-sequenced, and adaptive operating-point configurations. Record workload, cycles, throughput, area, timing, wake-up latency, activity, and tool-derived power estimates. State assumptions; never present estimates as measured silicon power.

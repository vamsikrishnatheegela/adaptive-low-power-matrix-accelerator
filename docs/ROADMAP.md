# Roadmap

## Stage 1 — Baseline
- [x] Signed INT8 2×2 tile and testbench
- [x] Power-manager FSM scaffold and testbench
- [x] Reproducible Icarus Verilog script
- [x] Run baseline regression locally; all three original tests passed
- [x] Add CI regression (GitHub Actions passed on current RTL revision)

## Stage 2 — Integration and verification
- [x] Add sequential wrapper with start/busy/done and passing directed test
- [x] Add independent signed-integer reference scoreboard (502 vectors)
- [x] Add a power-aware top-level integration model with transaction admission and deferred sleep
- [x] Add integration test for active-work sleep deferral and wake-up sequencing
- [ ] Add explicit quiesce/idle acknowledgement and stronger reset behavior
- [ ] Add assertions and functional coverage
- [x] Test wake-up and operating-point changes in integrated busy/idle scenarios

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

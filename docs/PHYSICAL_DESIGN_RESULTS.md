# Physical Design Results

## Latest observed implementation run

- **Flow:** OpenLane 2.3.10
- **PDK:** SkyWater SKY130A
- **Top module:** `power_aware_matrix_accelerator`
- **Clock target:** 20 ns (50 MHz)
- **Run ID:** `RUN_2026-10-24_14-41-17`
- **Flow completion:** 78/78 stages completed
- **Generated outputs:** GDS, DEF, LEF, timing SDC, and implementation netlists
- **Antenna:** Passed
- **LVS:** Passed
- **DRC:** Passed
- **Maximum slew/capacitance:** Checker emitted warnings for multiple corners; log also printed “No max slew violations found” and “No max cap violations found.” Treat these checks as **unresolved until the detailed reports are inspected**.

This is a significant RTL-to-GDSII implementation milestone. It is not yet a clean signoff result: the max-slew/max-capacitance checker output is internally inconsistent, 442 lint warnings remain, and some flow warnings require review.

## Current antenna-repair configuration

The tracked `openlane_config.json` enables:

- `GRT_ANTENNA_ITERS: 10` and `GRT_ANTENNA_MARGIN: 20`
- `RUN_HEURISTIC_DIODE_INSERTION: true`
- `GPL_CELL_PADDING: 2` and `DPL_CELL_PADDING: 2`
- `DRT_ANTENNA_REPAIR_ITERS: 5` and `DRT_ANTENNA_MARGIN: 20`

The latest observed run reports antenna, LVS, and DRC as passed with this configuration.

## Warnings in the latest run

The run log reported:

- 442 Verilator lint warnings; inspect the warning details and distinguish RTL issues from generated-file/timescale warnings.
- Global-routing messages: `GRT-0097 No global routing found for nets` (and similar messages).
- Detailed-routing warning that `LEF58_ENCLOSURE` without `CUTCLASS` is unsupported for layer `mcon`.
- Large routed nets with many pins, which may affect routing performance.
- The wire-length checker was skipped because no threshold was configured.
- `VSRC_LOC_FILES` was not supplied; power-integrity/IR-drop results may therefore be inaccurate.
- An output pin lacks antenna-diffusion information in the cell definition; review the relevant OpenROAD antenna-property warning.
- Maximum-slew and maximum-capacitance checker warnings for `max_ss_100C_1v60`, `min_ss_100C_1v60`, and `nom_ss_100C_1v60`, despite contradictory “No ... violations found” messages.

Do not assume the slew/capacitance warnings are harmless. Inspect the detailed reports and confirm whether actual violating nets/pins remain.

## Next checks

From the repository root, identify the latest run and locate the checker reports:

```bash
RUN="$(find runs -maxdepth 1 -type d -name 'RUN_*' -printf '%T@ %p\\n' | sort -nr | head -n 1 | cut -d' ' -f2-)"
echo "Latest run: $RUN"
find "$RUN" -type f \\( -iname '*slew*' -o -iname '*cap*' -o -iname '*manufacturability*' \\) -print
grep -RniE 'violation|violations|worst slack|VIOLATED|No max (slew|cap)' "$RUN" \\
  --include='*.rpt' --include='*.json' --include='*.log' 2>/dev/null | head -n 200
```

Before signoff, verify:
- Antenna, DRC, and LVS reports remain clean.
- Maximum slew, maximum capacitance, and maximum fanout have no unresolved violations.
- PNR and signoff SDCs are loaded, relevant ports are constrained, and timing reports show no unconstrained paths.
- Power-integrity checks use appropriate source-location inputs if IR-drop results are to be relied on.

## Historical metrics from an earlier run

The following numbers are preserved from `RUN_2026-10-24_14-02-13`. That run used fallback timing constraints before the repository SDC was wired into the OpenLane configuration. These metrics are historical and must not be attributed to the latest run.

| Metric | Historical reported value |
| --- | ---: |
| Standard-cell instance count | 5,421 |
| Instance area | 34,493.1 platform area units |
| Die area | 89,713.5 platform area units |
| Core area | 80,026.8 platform area units |
| IO count | 161 |
| Reported total power | 0.05078 (flow-reported units) |
| Setup worst slack | 6.103 ns (reported metric) |
| Hold worst slack | 0.107 ns (reported metric) |
| Setup TNS / WNS | 0 / 0 |
| Hold TNS / WNS | 0 / 0 |

Area and power are flow-reported values tied to the platform and implementation setup, not independent silicon measurements. Do not claim measured power savings from these estimates.

## Reproduction

From the repository root, with OpenLane 2 installed and a SKY130A PDK available:

```bash
openlane \\
  --pdk-root "$HOME/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af" \\
  --pdk sky130A \\
  openlane_config.json
```

Adjust `--pdk-root` for your local PDK installation. Run directories and generated reports are local build artifacts and should not be committed wholesale.

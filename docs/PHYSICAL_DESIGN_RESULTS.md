# Physical Design Results

## Most recent observed implementation run

- **Flow:** OpenLane 2.3.10
- **PDK:** SkyWater SKY130A
- **Top module:** `power_aware_matrix_accelerator`
- **Clock target:** 20 ns (50 MHz)
- **Run ID:** `RUN_2026-10-24_14-30-18`
- **Flow completion:** 78/78 stages completed
- **Generated outputs:** GDS, DEF, LEF, timing SDC, and implementation netlists
- **LVS:** Passed
- **DRC:** Passed
- **Antenna:** Not clean; final summary reported **3 net violations and 3 pin violations** after repair

Flow completion means the implementation steps ran; it does not mean the layout is clean for signoff. The antenna issues and reported electrical-rule warnings remain open.

## Current antenna-repair configuration

Commit `f141cd8` updates `openlane_config.json` with documented controls for both global-route and detailed-route mitigation:

- `GRT_ANTENNA_ITERS: 10` and `GRT_ANTENNA_MARGIN: 20`
- `RUN_HEURISTIC_DIODE_INSERTION: true`
- `GPL_CELL_PADDING: 2` and `DPL_CELL_PADDING: 2` for heuristic diode insertion placement
- `DRT_ANTENNA_REPAIR_ITERS: 5` and `DRT_ANTENNA_MARGIN: 20`

**These settings have not yet been validated by a new OpenLane run.** Re-run the flow and inspect the final manufacturability/antenna reports; do not describe antenna closure until the final report confirms zero violations.

## Historical metrics from an earlier run

The following numbers are preserved from `RUN_2026-10-24_14-02-13`. That run used fallback timing constraints before the repository SDC was wired into the OpenLane configuration. These metrics are historical and must not be attributed to later runs.

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

## Outstanding checks

The implementation logs also reported lint warnings, global-routing messages for nets, an unsupported LEF58 enclosure construct in antenna processing, a high-fanout net, missing IR-analysis input data, and max-slew/max-capacitance violations. Review the reports from the newest run rather than assuming these are resolved by the antenna configuration changes.

Before signoff, verify:
- Zero final antenna violations.
- Max slew, max capacitance, and max fanout are within the library rules.
- The configured PNR and signoff SDCs are loaded, all relevant ports are constrained, and timing reports show no unconstrained paths.
- Required DRC/LVS and power-integrity checks are clean with the intended signoff setup.

## Reproduction

From the repository root, with OpenLane 2 installed and a SKY130A PDK available:

```bash
openlane \
  --pdk-root "$HOME/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af" \
  --pdk sky130A \
  openlane_config.json
```

Adjust `--pdk-root` for your local PDK installation. Run directories and generated reports are local build artifacts and should not be committed wholesale.

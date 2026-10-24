# Physical Design Results

## Run summary

- **Flow:** OpenLane 2.3.10
- **PDK:** SkyWater SKY130A
- **Top module:** `power_aware_matrix_accelerator`
- **Clock constraint:** 20 ns (50 MHz target)
- **Run date:** 2026-10-24
- **Flow completion:** 78/78 stages completed
- **Generated outputs:** GDS, DEF, LEF, timing SDC, and synthesized/placed netlists
- **LVS:** Passed
- **DRC:** Passed
- **Antenna check:** Not clean; violations remain after repair
- **Timing:** Reported setup/hold violation counts are zero under the flow's configured constraints; this is not signoff evidence because dedicated PNR/signoff SDC files were not supplied and fallback constraints were used.

## Reported implementation metrics

Values below are copied from the OpenLane run metrics. Interpret area and power in the context of the selected platform and flow configuration; these are not independent silicon measurements.

| Metric | Reported value |
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

## Outstanding physical-design checks

The final manufacturability summary reports **1 antenna-net violation and 3 antenna-pin violations** after antenna repair. The antenna report also contains pre-repair entries for six nets/pins; use the final summary when describing the end state.

The run also reports:
- 17 max-slew violations across checked corners
- 8 max-fanout violations
- 1 max-capacitance violation in the aggregated metric (corner-specific metrics vary)
- 442 Verilator lint warnings, many of the shown examples are timescale warnings in generated files
- Generic fallback SDC used because dedicated PNR and signoff SDC files were not configured
- Missing routing/IR-analysis inputs were flagged by the flow

## Interpretation

This is a successful **RTL-to-GDSII flow execution and useful implementation milestone**, but it is **not a clean signoff result**. LVS and DRC passed; antenna and electrical-rule issues and the incomplete signoff constraint setup remain open. Do not describe the design as tapeout-ready or claim measured power savings from these flow estimates.

## Reproduction

From the repository root, with OpenLane 2 installed and a SKY130A PDK available:

```bash
openlane \
  --pdk-root "$HOME/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af" \
  --pdk sky130A \
  openlane_config.json
```

Adjust `--pdk-root` to match the local PDK installation. The run directory and generated reports are local build artifacts and should not be committed wholesale.

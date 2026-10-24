# Physical Design Artifacts

## Source Run

- Flow: OpenLane
- Run directory: `runs/RUN_2026-10-24_15-11-48`
- Top module: `power_aware_matrix_accelerator`

## Files

| File | Description |
|---|---|
| `power_aware_matrix_accelerator.gds` | Final GDSII layout |
| `power_aware_matrix_accelerator.nl.v` | Final routed gate-level netlist |
| `power_aware_matrix_accelerator.def` | Final physical-design database export |
| `power_aware_matrix_accelerator.sdc` | Final timing constraints |
| `metrics.json` | Final OpenLane metrics |
| `SHA256SUMS` | SHA-256 checksums |

## Verification Status

All five RTL regression stages passed. The recorded OpenLane run completed and generated the physical-design outputs. Antenna, LVS, and DRC checks passed in that run.

The final metrics still report maximum-slew and maximum-capacitance violations in slow process corners. Complete electrical signoff has not been established.

## Integrity Check

From the repository root, run:

    sha256sum -c artifacts/physical_design/SHA256SUMS

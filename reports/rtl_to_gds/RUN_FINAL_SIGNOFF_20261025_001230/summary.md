# RTL-to-GDS Run Summary

- **Run tag:** `RUN_FINAL_SIGNOFF_20261025_001230`
- **Flow result:** PASS — complete
- **Signoff assessment:** **RTL-TO-GDS SIGNOFF CHECKS PASSED**

| Check | Result |
|---|---|
| RTL regression | PASS |
| RTL-to-GDS flow | PASS — complete |
| GDS | Generated |
| Final antenna check | PASS (0 violations) |
| Maximum slew | PASS (0 violations) |
| Maximum capacitance | PASS (0 violations) |
| Maximum fanout | PASS (0 violations) |
| Setup timing | PASS (5.1126 ns slack) |
| Hold timing | PASS (0.0412 ns slack) |
| LVS | PASS |
| DRC | PASS |

- **Original run directory:** `runs/RUN_FINAL_SIGNOFF_20261025_001230`
- **Flow log:** `reports/openlane/RUN_FINAL_SIGNOFF_20261025_001230.log`
- **Evidence bundle:** `reports/rtl_to_gds/RUN_FINAL_SIGNOFF_20261025_001230/`
- **Visuals:** `docs/images/physical_design/`
- **Copied GDS:** `reports/rtl_to_gds/RUN_FINAL_SIGNOFF_20261025_001230/power_aware_matrix_accelerator.gds`

## Warnings to review

> The flow completed and the final checkers determine pass/fail. These warnings are retained for engineering review; they are not silently discarded.
- `[18:42:55] WARNING  [RSZ-0020] found 2 floating nets.            ]8;id=433525;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/openroad.py\openroad.py]8;;\:]8;id=921566;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/openroad.py#314\314]8;;\`
- `[18:43:47] WARNING  [GRT-0243] Unable to repair antennas on net  ]8;id=405672;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/openroad.py\openroad.py]8;;\:]8;id=794782;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/openroad.py#314\314]8;;\`
- `[18:45:27] WARNING  Threshold for Threshold-surpassing long wires ]8;id=275881;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/checker.py\checker.py]8;;\:]8;id=141485;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/checker.py#108\108]8;;\`
- `[18:45:34] WARNING  'VSRC_LOC_FILES' was not given a value,     ]8;id=825976;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/openroad.py\openroad.py]8;;\:]8;id=71235;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/steps/openroad.py#2249\2249]8;;\`
- `[18:46:41] WARNING  [Checker.LintWarnings] 447 Lint warnings found.  ]8;id=538144;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/flows/flow.py\flow.py]8;;\:]8;id=90446;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/flows/flow.py#701\701]8;;\`
- `[18:46:41] WARNING  [OpenROAD.IRDropReport] 'VSRC_LOC_FILES' was not ]8;id=411136;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/flows/flow.py\flow.py]8;;\:]8;id=797813;file:///nix/store/7zqpr7slgvjfjcqfabb2fmlpvc8k23ax-python3-3.13.9-env/lib/python3.13/site-packages/librelane/flows/flow.py#701\701]8;;\`

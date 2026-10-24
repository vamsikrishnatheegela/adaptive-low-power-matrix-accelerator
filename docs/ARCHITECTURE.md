# Architecture

## Datapath
`mac_tile_2x2` computes a signed INT8 2×2 matrix product. Inputs are signed 8-bit and outputs signed 17-bit, preserving the sum of two signed 8×8 products. The combinational implementation is a deliberately small starting point for arithmetic verification.

## Power manager
- **ACTIVE:** permits computation when `workload_active` is asserted.
- **DVFS_WAIT:** pauses computation and requests the selected operating point until `dvfs_ack`.
- **POWER_OFF:** requests the accelerator domain be powered off after the environment indicates idle.
- **WAKE_WAIT:** requests power on and waits for `power_good`, then proceeds to the operating-point handshake.

Operating-point encoding: 0=low, 1=nominal, 2=high. This is a control-plane model, not a physical voltage regulator or clock generator.

## Integration requirements
1. Keep the manager in an always-on domain.
2. Add a quiesce/idle acknowledgement before removing power.
3. Implement isolation, reset sequencing, and retention policy as required.
4. Use a library ICG cell or supported synthesis mapping; never gate a clock with a raw combinational AND.
5. Use supported power intent (such as UPF) and actual power switches for physical power gating.
6. Resume only after power-good and operating-point acknowledgement.

## Known limitations
This baseline lacks a quiesce handshake, isolation/retention controls, timeout recovery, and a sequential accelerator wrapper. These are required before production-style claims.

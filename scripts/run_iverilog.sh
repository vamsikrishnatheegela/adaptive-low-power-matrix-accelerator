#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if ! command -v iverilog >/dev/null 2>&1 || ! command -v vvp >/dev/null 2>&1; then
  echo "ERROR: Icarus Verilog required (iverilog and vvp not found)." >&2
  exit 127
fi
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT
echo "[1/3] Matrix tile"
iverilog -g2012 -Wall -s tb_mac_tile_2x2 -o "$BUILD_DIR/tb_mac" "$ROOT/rtl/mac_tile_2x2.sv" "$ROOT/tb/tb_mac_tile_2x2.sv"
vvp "$BUILD_DIR/tb_mac"
echo "[2/3] Power manager"
iverilog -g2012 -Wall -s tb_adaptive_power_manager -o "$BUILD_DIR/tb_power" "$ROOT/rtl/adaptive_power_manager.sv" "$ROOT/tb/tb_adaptive_power_manager.sv"
vvp "$BUILD_DIR/tb_power"
echo "[3/3] Sequential matrix accelerator"
iverilog -g2012 -Wall -s tb_matrix_accelerator -o "$BUILD_DIR/tb_accel" "$ROOT/rtl/mac_tile_2x2.sv" "$ROOT/rtl/matrix_accelerator.sv" "$ROOT/tb/tb_matrix_accelerator.sv"
vvp "$BUILD_DIR/tb_accel"
echo "All available simulations passed."

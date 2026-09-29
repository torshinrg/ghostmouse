# Contributing

GhostMouse is currently in an exploratory phase. Please prefer small, reproducible changes.

## Good contributions

- documentation of chipset/driver behavior
- reproducible raw-data captures
- read-only instrumentation patches
- latency measurements
- signal-processing experiments
- negative results with enough detail to reproduce them

## Kernel / driver changes

For early driver work:

1. keep patches minimal
2. do not modify RF power or calibration data
3. avoid RF/baseband writes unless the experiment explicitly requires them
4. retain a known-good kernel/module for recovery
5. document the exact kernel version and hardware ID

## Commit style

Use short imperative commit messages, for example:

- `docs: document RTL8821CE baseline`
- `rtw88: expose raw PHY status via debugfs`
- `tools: add labelled capture script`

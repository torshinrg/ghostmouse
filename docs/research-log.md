# Research log

## 2026-09-29 — initial feasibility pass

### Confirmed

- RTL8821CE is running with the in-kernel `rtw88_8821ce` driver.
- The adapter reports a single TX and RX antenna / one VHT spatial stream.
- Monitor mode is supported.
- No concurrent interface combinations are advertised by the current device/driver.
- Stock `rtw88` debugfs exposes PHY/RF diagnostics.
- Simple RSSI polling is noisy even with a stationary setup and is not enough for cursor tracking.

### Working hypothesis

The useful sensing signal, if available, must come from richer per-packet PHY information rather than a single RSSI number.

### Next experiment

Instrument the existing receive path and export the raw PHY-status buffer (or all available parsed fields) while remaining connected in managed mode.

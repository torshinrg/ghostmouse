# GhostMouse

**A software-only pointing device experiment using sensors already built into a laptop.**

GhostMouse explores whether ordinary laptop hardware — starting with Wi-Fi channel/PHY information and later optional acoustic sensing — can estimate hand motion well enough to control a desktop cursor without a mouse, camera, wearable, or external tracking device.

> Status: early research prototype. No working cursor tracking yet.

## Why

The core question is simple:

> Can a normal laptop become its own pointing device using only hardware it already has?

The initial target is **Wi-Fi-first sensing**. Instead of using RSSI alone, GhostMouse aims to inspect lower-level receive-side PHY information from the Wi-Fi driver and determine whether hand motion produces a stable signal that can be mapped to relative cursor movement.

The long-term design may combine multiple built-in sensors:

- Wi-Fi PHY / CSI-like measurements
- acoustic sensing through speakers + microphones (optional)
- other laptop sensors where available

The user should be able to disable any sensing source independently. A future `Wi-Fi only` mode should remain completely silent.

## Current hardware target

Initial development is being done on:

- Realtek RTL8821CE 802.11ac PCIe adapter (`10ec:c821`)
- Linux `rtw88_8821ce`
- mac80211 / cfg80211
- 1x1 TX/RX radio
- 5 GHz Wi-Fi

The adapter supports managed and monitor modes, but the current Linux interface reports no supported concurrent interface combinations. The preferred design therefore does **not** depend on monitor mode: sensing should ideally tap PHY metadata from ordinary RX traffic while the interface stays connected normally.

## Intended architecture

```text
Wi-Fi AP
   │
   │ normal network traffic
   ▼
RTL8821CE
   ▼
rtw88 RX path
   ├──────────────► Linux networking ► normal Internet access
   │
   └──────────────► PHY exporter ► feature stream
                                  │
                                  ▼
                           motion estimator
                                  │
                                  ▼
                             virtual mouse
```

Future sensor fusion:

```text
              motion estimator
              ▲              ▲
              │              │
       Wi-Fi features    acoustic features
              │              │
          Wi-Fi PHY      mic + speaker
```

## First milestone

Do **not** try to build the mouse yet.

First prove that useful motion information can be extracted from the RTL8821CE receive path without breaking ordinary Wi-Fi connectivity.

### Milestone 0 — baseline

- [x] Identify adapter and driver
- [x] Confirm `rtw88_8821ce`
- [x] Confirm monitor capability
- [x] Inspect `rtw88` debugfs endpoints
- [x] Verify RSSI alone is too noisy for useful hand tracking

### Milestone 1 — raw RX/PHY visibility

- [ ] Map the RTL8821C RX + PHY-status code path in current Linux
- [ ] Document the exact raw PHY-status structures delivered by hardware/firmware
- [ ] Determine which values are currently discarded by `rtw88`
- [ ] Export raw or minimally parsed PHY-status samples to userspace
- [ ] Keep normal managed-mode Wi-Fi working while collecting samples

### Milestone 2 — motion signal

- [ ] Record labelled datasets: still / left / right / forward / back
- [ ] Determine whether movement is distinguishable above normal channel noise
- [ ] Measure update rate and end-to-end latency
- [ ] Estimate relative velocity rather than absolute hand position

### Milestone 3 — cursor prototype

- [ ] Convert motion estimates to `dx/dy`
- [ ] Add filtering and confidence gating
- [ ] Feed relative movement through Linux `uinput`
- [ ] Evaluate usability and false motion

### Milestone 4 — optional sensor fusion

- [ ] Add acoustic sensing as an optional source
- [ ] Support Wi-Fi-only / acoustic-only / hybrid modes
- [ ] Fuse sources based on confidence
- [ ] Investigate pet-safe and silent defaults

## Safety / driver development

Early work should be **read-only on the RF side**.

The first driver patches should only copy or expose receive metadata that the driver already receives. Avoid experimenting with:

- RF register writes
- EEPROM / EFUSE writes
- transmit-power overrides
- firmware flashing
- arbitrary baseband register writes

A buggy read-side kernel patch can still crash the driver or kernel, but reverting to the stock kernel/module should restore normal operation. Development should always keep a known-good boot option available.

## Non-goals (for now)

- absolute 3D hand tracking
- gesture recognition as the primary interface
- camera-based hand tracking
- custom external radar hardware
- requiring a wearable or powered ring

## Repository layout

```text
docs/
  architecture.md
  rtl8821ce-notes.md
  research-log.md
tools/
  collect-baseline.sh
.github/ISSUE_TEMPLATE/
```

## Contributing

This is an experimental hardware/software research project. Reproducible measurements, driver notes, chipset-specific findings, and failed experiments are all useful contributions.

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT. See [LICENSE](LICENSE).

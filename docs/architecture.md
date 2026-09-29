# Architecture

## Design principle

GhostMouse should use an ordinary connected Wi-Fi interface whenever possible. The intended production design must not require switching the user's adapter away from managed mode just to sense hand motion.

## Data path

1. The access point sends ordinary 802.11 traffic.
2. RTL8821CE receives frames and PHY metadata.
3. `rtw88` parses the RX descriptor and PHY-status payload.
4. A minimal exporter copies selected receive metadata into a bounded userspace-facing buffer.
5. Userspace timestamps and records samples.
6. A motion estimator converts temporal changes into relative motion.
7. A Linux `uinput` device emits relative mouse movement.

## Why relative movement

The project does not need absolute hand coordinates. A pointing device only needs a stable mapping from recent motion to cursor deltas:

```text
hand motion -> estimated velocity -> dx/dy -> cursor
```

This is potentially much easier than determining a precise 2D/3D hand location from a single 1x1 Wi-Fi radio.

## Export mechanism candidates

Evaluate in roughly this order:

1. debugfs — easiest for the first proof of concept
2. relayfs / tracepoints — better for higher-rate streams
3. generic netlink — more structured userspace API
4. dedicated character device — only if justified

The first exporter should optimize for observability and safety, not API elegance.

## Timing

Record timestamps as close to RX parsing as practical. Userspace must be able to estimate:

- samples per second
- burstiness
- packet-to-packet spacing
- processing latency
- signal stability while stationary

Cursor work should not start until the sample stream is understood.

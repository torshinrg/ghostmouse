# RTL8821CE / rtw88 notes

## Observed system

- PCI device: Realtek RTL8821CE 802.11ac PCIe Wireless Network Adapter (`10ec:c821`)
- Kernel module: `rtw88_8821ce`
- Linux wireless stack: mac80211/cfg80211
- Available antennas reported: TX `0x1`, RX `0x1`
- VHT: one spatial stream
- Supported interface types include managed, AP and monitor
- `iw phy` reports monitor as a software interface mode
- current device reports `interface combinations are not supported`

## Existing debugfs visibility

The stock driver exposes a useful `rtw88` debugfs tree including:

- `phy_info`
- `rf_dump`
- baseband register dumps
- MAC register dumps
- `read_reg`
- `rf_read`
- writable low-level endpoints such as `rf_write` and `write_reg`

The stock `phy_info` view shows receive rates, RSSI and counters, while several fields such as EVM/SNR/CFO may be zero or not meaningfully populated on this configuration.

## Important constraint

RSSI is not a suitable primary sensing feature. It fluctuates during an otherwise static setup and does not provide enough information to reliably infer direction of small hand motion.

The next research task is therefore to inspect the raw PHY-status path before information is summarized or discarded.

## Driver investigation checklist

- locate RTL8821C RX descriptor parsing
- locate `phy_status` extraction
- locate chip-specific `query_phy_status` implementation
- enumerate PHY-status page layouts / structs
- identify which fields are copied to `pkt_stat`
- identify unused bytes / fields
- identify whether any channel-estimate-like data reaches host memory
- add a read-only exporter before touching RF configuration

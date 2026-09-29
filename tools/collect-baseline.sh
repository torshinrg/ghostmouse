#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-ghostmouse-baseline-$(date +%Y%m%d-%H%M%S).txt}"
PHY="/sys/kernel/debug/ieee80211/phy0"

{
  echo "# GhostMouse baseline"
  echo "# generated: $(date --iso-8601=seconds)"
  echo
  echo "## uname"
  uname -a
  echo
  echo "## PCI network devices"
  lspci -nnk | grep -A3 -i network || true
  echo
  echo "## iw dev"
  iw dev || true
  echo
  echo "## iw phy phy0 info"
  iw phy phy0 info || true
  echo
  echo "## link"
  iw dev wlan0 link || true
  echo
  echo "## rtw88 phy_info"
  if [[ -r "$PHY/rtw88/phy_info" ]]; then
    cat "$PHY/rtw88/phy_info"
  else
    sudo cat "$PHY/rtw88/phy_info" 2>/dev/null || true
  fi
} > "$OUT"

echo "Wrote $OUT"

#!/usr/bin/env bash
set -euo pipefail
mkdir -p captures
for f in cap1 cap2 cap3; do
  if [[ ! -s "/tmp/${f}.pcap" ]]; then
    echo "ERROR: /tmp/${f}.pcap is missing or empty. Keep the original capture files and try again."
    exit 1
  fi
done
sudo cp /tmp/cap1.pcap /tmp/cap2.pcap /tmp/cap3.pcap captures/
sudo chown "$(id -u):$(id -g)" captures/cap1.pcap captures/cap2.pcap captures/cap3.pcap
chmod 644 captures/*.pcap
ls -lh captures/*.pcap
echo "PCAP files copied successfully into captures/."

# Skill Lab 2 – Three-Point Packet Capture

**Student:** Ramagiri Rishik  
**Subject:** Computer Networks  
**Lab:** Skill Lab 2 – Three-Point Capture

## Objective
Capture and analyze traffic at three points in a routed network path: Host 1, a router, and Host 2. Examine packet flow, TTL, TCP payload, retransmissions, and round-trip time.

## Network topology

```text
Host 1                         Router                         Host 2
10.0.1.1/30  --- 10.0.1.2/30 | 10.0.2.1/30 --- 10.0.2.2/30
```

Virtual interfaces:
- Host 1: `veth-h1`
- Router left: `veth-r1`
- Router right: `veth-r2`
- Host 2: `veth-h2`

## Tools
Ubuntu, `iproute2`, `tshark`, Wireshark, `netcat-openbsd`, `mtr-tiny`, and `tc` (traffic control/netem).

## Work completed
1. Installed the required networking tools.
2. Created network namespaces `host1`, `router`, and `host2`.
3. Created and connected two virtual Ethernet pairs.
4. Configured IP addresses and enabled IPv4 forwarding on the router.
5. Added routes and tested Host 1 to Host 2 connectivity.
6. Applied `20ms` delay and `1%` packet loss to router interface `veth-r2`.
7. Captured traffic at Host 1, router, and Host 2.
8. Sent text from Host 1 to Host 2 using Netcat on TCP port `1234`.
9. Analyzed directional TTL values, extracted TCP payload, counted retransmissions, and ran MTR.
10. Inspected the router capture in Wireshark.

## Observed results

### Directional TTL (Host 1 → Host 2)

| Capture point | Filtered TTL |
|---|---:|
| Host 1 (`cap1.pcap`) | 64 |
| Router (`cap2.pcap`) | 64 |
| Host 2 (`cap3.pcap`) | 63 |

The TTL decreased by one between the router-side and Host 2 capture, consistent with one routed hop.

### TCP message
The following application data was extracted from the router capture:

```text
Hello from host1!
This is Rishik
Three Point Capture Lab
Message going through router
```

### TCP retransmission analysis

| Capture | Retransmissions reported by TShark |
|---|---:|
| cap1 | 0 |
| cap2 | 0 |
| cap3 | 0 |

A configured 1% loss rate is probabilistic; it does not guarantee that a retransmission will occur in a short capture.

### MTR report
The later MTR run (10 report cycles) showed:

| Hop | Loss | Average RTT |
|---|---:|---:|
| Router (`10.0.1.2`) | 0.0% | 1.4 ms |
| Host 2 (`10.0.2.2`) | 0.0% | 21.7 ms |

An earlier 10-cycle run showed 10% loss at Host 2; a subsequent run showed 0%. This variation is possible with a probabilistic 1% netem loss setting and a small probe count. The later run is recorded above; both observations are preserved in `results.txt`.

## Evidence
See the `screenshots/` folder. Screenshots were captured from the student's lab session and show the saved capture files, TTL analysis, extracted message, retransmission counts, Wireshark inspection, and MTR output.

## Packet capture files
The actual `.pcap` files are generated on the student's Ubuntu/WSL machine in `/tmp/`. They are not embedded in this archive because this workspace cannot access files inside the student's Ubuntu environment. Run `bash collect-captures.sh` from this folder in Ubuntu to copy the three original PCAPs into `captures/` before committing, then verify that the files are non-empty.

## Conclusion
The three-point packet capture experiment was carried out. Host 1 successfully sent application data to Host 2 through the router. The directional TTL analysis showed the expected one-hop decrement, and Wireshark displayed the TCP payload. MTR reported an average RTT of about 21.7 ms to Host 2 in the later run, consistent with the configured 20 ms one-way delay plus processing and return-path effects.

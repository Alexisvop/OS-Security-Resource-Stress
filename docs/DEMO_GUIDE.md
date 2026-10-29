# Demonstration guide — non-stress track

The purpose of this guide is to produce a credible portfolio walkthrough **without generating resource exhaustion, killing processes, or changing host configuration**.

## 1. Static validation

```bash
bash tests/static_checks.sh
```

This invokes `bash -n` against each source script. It checks Bash syntax only: it does not establish runtime correctness, safety, or compatibility.

## 2. Read the architecture and risks

```bash
sed -n '1,180p' docs/ARCHITECTURE.md
sed -n '1,180p' docs/SECURITY_REVIEW.md
```

Use the README diagram to explain the five components and the experimental A/B/C design.

## 3. Optional, non-stress monitoring preview (Linux only)

```bash
bash scripts/detector.sh
# Stop with Ctrl+C.
```

The detector reads the running system's CPU, RAM, disk, processes, port listeners, `/tmp`, `/dev/shm`, and its experiment log if present. It writes `/tmp/detector_log.txt` and displays periodic diagnostic observations. This is a monitor, **not** a malware scan; it may report normal processes as unusual.

Do not execute `scripts/malware_sim.sh`, `scripts/kill_malware.sh`, or `scripts/proteccion.sh` as part of this walkthrough.

## 4. Artifacts to collect for a credible CV

- A screenshot of the monitor showing CPU/RAM/disk and process information (blur usernames/IPs if needed).
- The terminal result of the syntax checker.
- The architecture diagram visible on GitHub.
- **Only after safety remediation and controlled VM testing:** anonymized A/B/C data, a concise methodology, a sample report, and reproducible test-environment specifications.

Do not fabricate performance percentages, recovery rates, or images of successful tests.

## 5. Suggested 30-second presentation

> "I built a Bash-based operating-systems security lab to explore how resource-intensive workloads affect Linux. I implemented modules for CPU, memory, disk and process activity, added system monitoring and a three-stage performance comparison, and documented the containment and hardening approaches. My review also identified concrete safety limitations—such as process cleanup scope and resource caps—that would be essential to address before a general-use release."

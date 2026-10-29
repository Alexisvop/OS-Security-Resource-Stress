# Architecture and technical walkthrough

## System boundary

This repository contains an academic **Linux availability/observability experiment**, not malware that spreads or establishes persistence. The simulation generates local load; the detector reads operating-system statistics and temporary artifacts; the measurement script samples A/B/C scenarios; the cleanup and hardening scripts demonstrate administrative techniques but have significant safety limitations.

## Modules and interface

| Script | Inputs | Relevant side effects | Output |
|---|---|---|---|
| `malware_sim.sh` | Interactive selection (CPU, RAM, disk, processes, all) | Launches child processes, writes under `/tmp` and `/dev/shm`, records process IDs | `/tmp/.malware_pids`, `/tmp/malware_activity.log` and temporary workload files |
| `detector.sh` | CPU/RAM/disk/process thresholds defined near top | Reads system information; overwrites `/tmp/detector_log.txt` | Alerts on terminal, detector log |
| `kill_malware.sh` | Global temporary PID file, matching process/file names | Sends `SIGKILL`, deletes matching files and directories | Terminal verification summary |
| `proteccion.sh` | Assumes `apt`, UFW, OpenSSH and privileged access | Installs packages; modifies system-wide networking/authentication/limits settings | Terminal output, host configuration changes |
| `medicion_desempenio.sh` | Interactive choice A/B/C/T/R | Samples host; writes temporary 50-MB disk test files, contacts `8.8.8.8` if network available | `/tmp/metricas_so/*.dat`, `.txt`, `.csv` |

## Data flow

```mermaid
sequenceDiagram
    autonumber
    participant Operator as Operator (isolated VM)
    participant Bench as Measurement script
    participant Stress as Academic stress script
    participant Kernel as Linux resources
    participant Detect as Detector
    participant Contain as Containment exercise
    Operator->>Bench: Baseline A
    Bench->>Kernel: Read resource metrics
    Operator->>Stress: Trigger authorized experiment (after safety fixes)
    Stress->>Kernel: Generate CPU/RAM/disk/process load
    Detect->>Kernel: Poll status and process list
    Detect-->>Operator: Show heuristic warnings
    Operator->>Bench: Under-load sample B
    Bench->>Kernel: Read resource metrics
    Operator->>Contain: Attempt cleanup
    Contain->>Kernel: Stop selected processes and remove artifacts
    Operator->>Bench: Post-containment sample C
    Bench-->>Operator: TXT report + CSV
```

## Metrics

The measurement script collects CPU usage, RAM utilization and available memory, disk utilization, approximate write/read bandwidth, ping latency, total/user process count, `/proc` listing response time, and 1-minute load average. Results are stored per scenario, then compared in a generated report.

**Methodology limitations:** Measurements are affected by sampling delay, caching, virtualization, locale-dependent output of Linux utilities, device contention, and network reachability. The result uses one host and must not be generalized to broader malware-detection accuracy or performance guarantees. A negative latency value (`-999`) is a missing measurement sentinel, not a valid ping time.

## Security model and assumptions

The original implementation assumes a disposable Linux VM, isolated from production networks. That assumption is written in comments but **not enforced in code**. The presence of a fixed duration is not sufficient to guarantee bounded child workload execution. The cleanup script's broad process matches are not process ownership verification. The hardening script is invasive and not idempotently reversible.

Read [SECURITY_REVIEW.md](SECURITY_REVIEW.md) before attempting dynamic validation.

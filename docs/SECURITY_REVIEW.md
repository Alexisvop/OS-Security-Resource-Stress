# Security review — publication baseline

**Scope:** static review of the five Bash scripts supplied in `Simulacion_Virus.zip` on 2026-10-29. No stress or hardening script was executed for this review. The archived academic source is preserved verbatim in `scripts/`. This is a **risk assessment**, not a certificate of safety.

## High-priority findings

| Severity | Area | Evidence in source | Risk and required remedy |
|---|---|---|---|
| **Critical** | `malware_sim.sh` | `stress_cpu` starts one persistent CPU worker per core, `stress_ram` repeatedly writes 50 MB to `/dev/shm`, and `stress_disk` repeatedly writes 100 MB files to `/tmp`. | Host/VM resource exhaustion. Add per-resource quotas, bounded iterations, process groups/cgroups, forced timeouts and sufficient free-space checks. |
| **High** | `malware_sim.sh` | `DURATION=120` and `check_time()` do not guarantee all grandchildren/child processes terminate or output files are cleaned. `trap cleanup EXIT SIGINT SIGTERM` may run cleanup on multiple traps; `SIGKILL` bypasses traps. | Residual load and artifacts after the top-level script stops. Implement supervised job control and idempotent cleanup. |
| **High** | `kill_malware.sh` | `pkill -9 -f "bc -l"`, `pkill -9 -f "dd if=/dev"`, `pkill -9 -f "malware_sim"`. | Can kill unrelated processes that happen to match. Replace with verified PIDs from an isolated run/session and avoid `-9` unless necessary. |
| **High** | `kill_malware.sh` | `rm -rf /tmp/malware_disco_*` and `rm -f /dev/shm/malware_*` via broad globs. | Can delete files not created by the current run. Use a private `mktemp -d` directory and verify ownership before deletion. |
| **High** | `proteccion.sh` | Executes `sudo apt install`, changes UFW policy, opens SSH port 22, edits `/etc/ssh/sshd_config`, `/etc/login.defs`, `/etc/security/limits.conf`, and restarts SSH. | Persistent changes, remote lockout, hard-to-reverse side effects. Default to read-only audit; request explicit opt-in; back up config and include rollback. Linux distro/SSH service vary. |
| **Medium** | `malware_sim.sh`, `detector.sh` | Predictable global `/tmp` and `/dev/shm` names and `> "$LOG_FILE"` truncation. | Collisions and possible unsafe interactions with shared files. Use per-user, per-run directories with correct permissions, no-follow creation and exclusive access. |
| **Medium** | `detector.sh` | Fixed thresholds, localized `top` parsing, process-count heuristic, imperfect `/tmp` discovery. | False positives/false negatives. Establish baselines, robust parsing, tests, and machine-readable telemetry. |
| **Medium** | `medicion_desempenio.sh` | Uses `ping 8.8.8.8`; writes two 50-MB temporary benchmark files; outputs `-999` if latency is missing. | Air-gapped VMs may fail latency measurement; disk benchmarking still modifies storage. Allow a local target, explicit missing-data indicator, and bound temporary writes. |

### Technical precision notes

- `stress_forks` generates children executing `sleep 999`; these **are not necessarily zombie processes**. A zombie is a terminated child whose parent has not reaped it. It is more accurate to call this *process proliferation*.
- High CPU/RAM/disk usage is not evidence that a process is malicious; the detector implements heuristic *anomaly alerts*, not malware attribution.
- A successful cleanup message does not prove all processes were terminated or that security settings were restored. `proteccion.sh` does not implement a rollback.
- The baseline/under-stress/after-containment experiment is not a controlled scientific benchmark until sampling conditions are standardized and independently reproduced.
- The script comments describe an "isolated VM," but the original scripts do **not enforce** that prerequisite.

## Recorded historical VM network configuration

The original operating-systems exercise reportedly ran on **Ubuntu Server in VirtualBox with a bridged network adapter**, controlled from Windows PowerShell over the LAN (likely SSH, not independently confirmed). This provides guest/host operating-system separation, **not a network isolation boundary**. Other LAN systems could potentially reach the guest's open services, subject to firewall policy. The historical execution is not evidence that the original scripts are safe for unmodified re-execution.

The more restrictive isolated/disconnected-network setup in the recommendations below is a **future-testing requirement**, not a description of how the coursework network was originally configured. For authorized local administration, a host-only adapter can permit Windows-to-Ubuntu connectivity without exposing the guest to the full LAN; alternatively, manage the VM from its console with network access disabled. Review exposure and firewall rules, take a snapshot, apply resource limits, and disable shared folders before considering any controlled dynamic test.

## Responsible execution policy

1. **Never execute the stress, cleanup, or hardening scripts on physical/personal/workstation/production/shared hosts.**
2. Treat the simulator as a risk-bearing workload, even though it has no self-replication or exfiltration code.
3. Before any dynamic testing, make the VM disposable; take a snapshot; disconnect external networks; set hypervisor CPU/memory/disk limits; retain console access; verify VM resource headroom.
4. Use **non-root** operation for experiments where possible. The hardening script must be reviewed line by line separately; it is not part of the safe default demonstration.
5. Prefer `bash tests/static_checks.sh` and the read-only monitoring walkthrough in [DEMO_GUIDE.md](DEMO_GUIDE.md).

## Improvement acceptance criteria

- Resource caps checked during execution: CPU worker count, max RAM written, max disk bytes, max child count and hard wall-clock timeout.
- Clean termination: no descendant processes or generated artifacts remain after normal exit, Ctrl+C, error or timeout.
- PID/session isolation: no reliance on global name-based process killing or global deletion globs.
- Least privilege: no root requirement for stress; hardening guarded by explicit dry-run/apply and audited reversible changes.
- Dynamic tests in a fresh snapshot VM with before/after `ps`, `free`, `df`, and logged observations.
- Sanitized sample metrics and method description, plus documentation of variability and expected false alerts.

## Publication status

This package is **suitable for code review as a documented academic prototype**, but the original simulator and hardening/cleanup scripts are **not cleared as safe-to-run demonstrations**. Keep the repository private until you are comfortable making the source and risk review public, and complete the high-priority hardening improvements before offering an executable public tutorial.

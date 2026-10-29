# Repository maintenance and publication

**GitHub repository:** https://github.com/Alexisvop/OS-Security-Resource-Stress

The project was uploaded as an academic, **private** code-review baseline. Do not make it
public until reviewing the risks in [`docs/SECURITY_REVIEW.md`](docs/SECURITY_REVIEW.md).

## Clone and validate

```bash
git clone https://github.com/Alexisvop/OS-Security-Resource-Stress.git
cd OS-Security-Resource-Stress
bash tests/static_checks.sh
```

The static test checks Bash syntax only; it does not execute any simulation or
make system changes. Inspect the GitHub Actions run for the same check.

## Before opening the repository to recruiters

1. Replace the original unbounded stress behavior with explicitly authorized,
   quota-limited workloads running only in a disposable, isolated VM.
2. Replace global `pkill` / deletion patterns with run-scoped cleanup, and add
   reliable termination and rollback.
3. Convert system hardening to read-only audit by default.
4. Re-run tests on a snapshot VM, and add real sanitized results and screenshots.
5. Check academic/team ownership and add an appropriate license if permitted.
6. Update this documentation with the safety improvements actually completed.
7. Only then consider making the repository public via GitHub repository settings.

## Suggested GitHub metadata

**Description:** Academic Linux OS security lab: controlled resource-stress concepts,
anomaly monitoring, containment analysis and performance comparisons.

**Topics:** linux, bash, operating-systems, security-lab, performance-monitoring,
resource-management, incident-response, academic-project.

## CV wording (English)

**Linux Security & Resource Stress Lab | Bash, Linux, Operating Systems**

- Developed an academic OS security lab integrating CPU, memory, disk and
  process stress scenarios with Linux monitoring.
- Implemented comparative baseline/stress/post-containment reporting to text/CSV.
- Documented process cleanup and system-hardening risks, and defined a safer
  VM-based validation roadmap.

Do not present numerical results or verified containment claims without evidence.

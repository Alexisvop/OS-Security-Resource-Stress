#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
shopt -s nullglob
scripts=(scripts/*.sh)
if (( ${#scripts[@]} != 5 )); then
  printf 'ERROR: expected 5 Bash source scripts; found %d\n' "${#scripts[@]}" >&2
  exit 1
fi
for script in "${scripts[@]}"; do
  bash -n "$script"
  printf 'PASS %s\n' "$script"
done
printf 'Syntax-only check complete. No workloads were executed.\n'

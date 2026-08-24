#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

bash -n "$ROOT/scripts/promote.sh"
bash -n "$ROOT/scripts/rollback.sh"
bash -n "$ROOT/scripts/gate.sh"
python -m py_compile "$ROOT/app/server.py"

grep -q 'track: canary' "$ROOT/k8s/canary-deployment.yaml"
grep -q 'track: stable' "$ROOT/k8s/stable-deployment.yaml"
grep -q 'selector:' "$ROOT/k8s/traffic-router.yaml"
grep -q 'path: /healthz' "$ROOT/k8s/canary-deployment.yaml"
grep -q 'path: /healthz' "$ROOT/k8s/stable-deployment.yaml"

if "$ROOT/scripts/gate.sh" 0.005 250 >/dev/null 2>&1; then :; else exit 1; fi
if "$ROOT/scripts/gate.sh" 0.020 250 >/dev/null 2>&1; then exit 1; fi
if "$ROOT/scripts/gate.sh" 0.005 600 >/dev/null 2>&1; then exit 1; fi
if "$ROOT/scripts/promote.sh" 5 >/dev/null; then :; else exit 1; fi
if "$ROOT/scripts/promote.sh" 10 >/dev/null 2>&1; then exit 1; fi

echo 'Project 25 tests passed.'

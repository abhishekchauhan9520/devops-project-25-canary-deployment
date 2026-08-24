#!/usr/bin/env bash
set -euo pipefail

error_rate="${1:-}"
p95_ms="${2:-}"
max_error_rate="${MAX_ERROR_RATE:-0.01}"
max_p95_ms="${MAX_P95_MS:-500}"

python - "$error_rate" "$p95_ms" "$max_error_rate" "$max_p95_ms" <<'PY'
import sys
error, p95, max_error, max_p95 = map(float, sys.argv[1:])
if error > max_error:
    print(f'ABORT: error rate {error:.4f} > {max_error:.4f}')
    raise SystemExit(1)
if p95 > max_p95:
    print(f'ABORT: p95 latency {p95:.1f}ms > {max_p95:.1f}ms')
    raise SystemExit(1)
print('PROMOTE: health gate passed')
PY

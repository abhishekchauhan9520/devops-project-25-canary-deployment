#!/usr/bin/env bash
set -euo pipefail

stage="${1:-}"
case "$stage" in
  5|25|50|100) ;;
  *) echo "Usage: $0 {5|25|50|100}" >&2; exit 2 ;;
esac

printf 'Promoting canary to %s%% traffic\n' "$stage"

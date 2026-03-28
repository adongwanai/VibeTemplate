#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

find runtime/checkpoints -maxdepth 1 -type f ! -name '.gitkeep' -delete
find runtime/logs -maxdepth 1 -type f ! -name '.gitkeep' -delete
find queue/failed -maxdepth 1 -type f ! -name '.gitkeep' -delete
find queue/pending-review -maxdepth 1 -type f ! -name '.gitkeep' -delete

printf 'Runtime artifacts cleaned.\n'

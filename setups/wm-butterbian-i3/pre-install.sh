#!/usr/bin/env bash

set -euo pipefail

readonly THIS_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
bash "${THIS_DIR}/scripts/add-butterrepo.sh"


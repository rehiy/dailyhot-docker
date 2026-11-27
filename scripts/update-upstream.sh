#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

front="$(git ls-remote --exit-code https://github.com/imsyy/DailyHot.git refs/heads/master | cut -f1)"
api="$(git ls-remote --exit-code https://github.com/imsyy/DailyHotApi.git refs/heads/master | cut -f1)"
[[ "$front" =~ ^[0-9a-f]{40}$ && "$api" =~ ^[0-9a-f]{40}$ ]]
printf 'DAILYHOT_REF=%s\nDAILYHOT_API_REF=%s\n' "$front" "$api" > versions.env

#!/bin/bash
set -euo pipefail
platform="$1"
image="$2"
name="dailyhot-smoke-${platform##*/}"

cleanup() {
    docker inspect --format '{{json .State}}' "$name" || true
    docker logs "$name" || true
    docker rm -f "$name" >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker run -d --name "$name" --platform "$platform" \
    -p 127.0.0.1::80 -e APP_COPYRIGHT=SmokeTest "$image"
address="$(docker port "$name" 80/tcp)"
for attempt in $(seq 1 60); do
    if [[ "$(docker inspect --format '{{.State.Running}}' "$name")" != true ]]; then
        echo 'Container exited before readiness checks completed.' >&2
        exit 1
    fi
    if curl --max-time 5 -fsS "http://$address/" > /tmp/dailyhot-index.html &&
        curl --max-time 5 -fsS "http://$address/api/all" |
            jq -e '.code == 200 and .count > 0 and (.routes | length > 0)' >/dev/null &&
        [[ "$(docker exec "$name" redis-cli ping)" == PONG ]]; then
        grep -qi '<html' /tmp/dailyhot-index.html
        docker exec "$name" sh -c 'grep -q SmokeTest /var/www/front/assets/*.js'
        exit 0
    fi
    sleep 2
done
exit 1

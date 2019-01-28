#!/bin/bash
set -o errexit
set -o nounset

handle_term() {
  printf 'Caught SIGTERM, quitting...\n' 1>&2
  [ -n "${child:-}" ] && kill -TERM "$child" 2>/dev/null || true
}

trap 'handle_term' TERM

smbd -FS --no-process-group &
child="$!"
wait "$child"

trap - TERM


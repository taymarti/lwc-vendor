#!/usr/bin/env sh
# Put the Lightweight Charts packages into this machine's npm cache, so `npm ci` in any project
# that locks these versions installs them from the cache instead of the registry.
# Run once per machine (and again after npm's cache is cleared). Usage: ./prime-cache.sh
set -e
here=$(cd "$(dirname "$0")" && pwd)
for t in "$here"/vendor/node-packages/*.tgz; do
  npm cache add "$t"
  echo "cached $(basename "$t")"
done

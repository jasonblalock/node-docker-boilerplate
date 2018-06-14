#!/bin/sh
# entrypoint.sh

set -e

cmd="$@"

if [ -e package.json ]; then
  yarn install --check-files
fi

exec $cmd
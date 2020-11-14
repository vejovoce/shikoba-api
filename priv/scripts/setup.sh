#!/bin/bash
set -e

/app/bin/shikoba eval "Shikoba.ReleaseTasks.migrate"
/app/bin/shikoba eval "Shikoba.ReleaseTasks.seed"

exec /app/bin/shikoba "$@"

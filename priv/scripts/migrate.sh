#!/bin/bash
set -e

/app/bin/shikoba eval "Shikoba.ReleaseTasks.migrate"

exec /app/bin/shikoba "$@"

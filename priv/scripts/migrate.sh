#!/bin/bash
set -e

/app/bin/vertico eval "Vertico.ReleaseTasks.migrate"

exec /app/bin/vertico "$@"

#!/bin/bash
set -e

/app/bin/vertico eval "Vertico.ReleaseTasks.migrate"
/app/bin/vertico eval "Vertico.ReleaseTasks.seed"

exec /app/bin/vertico "$@"

#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
COMPOSE=(docker compose --env-file docker/.env.local -f docker/docker-compose.local-postgres.yaml)
mkdir -p .local
case "${1:-start}" in
  start)
    "${COMPOSE[@]}" up -d --wait
    python3 - "$ROOT" <<'PY'
import os
import shutil
import subprocess
import sys
from pathlib import Path

root = Path(sys.argv[1])
services = {
    'backend': (root / 'backend', [str(root / 'backend/.venv/bin/python'), 'main.py', 'run', '--env=dev']),
    'web': (root / 'frontend/web', [shutil.which('node'), 'node_modules/vite/bin/vite.js', '--host', '127.0.0.1', '--strictPort']),
}
for name, (cwd, command) in services.items():
    pidfile = root / '.local' / f'{name}.pid'
    if pidfile.exists():
        try:
            os.kill(int(pidfile.read_text()), 0)
            print(f'{name}: already running')
            continue
        except ProcessLookupError:
            pass
    with (root / '.local' / f'{name}.log').open('ab') as log:
        process = subprocess.Popen(command, cwd=cwd, stdin=subprocess.DEVNULL,
                                   stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
    pidfile.write_text(str(process.pid))
    print(f'{name}: started PID {process.pid}')
PY
    echo '后台: http://127.0.0.1:6110/web/'
    echo 'API 文档: http://127.0.0.1:6100/api/v1/docs'
    ;;
  stop)
    python3 - "$ROOT" <<'PY'
import os
import signal
import sys
from pathlib import Path
for pidfile in (Path(sys.argv[1]) / '.local').glob('*.pid'):
    try:
        os.kill(int(pidfile.read_text()), signal.SIGTERM)
    except ProcessLookupError:
        pass
    pidfile.unlink()
PY
    "${COMPOSE[@]}" stop
    ;;
  status)
    "${COMPOSE[@]}" ps
    curl --fail --silent http://127.0.0.1:6110/api/v1/common/health/ready/
    echo
    ;;
  *) echo 'Usage: bash local-deploy.sh [start|stop|status]' >&2; exit 1 ;;
esac

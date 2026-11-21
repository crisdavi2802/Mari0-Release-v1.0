#!/usr/bin/env bash
# Comprueba integridad de archivos, instalacion y arranque del Flatpak.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APP_ID="io.github.crisdavi2802.Mari0Config"
CHECKSUMS="$REPO_ROOT/CHECKSUMS.sha256"

echo "==> Verificando checksums"
(cd "$REPO_ROOT" && sha256sum -c "$CHECKSUMS")

echo "==> Verificando instalacion"
flatpak --user list --columns=application | grep -q "$APP_ID" || {
  echo "No esta instalado; instala primero el bundle de bundles/"; exit 1; }

echo "==> Probando arranque (12 s)"
LOG="$(mktemp)"
env DISPLAY="${DISPLAY:-:0}" flatpak run "$APP_ID" >"$LOG" 2>&1 &
PID=$!
sleep 12
if command -v xwininfo >/dev/null 2>&1; then
  xwininfo -root -tree 2>/dev/null | grep -i -m1 'Mari0' || true
fi
CHILD="$(pgrep -f '^/app/lib/love-app/bin/love' | head -1 || true)"
[[ -n "$CHILD" ]] && kill "$CHILD" 2>/dev/null || true
kill "$PID" 2>/dev/null || true
if [[ -s "$LOG" ]]; then echo "Salida del programa:"; head -20 "$LOG"; fi
rm -f "$LOG"
echo "==> Verificacion terminada"

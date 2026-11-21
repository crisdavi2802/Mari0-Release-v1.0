#!/usr/bin/env bash
# Compila el Flatpak de Mari0 configurado y genera el bundle .flatpak.
# Uso:
#   ./compilar.sh              usa los tarballs incluidos en codigo/flatpak/
#   ./compilar.sh --regenerar  reconstruye los tarballs desde las fuentes + parches
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FLATPAK_DIR="$REPO_ROOT/codigo/flatpak"
AUD_DIR="$(dirname "$REPO_ROOT")/Mari0-Codigo-Auditoria"
BUILD_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mari0-flatpak-build"
APP_ID="io.github.crisdavi2802.Mari0Config"
MANIFEST="$FLATPAK_DIR/$APP_ID.yml"
OUT="$REPO_ROOT/bundles/Mari0-configurado.flatpak"

echo "==> Repositorio: $REPO_ROOT"

for cmd in flatpak flatpak-builder tar gzip; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Falta: $cmd"; exit 1; }
done

# ---- Opcional: regenerar tarballs desde fuentes auditables ----
if [[ "${1:-}" == "--regenerar" ]]; then
  echo "==> Regenerando tarballs de forma reproducible"
  STAGE="$(mktemp -d)"
  trap 'rm -rf "$STAGE"' EXIT
  mkdir -p "$STAGE/src" "$STAGE/tar"

  if [[ -d "$AUD_DIR/original" ]]; then
    cp -a "$AUD_DIR/original/." "$STAGE/src/"
  else
    echo "==> Descargando Mari0 1.6.3 (no se encontro carpeta de auditoria)"
    wget -q -O "$STAGE/mari0.tar.gz" \
      https://github.com/Stabyourself/mari0/archive/refs/tags/1.6.3.tar.gz
    tar xzf "$STAGE/mari0.tar.gz" -C "$STAGE"
    cp -a "$STAGE/mari0-1.6.3/." "$STAGE/src/"
  fi

  for p in "$REPO_ROOT"/codigo/parches/*.patch; do
    echo "    aplicando $(basename "$p")"
    (cd "$STAGE/src" && patch -p1 --quiet < "$p")
  done

  cp -a "$STAGE/src" "$STAGE/tar/mari0"

  if [[ -f "$FLATPAK_DIR/love-11.5-x86_64.AppImage" ]]; then
    APPIMAGE="$FLATPAK_DIR/love-11.5-x86_64.AppImage"
  else
    echo "==> Descargando AppImage oficial de LÖVE 11.5"
    APPIMAGE="$STAGE/love.AppImage"
    wget -q -O "$APPIMAGE" \
      https://github.com/love2d/love/releases/download/11.5/love-11.5-x86_64.AppImage
    echo "65a673406431eff7167a15a032bf7a2e4ba50108e091eb7b176465831f9b5e00  $APPIMAGE" | sha256sum -c -
  fi
  (cd "$STAGE" && chmod +x "$(basename "$APPIMAGE")" && "./$(basename "$APPIMAGE")" --appimage-extract >/dev/null)
  cp -a "$STAGE/squashfs-root" "$STAGE/tar/love-app"

  TAROPTS=(--sort=name --mtime='2020-01-01 00:00:00 UTC' --owner=0 --group=0 --numeric-owner)
  tar "${TAROPTS[@]}" -cf - -C "$STAGE/tar" mari0    | gzip -n -9 > "$FLATPAK_DIR/mari0-configured.tar.gz"
  tar "${TAROPTS[@]}" -cf - -C "$STAGE/tar" love-app | gzip -n -9 > "$FLATPAK_DIR/love-app.tar.gz"
  echo "==> Tarballs regenerados"
fi

# ---- Compilacion ----
flatpak --user remote-add --if-not-exists flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo

mkdir -p "$BUILD_DIR"
echo "==> Compilando con flatpak-builder"
# Se ejecuta desde BUILD_DIR para que la cache .flatpak-builder no ensucie el repo
(cd "$BUILD_DIR" && flatpak-builder --user --disable-rofiles-fuse \
  --repo="$BUILD_DIR/repo" --force-clean \
  "$BUILD_DIR/build" "$MANIFEST")

echo "==> Generando bundle"
mkdir -p "$(dirname "$OUT")"
flatpak build-bundle "$BUILD_DIR/repo" "$OUT" "$APP_ID"

echo "==> Listo: $OUT"
echo "    Instalar: flatpak --user install --assumeyes $(basename "$OUT")"
echo "    Ejecutar: flatpak run $APP_ID"

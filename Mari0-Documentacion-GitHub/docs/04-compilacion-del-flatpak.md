# 4. Compilación del Flatpak

## Resultado

- App ID: `io.github.crisdavi2802.Mari0Config`
- Runtime: `org.freedesktop.Platform` 25.08
- SDK: `org.freedesktop.Sdk` 25.08
- Comando: `mari0`
- Bundle incluido: `bundles/Mari0-configurado.flatpak` (~7,0 MB), recompilado con `io.github.crisdavi2802.Mari0Config` (SHA-256 `2d9740ced99cc78a31ce83f8defd08bfe348a03e895721cfe85b810fe3d63e30`).
- El commit de OSTree se genera en cada compilación (no es fijo entre ejecuciones).

## Estructura del manifiesto

`codigo/flatpak/io.github.crisdavi2802.Mari0Config.yml`

```yaml
app-id: io.github.crisdavi2802.Mari0Config
runtime: org.freedesktop.Platform
runtime-version: '25.08'
sdk: org.freedesktop.Sdk
command: mari0
finish-args:
  - --share=ipc
  - --socket=x11
  - --socket=wayland
  - --device=dri
  - --socket=pulseaudio
modules:
  - name: love      # AppImage oficial, sin compilacion
  - name: mari0     # fuente 1.6.3 + 4 parches
```

### Módulo `love`

Se descarga `love-11.5-x86_64.AppImage` (SHA-256 `65a6734...`), se extrae con `--appimage-extract` y se empaqueta su `bin/` y `lib/`. El wrapper `love-wrapper` ajusta `LD_LIBRARY_PATH`:

```sh
#!/bin/sh
export LD_LIBRARY_PATH=/app/lib/love-app/lib:$LD_LIBRARY_PATH
exec /app/lib/love-app/bin/love "$@"
```

### Módulo `mari0`

Tarball reproducible de la fuente 1.6.3 ya parcheada. `mari0-wrapper` lanza el juego:

```sh
#!/bin/sh
exec love /app/share/mari0 "$@"
```

Se instalan también el `.desktop` y `graphics/icon.png` como icono 256×256.

## Compilación

```bash
cd codigo/scripts
chmod +x compilar.sh verificar.sh
./compilar.sh
```

El script:
1. Comprueba `flatpak`, `flatpak-builder`, `tar` y `gzip`.
2. Añade Flathub si falta.
3. Ejecuta `flatpak-builder --user --disable-rofiles-fuse --force-clean`.
4. Genera el bundle con `flatpak build-bundle`.
5. Imprime los comandos de instalación y ejecución.

Para reconstruir todo desde fuentes + parches:

```bash
./compilar.sh --regenerar
```

## Reproducibilidad de los tarballs

Los SHA-256 del manifiesto son estables porque se usa:

```bash
tar --sort=name --mtime='2020-01-01 00:00:00 UTC' \
    --owner=0 --group=0 --numeric-owner -cf - -C STAGE mari0 \
  | gzip -n -9 > mari0-configured.tar.gz
```

`--mtime` fija la fecha de los archivos, `--sort=name` fija el orden, `--owner/--group` quita dueños y `gzip -n` no escribe la fecha en la cabecera. Se comprobó que dos pasadas dan el mismo hash.

## Verificación

```bash
./verificar.sh
```

Comprueba checksums, que la app esté instalada, abre la ventana 12 segundos y muestra cualquier error.

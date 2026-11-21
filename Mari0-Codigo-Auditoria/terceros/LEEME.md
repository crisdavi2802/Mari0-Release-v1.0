# Componentes de terceros

Este paquete no contiene código propio del motor de juego; solo parches sobre Mari0 y un manifiesto de empaquetado.

## Mari0

- Versión: **1.6.3**
- Origen: `https://github.com/Stabyourself/mari0` (tag `1.6.3`)
- Tarball: `mari0-1.6.3.tar.gz`
- Uso: juego, código Lua incluido en `original/` y `configurado/`

## LÖVE

- Versión: **11.5**
- Origen: `https://github.com/love2d/love/releases/download/11.5/love-11.5-x86_64.AppImage`
- SHA-256 del AppImage: `65a673406431eff7167a15a032bf7a2e4ba50108e091eb7b176465831f9b5e00`
- Licencia: zlib/libpng (consultar el archivo `license.txt` dentro del AppImage)

Se usa el AppImage oficial sin modificar. Se extrae con `--appimage-extract` y se copian `bin/` y `lib/` al Flatpak. No se recompila el motor.

## Freedesktop Platform / SDK

- Versión: **25.08**
- Origen: Flathub
- Uso: runtime del Flatpak

## Por qué no se incluye el AppImage en esta carpeta

Es un binario de 5 MB y no aporta a la auditoría del código del juego. Su hash está arriba y el script `codigo/scripts/compilar.sh` lo descarga y lo verifica automáticamente con `sha256sum -c`.

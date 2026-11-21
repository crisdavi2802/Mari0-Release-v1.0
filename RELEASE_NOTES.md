# Mari0 v1.0 — Release notes

Fecha: 20 de noviembre de 2026
Autor: `crisdavi2802`
App ID del Flatpak: `io.github.crisdavi2802.Mari0Config`

**Motivación:** todo esto se hizo para **evitar snap innecesario** en una laptop con poca RAM. Los snaps son más lentos y consumen más recursos en ese equipo, así que se prefirió Chrome desde `.deb` en vez del snap y Mari0 se empaquetó como `.deb` y Flatpak.

Este paquete contiene **todo lo necesario para publicar un release en GitHub**: documentación, código base, código modificado, parches, scripts de compilación reproducible, manifiesto Flatpak, el bundle `.flatpak` recompilado y el paquete `.deb` probado. Todo usa el App ID `io.github.crisdavi2802.Mari0Config`.

---

## 1. Qué se hizo

Se prepararon un paquete `.deb` y un bundle Flatpak de Mari0 1.6.3 con controles por flechas, pantalla completa y escalado dinámico, manteniéndolos auditables y sin snap innecesario. El detalle está en las secciones siguientes. No se incluye información del equipo original.

---

## 2. Cambios de código (Mari0)

Fuente base: **Mari0 1.6.3** del tag oficial `Stabyourself/mari0`.
Solo se modifica `main.lua`, mediante 4 parches independientes:

1. **`01-fullscreen-inicio.patch`** — `fullscreen = true` al arrancar.
2. **`02-controles-flechas.patch`** — controles por defecto con ← → ↑ ↓ en lugar de A D W S.
3. **`03-escalado-pantalla.patch`** — `changescale()` calcula la escala con `getDesktopDimensions()` para llenar el escritorio y eliminar el marco azul.
4. **`04-toggle-f11.patch`** — F11 alterna entre pantalla completa y ventana.

Verificación: los 4 parches aplicados al original producen byte a byte el `main.lua` de `Mari0-Codigo-Auditoria/configurado/`.

Nota: los parches usan finales de línea LF. En Windows, `git apply` puede convertirlos a CRLF; usa `git -c core.autocrlf=false -c core.eol=lf apply ...` para reproducir el hash exacto.

---

## 3. Contenido del paquete

```
Mari0-Release-v1.0/
├── RELEASE_NOTES.md              ← este archivo
├── LEEME.txt                     ← instrucciones rápidas
├── CHECKSUMS.sha256              ← hashes de todo el paquete
├── Mari0-Documentacion-GitHub/   ← repo 1: documentación y build
│   ├── README.md
│   ├── docs/ (7 documentos)
│   ├── codigo/
│   │   ├── flatpak/ (manifiesto, tarballs, wrappers, .desktop)
│   │   ├── parches/ (4 parches)
│   │   └── scripts/ (compilar.sh, verificar.sh)
│   └── bundles/
│       ├── Mari0-configurado.flatpak  ← bundle recompilado con el App ID actual
│       └── LEEME.md              ← datos y pasos para regenerarlo
├── Mari0-Codigo-Auditoria/       ← repo 2: código para auditar
│   ├── original/                 ← fuente 1.6.3 limpia
│   ├── configurado/              ← fuente exacta del Flatpak
│   ├── cambios/                  ← diff completo + parches
│   └── terceros/                 ← origen del AppImage de LÖVE
└── Releases/
    ├── LEEME.md
    ├── Mari0-configurado.flatpak  ← copia del bundle recompilado
    └── mari0-configurado_1.6.3-1_all.deb
```

---

## 4. Compilación e instalación

```bash
cd Mari0-Documentacion-GitHub/codigo/scripts
chmod +x compilar.sh verificar.sh
./compilar.sh              # usa los tarballs incluidos
./compilar.sh --regenerar  # reconstruye desde fuentes + parches
flatpak --user install --assumeyes ../../bundles/Mari0-configurado.flatpak
flatpak run io.github.crisdavi2802.Mari0Config
```

`verificar.sh` comprueba hashes, instalación y arranque.

El bundle incluido en `bundles/` y `Releases/` (SHA-256 `2d9740ced99cc78a31ce83f8defd08bfe348a03e895721cfe85b810fe3d63e30`) fue recompilado con `flatpak-builder 1.4.8` desde este manifiesto, se instaló con `flatpak --user install` y `flatpak info` confirma `io.github.crisdavi2802.Mari0Config`. Para regenerarlo: `./compilar.sh --regenerar`.

Los tarballs son reproducibles: `tar --sort=name --mtime fijo --owner=0` + `gzip -n`.

Para el `.deb`:

```bash
sudo apt install ./Releases/mari0-configurado_1.6.3-1_all.deb
mari0
```

---

## 5. Controles finales

| Acción | Tecla |
|---|---|
| Mover | ← → ↑ ↓ |
| Saltar | Espacio |
| Portal | E |
| Correr | Shift izq. |
| Recargar | R |
| Pantalla completa / ventana | F11 |

---

## 6. Verificación realizada

- Build con `flatpak-builder 1.4.8` y runtime Freedesktop 25.08: correcto; el bundle incluido se recompiló e instaló con el App ID nuevo.
- Arranque a pantalla completa sin errores, comprobado en el equipo original.
- `sha256sum -c` pasa en los tres archivos `CHECKSUMS.sha256` de este paquete.
- Parches reaplicados al original: coincidencia exacta.
- Los 641 archivos del juego dentro del `.deb` son byte-idénticos a `Mari0-Codigo-Auditoria/configurado/`; el paquete añade además el wrapper `/usr/bin/mari0`, el `.desktop` y el icono.
- El `.deb` fue instalado y ejecutado por el autor: funciona correctamente.

---

## 7. Notas de seguridad y privacidad

No se incluyen contraseñas, tokens, SSID reales, correos personales ni nombres de usuario del equipo en texto, scripts, manifiestos ni binarios. El único identificador es `io.github.crisdavi2802.Mari0Config`, presente también dentro del bundle recompilado. Se conservan los créditos de licencia de terceros.

---

## 8. Licencias de terceros

Mari0 1.6.3 (Stabyourself), LÖVE 11.5 (AppImage oficial, licencia zlib/libpng), LUBE (Bart Bes) y MiddleClass (Enrique García Cota) conservan sus avisos originales. Freedesktop Platform 25.08 procede de Flathub. Este repo solo aporta parches, documentación y empaquetado. Revisa las licencias de los recursos gráficos y sonoros de Mario antes de redistribuirlos públicamente.

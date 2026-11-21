# 6. Problemas encontrados y soluciones

| # | Problema | Causa | Solución |
|---|---|---|---|
| 1 | `apt-get install` fallaba con `No se pudo bloquear /var/lib/dpkg/lock-frontend` | `packagekitd` estaba usando el lock | `sudo systemctl stop packagekit` y reintentar |
| 2 | Mari0 no tenía opción de pantalla completa en el menú | El juego no implementa toggle nativo | Arranca en fullscreen y se añadió F11 |
| 3 | Pantalla completa dejaba un marco azul | `changescale` forzaba 800×600/2x | Calcular escala con `getDesktopDimensions()` |
| 4 | `flatpak-builder`: `No remote refs found for 'flathub'` | Flathub solo estaba en el ámbito sistema | `flatpak --user remote-add --if-not-exists flathub ...` |
| 5 | LÖVE: `Package requirements (luajit) were not met` | El SDK no trae LuaJIT | **Intento descartado:** se probó un módulo LuaJIT 2.1, pero se abandonó al descartar la compilación (fila 7). No está en el manifiesto final. |
| 6 | LÖVE: `needs "libmodplug"` | El SDK no trae libmodplug | **Intento descartado:** se probó un módulo libmodplug 0.8.9.0; tampoco llegó al manifiesto final (fila 7). |
| 7 | Compilación de LÖVE > 30 min, cortada por timeout | `glslang` es enorme para un equipo con poca RAM | Descartar compilación; usar AppImage oficial de LÖVE 11.5 |
| 8 | `fusermount3: failed to access mountpoint ... Permission denied` | `rofiles-fuse` no puede montar aquí | `flatpak-builder --disable-rofiles-fuse` |
| 9 | `cp: cannot stat 'love-app/.'` | `flatpak-builder` quita el único directorio raíz del tar | Copiar `bin` y `lib` directamente desde la raíz del build dir |
| 10 | `error: Unknown share type audio` | `--share=audio` no existe | Quitar la línea; `--socket=pulseaudio` ya da audio |
| 11 | Advertencia: categoría `PlatformGame` no registrada | Valor inválido en el `.desktop` | Usar `Categories=Game;` |
| 12 | `pkill -f` mataba el propio shell | El patrón coincidía con la línea de comandos del bash | Buscar PID con `pgrep -f '^/app/lib/love-app/bin/love'` y matar ese PID |

## Lección principal

En un equipo con poca RAM, compilar motores gráficos desde fuente no compensa. El AppImage oficial de LÖVE reduce el build de más de 30 minutos a unos segundos y además fija una versión concreta con hash verificable.

Notas adicionales:

- Los módulos LuaJIT y libmodplug de las filas 5 y 6 fueron **intentos descartados**: el manifiesto final solo contiene `love` (AppImage) y `mari0`.
- El bundle `.flatpak` se recompiló en Linux con `./compilar.sh` usando el App ID nuevo; el binario incluido ya coincide con la documentación.
- En Windows, aplica los parches con `git -c core.autocrlf=false -c core.eol=lf apply ...`; con CRLF el hash de `main.lua` no coincide.

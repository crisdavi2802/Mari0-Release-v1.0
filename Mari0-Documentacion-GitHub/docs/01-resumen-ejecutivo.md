# 1. Resumen ejecutivo

Objetivo: dejar una laptop con poca RAM usable e instalar herramientas y juegos — todo sin snap innecesario y con un Mari0 portable y auditable.

## Lo que se hizo

| Área | Cambio |
| --- | --- |
| Sistema | Equipo con poca RAM; se priorizaron `.deb` y Flatpak frente a snap. |
| Utilidades | `xdotool`, `scrot`, `xclip`, `tesseract-ocr`, `mtpaint`, `supertux2`, `gnome-chess` + Stockfish. |
| Mari0 | Controles a flechas, arranque en pantalla completa, escalado dinámico y F11 para alternar. |
| Empaquetado | Manifiesto Flatpak reproducible con App ID `io.github.crisdavi2802.Mari0Config` y paquete `.deb`. |

## Principios aplicados

1. **Sin snap innecesario (motivo principal):** en una laptop con poca RAM los snaps son más lentos y consumen más recursos; por eso Chrome se instaló desde `.deb` en vez del snap y Mari0 se empaqueta como `.deb` y Flatpak.
2. **Auditable:** el código original y el modificado están lado a lado, con un diff y cuatro parches independientes.
3. **Reproducible:** tarballs con fecha, orden y dueño fijos; los cuatro parches regeneran byte a byte el `main.lua` modificado.
4. **Privado:** sin credenciales, correos personales ni identificadores de usuario en el repositorio.

## Estado final verificado

- Flatpak arranca a pantalla completa, sin errores en el log (comprobado en el equipo original).
- `options.txt` dentro del Flatpak contiene `right-right`, `left-left`, `up-up`, `down-down`.
- El bundle `.flatpak` incluido fue recompilado con el App ID actual y verificado con `flatpak info`.

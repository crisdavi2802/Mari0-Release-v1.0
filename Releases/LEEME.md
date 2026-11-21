# Artefactos del release

- `mari0-configurado_1.6.3-1_all.deb`: paquete Debian generado desde `Mari0-Codigo-Auditoria/configurado/`. Instala el juego en `/usr/share/games/mari0`, necesita `love >= 11.5` y fue instalado y probado por el autor.
- `Mari0-configurado.flatpak`: bundle recompilado con `io.github.crisdavi2802.Mari0Config` (SHA-256 `2d9740ced99cc78a31ce83f8defd08bfe348a03e895721cfe85b810fe3d63e30`). No contiene el App ID anterior.

Para verificar estos artefactos en Debian/Ubuntu:

```bash
dpkg-deb -I mari0-configurado_1.6.3-1_all.deb
dpkg-deb -c mari0-configurado_1.6.3-1_all.deb | head
sha256sum Mari0-configurado.flatpak
```

# 2. Contexto del sistema

El trabajo se hizo en una laptop con poca RAM. No se incluyen marca, modelo, componentes, versiones concretas ni otros datos del equipo original.

## Por qué estas decisiones

- **Poca RAM:** cualquier compilación grande es costosa. Por eso el Flatpak de Mari0 no compila LÖVE: usa el AppImage oficial ya compilado. Compilar LÖVE 11.5 desde fuente (glslang incluido) superó los 30 minutos y fue cancelado.
- **Chrome se instaló desde `.deb`:** se prefirió el paquete `.deb` porque el snap de Chromium era más lento en ese equipo. Es la motivación anti-snap del proyecto.
- **Sin credenciales:** los comandos de red están documentados sin contraseñas ni valores reales.

## Versiones relevantes del empaquetado

- LÖVE 11.5 (AppImage `love-11.5-x86_64.AppImage`)
- Mari0 1.6.3 (tag oficial de GitHub `Stabyourself/mari0`)
- flatpak-builder 1.4.8
- Freedesktop Platform / SDK 25.08

> No se guardan contraseñas de red ni de sudo en este repositorio.

# Mari0 — código desplegado para auditoría

Esta carpeta existe para que **cualquiera pueda revisar qué lleva el Flatpak sin descompilar nada**. Mari0 está escrito en Lua, así que el código es legible directamente.

## Contenido

```
.
├── README.md              ← este archivo
├── MAPA.md                ← mapa rápido de archivos y líneas
├── CHECKSUMS.sha256       ← integridad de los archivos
├── original/              ← Mari0 1.6.3 limpio, descargado de GitHub
├── configurado/           ← código EXACTO que se empaqueta en el Flatpak
├── cambios/
│   ├── diff-completo.patch
│   ├── 01-fullscreen-inicio.patch
│   ├── 02-controles-flechas.patch
│   ├── 03-escalado-pantalla.patch
│   └── 04-toggle-f11.patch
└── terceros/
    └── LEEME.md           ← origen del motor LÖVE
```

## Comparación en un comando

```bash
diff -ru original configurado
```

Solo debe cambiar `main.lua`. La diferencia completa también está en `cambios/diff-completo.patch`.

## Los 4 cambios, resumidos

1. `fullscreen = true` al arrancar.
2. Controles por defecto con ← → ↑ ↓ en lugar de A D W S.
3. `changescale()` calcula la escala según el escritorio para llenar la pantalla.
4. F11 alterna entre pantalla completa y ventana.

No se tocó ningún otro archivo: ni gráficos, ni sonidos, ni lógica del juego.

## Relación con la otra carpeta

- `Mari0-Documentacion-GitHub/` → documentación, manifiesto, scripts y bundle incluido (recompilado con el App ID actual).
- `Mari0-Codigo-Auditoria/` (esta) → fuentes original y modificada, lado a lado.

Ambas son independientes y se pueden subir a GitHub como repos separados o como un solo repo con dos carpetas.

# Mapa rápido del código

## Puntos exactos a revisar

Archivo: `configurado/main.lua`

| Línea aprox. | Contenido | Para qué sirve |
|---|---|---|
| 47 | `fullscreen = true -- iniciar en pantalla completa` | Arranque a pantalla completa |
| 1110-1113 | `controls[i]["right"] = {"right"}` etc. | Flechas en vez de WASD |
| 1254-1268 | `function changescale(s, fullscreen)` | Escalado dinámico al tamaño del escritorio |
| 1314-1323 | `if key == "f11" then ...` | Alternar pantalla completa |

## Árbol de primer nivel

```
original/  y  configurado/
├── *.lua              ← logica del juego (legible)
├── graphics/          ← imagenes y tilesets
├── sounds/            ← musica y efectos
├── shaders/           ← shaders GLSL
├── mappacks/          ← mapas incluidos
├── netplayinc/        ← soporte de red
└── .github/           ← metadata del repo original
```

## Cómo verificar que no hay cambios ocultos

```bash
diff -qr original configurado
```

Debe listar **únicamente**:

```
Files original/main.lua and configurado/main.lua differ
```

Si aparece cualquier otro archivo, el empaquetado no coincide con esta auditoría.

## Cómo regenerar el código configurado desde los parches

```bash
cp -a original /tmp/mari0-rebuild
cd /tmp/mari0-rebuild
for p in ../Mari0-Codigo-Auditoria/cambios/0*.patch; do patch -p1 < "$p"; done
diff -ru . ../Mari0-Codigo-Auditoria/configurado
```

Último `diff` vacío = todo correcto.

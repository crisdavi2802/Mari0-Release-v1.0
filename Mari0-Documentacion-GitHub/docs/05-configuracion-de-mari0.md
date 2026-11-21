# 5. Configuración aplicada a Mari0

Fuente: Mari0 **1.6.3** (tag `1.6.3` de `Stabyourself/mari0`). Solo se modificó `main.lua`.

## Cambios

### 1. Arrancar en pantalla completa (parche 01)

```diff
- fullscreen = false
+ fullscreen = true -- iniciar en pantalla completa
```

### 2. Flechas en vez de WASD (parche 02)

```diff
- controls[i]["right"] = {"d"}
- controls[i]["left"]  = {"a"}
- controls[i]["down"]  = {"s"}
- controls[i]["up"]    = {"w"}
+ controls[i]["right"] = {"right"}
+ controls[i]["left"]  = {"left"}
+ controls[i]["down"]  = {"down"}
+ controls[i]["up"]    = {"up"}
```

Se cambiaron los **valores por defecto**, no solo el `options.txt` del usuario. Así cualquier persona que instale el Flatpak usa flechas desde el primer arranque, aunque no tenga configuración previa.

### 3. Escalado dinámico (parche 03)

El juego dibujaba a 800×448 y el resto del escritorio se veía como un marco azul. Ahora:

```lua
function changescale(s, fullscreen)
    if fullscreen then
        local dw, dh = love.window.getDesktopDimensions()
        scale = math.min(dw/(width*16), dh/224)
        love.window.setMode(dw, dh, {fullscreen=true, vsync=vsync})
    else
        scale = s
        love.window.setMode(width*16*scale, 224*scale, {fullscreen=false, vsync=vsync})
    end
    ...
end
```

### 4. F11 alterna pantalla completa (parche 04)

Se inserta en `love.keypressed`, antes del bloque de F12:

```lua
if key == "f11" then
    fullscreen = not fullscreen
    if fullscreen then
        changescale(scale, true)
    else
        changescale(2, false)
    end
    return
end
```

## Controles finales

| Acción | Tecla |
|---|---|
| Mover | ← → ↑ ↓ |
| Saltar | Espacio |
| Portal | E |
| Correr | Shift izq. |
| Recargar | R |
| Pantalla completa | F11 |

## Verificación realizada

- Ventana detectada a pantalla completa.
- Captura de pantalla con cielo del juego ocupando todo el marco.
- `~/.var/app/io.github.crisdavi2802.Mari0Config/data/love/LOVE/mari0/options.txt`:
  `right-right`, `left-left`, `up-up`, `down-down`, `jump-space`, `use-e`, `run-lshift`.
- Sin mensajes de error en el log de `flatpak run`.

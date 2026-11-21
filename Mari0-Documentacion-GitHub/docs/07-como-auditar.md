# 7. Cómo auditar

Todo está en texto plano. No hace falta descompilar nada: LÖVE usa Lua legible.

## 1. Comparar original contra configurado

La carpeta hermana `Mari0-Codigo-Auditoria/` tiene:

```
original/       ← fuente 1.6.3 tal como se descargó
configurado/    ← fuente exacta que lleva el Flatpak
cambios/        ← diff completo + 4 parches
terceros/       ← nota sobre el AppImage de LÖVE
```

Comando:

```bash
cd Mari0-Codigo-Auditoria
diff -ru original configurado
```

Solo debe aparecer `main.lua`.

## 2. Ver los parches

```bash
cd Mari0-Codigo-Auditoria/cambios
less diff-completo.patch
```

O aplicarlos uno por uno a una copia limpia:

```bash
cp -a original /tmp/mari0-audit
cd /tmp/mari0-audit
for p in /ruta/a/Mari0-Codigo-Auditoria/cambios/0*.patch; do patch -p1 < "$p"; done
diff -ru . /ruta/a/Mari0-Codigo-Auditoria/configurado
```

El último `diff` debe estar vacío.

> **En Windows:** `git apply` puede convertir los saltos de línea LF de los parches a CRLF y el hash final no coincidirá. Usa `git -c core.autocrlf=false -c core.eol=lf apply 0*.patch` (o `patch -p1`, que respeta los LF). El hash esperado de `configurado/main.lua` es `51b8295fe1e44a449c91789f9ce7b1088717b8b1d337c645ca74c3f45e2befb4`.

## 3. Comprobar integridad

```bash
Desde la raíz del paquete:

```bash
sha256sum -c CHECKSUMS.sha256
(cd Mari0-Documentacion-GitHub && sha256sum -c CHECKSUMS.sha256)
(cd Mari0-Codigo-Auditoria && sha256sum -c CHECKSUMS.sha256)
```

## 4. Verificar el bundle

> El `.flatpak` incluido ya está recompilado con el App ID actual; para regenerarlo usa `codigo/scripts/compilar.sh`.

```bash
flatpak install --bundle Mari0-configurado.flatpak
flatpak info io.github.crisdavi2802.Mari0Config
flatpak run io.github.crisdavi2802.Mari0Config
```

Dentro del Flatpak, los archivos importantes están en:

- `/app/bin/mari0` → wrapper del juego
- `/app/bin/love` → wrapper de LÖVE
- `/app/share/mari0/main.lua` → código auditado
- `/app/lib/love-app/` → AppImage extraída

Se puede abrir una shell dentro del entorno:

```bash
flatpak run --command=sh io.github.crisdavi2802.Mari0Config
```

## 5. Recompilar y comparar

```bash
cd Mari0-Documentacion-GitHub/codigo/scripts
./compilar.sh --regenerar
sha256sum ../flatpak/*.tar.gz ../../bundles/Mari0-configurado.flatpak
```

Si los hashes de los tarballs coinciden con `CHECKSUMS.sha256`, la compilación es reproducible.

## Qué revisar primero

| Archivo | Por qué |
|---|---|
| `configurado/main.lua:47` | `fullscreen = true` |
| `configurado/main.lua:1110` | controles con flechas |
| `configurado/main.lua:1254` | `changescale` dinámico |
| `configurado/main.lua:1314` | toggle F11 |
| `codigo/flatpak/*.yml` | permisos y fuentes del Flatpak |
| `codigo/flatpak/*-wrapper` | cómo se lanza el juego |

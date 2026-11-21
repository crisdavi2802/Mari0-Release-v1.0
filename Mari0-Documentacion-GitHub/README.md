# Proyecto: PC baja RAM + Mari0 portable (Flatpak)

Documentación y código fuente de todo lo que se hizo en el equipo. Pensado para subir a GitHub tal cual.

> **Por qué se hizo:** el objetivo era **evitar snap innecesario** en una laptop con poca RAM. Los snaps son más lentos y pesados en ese equipo: Chrome se instaló desde `.deb` en vez del snap y Mari0 se empaqueta como `.deb` y Flatpak por el mismo motivo.

> **Seguridad:** aquí NO hay contraseñas de WiFi, contraseñas de sudo ni datos personales. Si vuelves a ejecutar los comandos, rellena tú esos valores. Nunca subas credenciales a un repositorio público.

## Estructura

```
.
├── README.md                 ← este archivo
├── CHECKSUMS.sha256          ← integridad de todos los archivos
├── docs/
│   ├── 01-resumen-ejecutivo.md
│   ├── 02-contexto-del-sistema.md
│   ├── 03-instalacion-y-comandos.md
│   ├── 04-compilacion-del-flatpak.md
│   ├── 05-configuracion-de-mari0.md
│   ├── 06-problemas-y-soluciones.md
│   └── 07-como-auditar.md
├── codigo/
│   ├── flatpak/              ← manifiesto, tarballs, wrappers y .desktop
│   ├── parches/              ← 4 parches aplicados a Mari0
│   └── scripts/              ← compilar.sh y verificar.sh
└── bundles/
    ├── Mari0-configurado.flatpak  ← bundle recompilado con el App ID actual
    └── LEEME.md
```

La carpeta hermana **`Mari0-Codigo-Auditoria/`** contiene el código desplegado (original + configurado) para que cualquiera pueda revisarlo sin herramientas especiales.

## Inicio rápido (en Linux)

```bash
cd codigo/scripts
chmod +x compilar.sh verificar.sh
flatpak --user install --assumeyes ../bundles/Mari0-configurado.flatpak
flatpak run io.github.crisdavi2802.Mari0Config
```

Para recompilar el bundle desde las fuentes:

```bash
./compilar.sh --regenerar
./verificar.sh
```

El bundle incluido usa `io.github.crisdavi2802.Mari0Config` y fue verificado con `flatpak info`.

También hay un `.deb` listo en `../Releases/mari0-configurado_1.6.3-1_all.deb`, instalado y probado por el autor.

## Controles finales de Mari0

| Acción | Tecla |
|---|---|
| Izquierda / derecha / arriba / abajo | Flechas |
| Saltar | Espacio |
| Usar portal | E |
| Correr | Shift izquierdo |
| Recargar | R |
| Pantalla completa / ventana | F11 |

## Verificación de integridad

```bash
sha256sum -c CHECKSUMS.sha256
(cd ../Mari0-Codigo-Auditoria && sha256sum -c CHECKSUMS.sha256)
(cd .. && sha256sum -c CHECKSUMS.sha256)
```

## Licencias

Mari0 (Stabyourself), LÖVE, LUBE (Bart Bes) y MiddleClass (Enrique García Cota) son proyectos de terceros y conservan sus avisos originales. Este repo solo contiene un manifiesto de empaquetado, parches propios y documentación. Consulta las licencias originales en `Mari0-Codigo-Auditoria/original/` y en el sitio oficial de LÖVE. Revisa las licencias de los recursos gráficos y sonoros antes de redistribuirlos.

## Seguridad

- Sin contraseñas, SSID reales ni correos personales.
- El App ID es `io.github.crisdavi2802.Mari0Config`, también dentro del bundle recompilado.
- Los tarballs incluidos son reproducibles (`tar --sort=name --mtime fijo --owner=0` + `gzip -n`).
- Se conservan los avisos de licencia de terceros.
- En Windows, aplica los parches con `git -c core.autocrlf=false -c core.eol=lf apply ...` para no romper los hashes (ver `docs/07-como-auditar.md`).

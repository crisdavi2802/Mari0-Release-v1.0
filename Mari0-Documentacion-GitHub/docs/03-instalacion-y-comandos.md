# 3. Instalación y comandos utilizados

## El Flatpak de Mari0

Ver `04-compilacion-del-flatpak.md`. El bundle `Mari0-configurado.flatpak` incluido fue recompilado con `io.github.crisdavi2802.Mari0Config` y verificado con `flatpak info`.

Desde la raíz de este repositorio:

```bash
cd codigo/scripts
chmod +x compilar.sh verificar.sh
./compilar.sh --regenerar
flatpak --user install --assumeyes ../bundles/Mari0-configurado.flatpak
flatpak run io.github.crisdavi2802.Mari0Config
```

`./compilar.sh` sin argumentos usa los tarballs incluidos; `--regenerar` los reconstruye desde `Mari0-Codigo-Auditoria/configurado/` y los 4 parches.

## Paquete `.deb`

```bash
sudo apt install ../Releases/mari0-configurado_1.6.3-1_all.deb
mari0
```

Requiere `love >= 11.5`. Los 641 archivos del juego son byte-idénticos a `Mari0-Codigo-Auditoria/configurado/`; el paquete añade el wrapper `/usr/bin/mari0`, el `.desktop` y el icono. Verificado por el autor: instalado y funcionando.

## Resto del equipo (resumen de comandos)

```bash
# Repositorio Flathub en modo usuario
flatpak --user remote-add --if-not-exists flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo

# Utilidades y juegos
sudo apt install xdotool scrot xclip tesseract-ocr mtpaint supertux2 gnome-chess stockfish

# LibreOffice en español
sudo apt install libreoffice-l10n-es libreoffice-help-es
```

> No se guardan contraseñas de red ni de sudo. Los detalles de configuración del equipo original no se incluyen en este repositorio.

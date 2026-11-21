# Bundles

`Mari0-configurado.flatpak` (7,0 MB) fue **recompilado** con `flatpak-builder 1.4.8` y el runtime Freedesktop 25.08 usando este mismo manifiesto.

- App ID: `io.github.crisdavi2802.Mari0Config`
- SHA-256: `2d9740ced99cc78a31ce83f8defd08bfe348a03e895721cfe85b810fe3d63e30`
- Commit: `8f96ef168ee958ab1626ceba454485ca526a57475a248424bae2c06669118596`
- Verificación: instalado con `flatpak --user install` y `flatpak info` muestra el App ID nuevo. El binario no contiene el identificador anterior.

Para regenerarlo en Linux:

```bash
cd codigo/scripts
chmod +x compilar.sh verificar.sh
./compilar.sh --regenerar   # opcional: reconstruye los tarballs desde las fuentes
./verificar.sh
flatpak --user install --assumeyes ../bundles/Mari0-configurado.flatpak
flatpak run io.github.crisdavi2802.Mari0Config
```

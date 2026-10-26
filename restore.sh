#!/usr/bin/env bash
set -euo pipefail

# Carpeta de usuario de Bambu Studio (preset_folder). Cambiar si Bambu usa otra ID.
PRESET_FOLDER="TU_ID"

LIVE="$HOME/.var/app/com.bambulab.BambuStudio/config/BambuStudio"
HERE="$(cd "$(dirname "$0")" && pwd)"

if pgrep -x bambu-studio >/dev/null; then
  echo "ERROR: cierra Bambu Studio antes de restaurar." >&2
  exit 1
fi

cp "$HERE/presets/filament/"*.json "$LIVE/user/$PRESET_FOLDER/filament/"
cp "$HERE/presets/process/"*.json  "$LIVE/user/$PRESET_FOLDER/process/"
cp "$HERE/BambuStudio.conf" "$LIVE/BambuStudio.conf"

echo "Configuración restaurada desde $HERE. Abre Bambu Studio."

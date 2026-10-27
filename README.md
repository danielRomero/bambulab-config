# Configuración de Bambu Studio (Bambu Lab A1)

Copia versionada (git) de toda la configuración del slicer.

## Estructura

```
bambu-config/
├── presets/
│   ├── filament/        # 3 presets de filamento (material)
│   └── process/         # 4 presets de proceso (cómo se imprime)
├── BambuStudio.conf     # config global + datos de calibración (flow ratio, …)
├── restore.sh           # restaura el repo a Bambu Studio
└── README.md
```

## Presets incluidos

- Filamento: `A1 · eSUN PLA+`, `A1 · Geeetech TPU Negro`, `A1 · SUNLU PLA Calibrado`
- Proceso: `A1 · PLA · Funcional`, `A1 · PLA · Decorativo`, `A1 · PLA · Miniatura 0.4`, `A1 · TPU · Lento`

## Regla de oro

**Bambu Studio debe estar CERRADO** antes de restaurar o copiar ficheros a su carpeta.
Si está abierto, al cerrar sobreescribe con lo que tiene en memoria.

## Reimportar presets (método normal)

1. `File → Import → Import Preset`.
2. Importa los 3 JSON de `presets/filament/`.
3. Importa los 4 JSON de `presets/process/`.
4. Responde **Yes to all**.

## Guardar cambios (cuando tocas algo en Bambu Studio)

Con Bambu Studio cerrado, trae los ficheros al repo y haz commit:

```bash
LIVE="$HOME/.var/app/com.bambulab.BambuStudio/config/BambuStudio/user/TU_ID"
cp "$LIVE/filament/"*.json presets/filament/
cp "$LIVE/process/"*.json  presets/process/
cp "$HOME/.var/app/com.bambulab.BambuStudio/config/BambuStudio/BambuStudio.conf" .
git add -A && git commit -m "descripción del cambio"
```

## Restaurar / volver al pasado

```bash
git log --oneline          # ver historial
git checkout <commit> -- . # traer un estado anterior
./restore.sh               # aplicarlo a Bambu Studio (cerrado)
```

## Notas

- El **K de pressure advance (Flow Dynamics)** vive en la **impresora**, no en ficheros.
- El **flow ratio (Flow Rate)** está en `BambuStudio.conf` (sección `calis`) y, tras calibrar,
  también como `filament_flow_ratio` en el filamento eSUN.
- No hay preset de máquina/impresora de usuario: la A1 usa el preset de sistema.
- Los `.info` se regeneran al reimportar, por eso se ignoran en git.

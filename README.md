# Configuración de Bambu Studio (Bambu Lab A1)

Presets del slicer versionados en git, listos para importar en Bambu Studio.

## Estructura

```
bambu-config/
├── presets/
│   ├── filament/        # 3 presets de filamento (material)
│   └── process/         # 4 presets de proceso (cómo se imprime)
├── AGENTS.md            # contexto y decisiones (auto-cargado por OpenCode)
└── README.md
```

> La configuración global (`BambuStudio.conf`) **no se versiona**: contiene el
> código de acceso LAN y el número de serie de la impresora. Vive solo en
> `~/.var/app/com.bambulab.BambuStudio/config/BambuStudio/`.

## Presets incluidos

- Filamento: `A1 · eSUN PLA+`, `A1 · Geeetech TPU`, `A1 · SUNLU PLA`
- Proceso: `A1 · PLA · Funcional`, `A1 · PLA · Decorativo`, `A1 · PLA · Miniatura 0.4`, `A1 · TPU · Lento`

## Regla de oro

**Bambu Studio debe estar CERRADO** antes de copiar ficheros a su carpeta.
Si está abierto, al cerrar sobreescribe con lo que tiene en memoria.

## Reimportar presets (método normal)

1. `File → Import → Import Preset`.
2. Importa los 3 JSON de `presets/filament/`.
3. Importa los 4 JSON de `presets/process/`.
4. Responde **Yes to all**.

Importar por la interfaz **sí** sincroniza con Bambu Cloud. Copiar ficheros a
mano **no** lo hace (al reiniciar el slicer vuelven las versiones de la nube).

## Guardar cambios (cuando tocas algo en Bambu Studio)

Con Bambu Studio cerrado, trae los JSON al repo:

```bash
LIVE="$HOME/.var/app/com.bambulab.BambuStudio/config/BambuStudio"
ID="$(ls "$LIVE/user" | head -1)"   # ID de tu cuenta de Bambu
cp "$LIVE/user/$ID/filament/"*.json presets/filament/
cp "$LIVE/user/$ID/process/"*.json  presets/process/
git add -A && git commit -m "descripción del cambio"
```

## Volver a un estado anterior

```bash
git log --oneline                 # ver historial
git checkout <commit> -- presets/ # traer los presets de ese commit
```

Después impórtalos de nuevo con `File → Import → Import Preset` (Yes to all).

## Notas

- El **K de pressure advance (Flow Dynamics)** vive en la **impresora**, no en ficheros.
- El **flow ratio (Flow Rate)** está como `filament_flow_ratio` en el JSON del filamento.
- No hay preset de máquina/impresora de usuario: la A1 usa el preset de sistema.
- Los `.info` se regeneran al reimportar, por eso se ignoran en git.

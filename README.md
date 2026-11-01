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

## `BambuStudio.conf`: por qué no está aquí

Es la **configuración global del slicer**, no un preset: preferencias de la interfaz, última
máquina/proceso/filamento seleccionados, mapeo del AMS y el historial de calibración (`calis`).
**No se versiona** porque contiene datos sensibles de la impresora:

- `access_code`: el **código de acceso LAN**, indexado por el número de serie.
- El **número de serie** de la impresora y el `slicer_uuid`.

Con eso, cualquiera que alcance la impresora (tu red, o fuera si algún día abres puerto/VPN)
podría conectarse por MQTT/FTP y controlarla.

Si clonas el repo y no tienes ese fichero, **no falta nada importante**: Bambu Studio lo crea
solo con valores por defecto al abrirlo. Los ajustes de impresión viven en `presets/` y el
flow real en `filament_flow_ratio` de cada filamento; solo se pierden preferencias de interfaz
y el historial de `calis`.

### Regenerarlo y recuperar el acceso a la impresora

1. Abre Bambu Studio: se crea `BambuStudio.conf` con valores por defecto en
   `~/.var/app/com.bambulab.BambuStudio/config/BambuStudio/`.
2. Entra con tu cuenta de Bambu Lab (pestaña *Device*): la impresora aparece con su número de
   serie.
3. Si usas **LAN Only Mode**, introduce el código de acceso cuando lo pida:
   - En la pantalla de la A1: **Settings → (3.ª página) → LAN Only Mode → Access Code**.
   - ⚠️ Apagar y encender LAN Only Mode **regenera** el código; si lo haces, vuelve a introducirlo.
   - En redes con subredes distintas: *Device → Bind with Access Code* (IP + código).
4. Al conectar, Bambu Studio guarda el serial y el código en el `BambuStudio.conf` nuevo.
5. Importa los presets (`File → Import → Import Preset`, **Yes to all**) y listo.

## Notas

- El **K de pressure advance (Flow Dynamics)** vive en la **impresora**, no en ficheros.
- El **flow ratio (Flow Rate)** está como `filament_flow_ratio` en el JSON del filamento.
- No hay preset de máquina/impresora de usuario: la A1 usa el preset de sistema.
- Los `.info` se regeneran al reimportar, por eso se ignoran en git.

# Configuración de Bambu Studio — Bambu Lab A1

Presets de filamento y de proceso para **Bambu Studio**, versionados en git y listos
para importar. Probados en una Bambu Lab A1 con **boquilla de 0.4 mm** y **placa PEI
texturizada**.

## Estructura

```
bambu-config/
├── presets/
│   ├── filament/    # 3 presets de filamento (material)
│   └── process/     # 4 presets de proceso (cómo se imprime)
├── AGENTS.md        # contexto técnico y decisiones (lo carga OpenCode)
└── README.md
```

> La configuración global del slicer (`BambuStudio.conf`) **no se versiona**.
> El motivo y cómo regenerarla están en [su sección](#bambustudioconf-por-qué-no-está-aquí).

## Presets

### Filamentos

| Preset | Hereda de | Para qué |
|---|---|---|
| `A1 · eSUN PLA+` | `eSUN PLA+ @BBL A1` | PLA+ principal · flow y K calibrados |
| `A1 · SUNLU PLA` | `Generic PLA @BBL A1` | PLA genérico · flow y K calibrados |
| `A1 · Geeetech TPU` | `Generic TPU @BBL A1` | TPU 95A · temperatura validada en torre |

### Procesos

| Preset | Hereda de | Para qué |
|---|---|---|
| `A1 · PLA · Funcional` | `0.20mm Strength @BBL A1` | piezas resistentes: 6 paredes, 25 % grid |
| `A1 · PLA · Decorativo` | `0.12mm Fine @BBL A1` | acabado: ironing, fuzzy skin, arachne |
| `A1 · PLA · Miniatura 0.4` | `0.08mm Extra Fine @BBL A1` | miniaturas con 0.4: lento, soportes fáciles de quitar |
| `A1 · TPU · Lento` | `0.20mm Standard @BBL A1` | TPU a velocidades bajas, con brim |

Los procesos son **independientes del material**: se combinan con cualquiera de los
filamentos de la tabla anterior.

## Cómo usarlo

### Importar los presets

1. Abre Bambu Studio.
2. `File → Import → Import Preset`.
3. Importa los 3 JSON de `presets/filament/`.
4. Importa los 4 JSON de `presets/process/`.
5. Responde **Yes to all**.

Importar por la interfaz **sí** sincroniza con Bambu Cloud; copiar los ficheros a
mano **no** lo hace (al reiniciar el slicer vuelven las versiones de la nube).

### Guardar cambios hechos en Bambu Studio

**Bambu Studio debe estar cerrado**: si está abierto, al cerrar sobreescribe con lo
que tenga en memoria.

```bash
LIVE="$HOME/.var/app/com.bambulab.BambuStudio/config/BambuStudio"
ID="$(ls "$LIVE/user" | head -1)"   # ID de tu cuenta de Bambu
cp "$LIVE/user/$ID/filament/"*.json presets/filament/
cp "$LIVE/user/$ID/process/"*.json  presets/process/
git add -A && git commit -m "descripción del cambio"
```

### Volver a un estado anterior

```bash
git log --oneline                 # ver historial
git checkout <commit> -- presets/ # traer los presets de ese commit
```

Después impórtalos otra vez con `File → Import → Import Preset` (Yes to all).

## `BambuStudio.conf`: por qué no está aquí

Es la **configuración global del slicer**, no un preset: preferencias de la interfaz,
última máquina/proceso/filamento seleccionados, mapeo del AMS y el historial de
calibración (`calis`). **No se versiona** porque contiene datos sensibles de la
impresora:

- `access_code`: el **código de acceso LAN**, indexado por el número de serie.
- El **número de serie** de la impresora y el `slicer_uuid`.

Con eso, cualquiera que alcance la impresora (tu red, o fuera si algún día abres
puerto/VPN) podría conectarse por MQTT/FTP y controlarla.

Si clonas el repo y no tienes ese fichero, **no falta nada importante**: Bambu Studio
lo crea solo con valores por defecto al abrirlo. Los ajustes de impresión viven en
`presets/` y el flow real en `filament_flow_ratio` de cada filamento; solo se pierden
preferencias de interfaz y el historial de `calis`.

### Regenerarlo y recuperar el acceso a la impresora

1. Abre Bambu Studio: se crea `BambuStudio.conf` con valores por defecto en
   `~/.var/app/com.bambulab.BambuStudio/config/BambuStudio/`.
2. Entra con tu cuenta de Bambu Lab (pestaña *Device*): la impresora aparece con su
   número de serie.
3. Si usas **LAN Only Mode**, introduce el código de acceso cuando lo pida:
   - En la pantalla de la A1: **Settings → (3.ª página) → LAN Only Mode → Access Code**.
   - ⚠️ Apagar y encender LAN Only Mode **regenera** el código; si lo haces, vuelve a
     introducirlo.
   - En redes con subredes distintas: *Device → Bind with Access Code* (IP + código).
4. Al conectar, Bambu Studio guarda el serial y el código en el `BambuStudio.conf` nuevo.
5. Importa los presets ([arriba](#importar-los-presets)) y listo.

## Notas

- El **K de pressure advance (Flow Dynamics)** vive en la **impresora**, no en ficheros.
- El **flow ratio (Flow Rate)** está como `filament_flow_ratio` en el JSON del filamento.
- No hay preset de máquina/impresora de usuario: la A1 usa el preset de sistema.
- Los `.info` de Bambu Studio se regeneran al reimportar, por eso se ignoran en git.

# Contexto técnico — Bambu Studio (Bambu Lab A1)

> Notas para sesiones de IA: estado de la máquina, decisiones tomadas y detalles que no
> se deducen del repo. El `README.md` explica **cómo se usa** (importar, guardar cambios);
> aquí está el **porqué**.

## Máquina y entorno

- Impresora: **Bambu Lab A1**, boquilla 0.4, placa **PEI texturizada**.
- Fedora 44, KDE Wayland. CPU Broadwell 2c/4t, 7.6 GB RAM.
- Bambu Studio: Flatpak oficial `com.bambulab.BambuStudio` **2.8.2.61**, con override
  `--socket=wayland`.
- Datos del slicer (Flatpak): `~/.var/app/com.bambulab.BambuStudio/`.
- El slicer sube la CPU a 93–100 °C → **cerrarlo** cuando no se esté usando.

## Repo y flujo de trabajo

- Ubicación: `~/code/bambu-config/` · remoto público: `github.com/danielRomero/bambulab-config`.
- Contenido versionado: `presets/filament/` (3 JSON), `presets/process/` (4 JSON),
  `AGENTS.md`, `README.md`.
- **No versionado a propósito**:
  - `BambuStudio.conf`: contiene el `access_code` LAN y el número de serie. Se conserva
    una copia local (ignorada) como **documentación del estado de la máquina** (AMS,
    `calis`, última config); se refresca con `cp` y nunca se commitea tal cual.
    Si falta tras un clone, Bambu Studio la regenera sola.
  - `archive/`: backup de los presets anteriores al renombrado. Ignorado y **no borrar**:
    no existe otra copia.
  - `*.info`: metadata del slicer, se regenera al reimportar.
- **Regla crítica de sincronización**: editar los ficheros **no** sincroniza con Bambu
  Cloud (al reiniciar vuelven las versiones de la nube). Solo sincroniza **importar por
  la interfaz** (`File → Import → Import Preset`, `Yes to all`), y lo viejo se borra en
  `File → Batch Preset Management`. **Nunca** escribir presets con Bambu Studio abierto:
  al cerrar sobreescribe con lo que tiene en memoria.
- Reparto de tareas: **la IA mantiene el repo**, **el usuario importa por la UI**.
- Antes de publicar el repo se reescribió el historial para purgar el `.conf`
  (código LAN, serial, rutas personales e ID de cuenta).

## Convención de nombres

- **Filamento:** `A1 · <Marca> <Tipo>` (sin color ni "calibrado").
- **Proceso:** `A1 · <tipo de material> · <uso>`.

## Presets actuales

### Filamentos (material)

- `A1 · eSUN PLA+` → hereda `eSUN PLA+ @BBL A1` (`GFSL03_05`). 215 °C, cama 65 (textured),
  **flow 1.029 (calibrado)**, máx. vol 15 mm³/s, ventilador 100 % tras 2 capas, scarf seam
  `external`. K (Flow Dynamics) = **0.025 en la impresora**.
- `A1 · Geeetech TPU` → hereda `Generic TPU @BBL A1`. 215 °C (validado en torre de
  temperatura), retracción 0.4 mm.
- `A1 · SUNLU PLA` → hereda `Generic PLA @BBL A1`. 210/205 °C, scarf seam.
  **flow 0.98 (calibrado)**, K = **0.02**.

### Procesos (independientes del material)

- `A1 · PLA · Funcional` → `0.20mm Strength @BBL A1` (`GP080`): 6 paredes, 25 % grid, orden
  `outer wall/inner wall`, `alternate_extra_wall`, top monotonic, `top_one_wall_type = not apply`.
- `A1 · PLA · Decorativo` → `0.12mm Fine @BBL A1` (`GP077`): 2 paredes, 15 % gyroid, ironing
  (12 %/0.1 mm), fuzzy skin `external`, scarf, `wall_generator = arachne`, `detect_thin_wall`,
  evitar cruces, top monotonic.
- `A1 · PLA · Miniatura 0.4` → `0.08mm Extra Fine @BBL A1` (`GP076`): lento (pared ext.
  40 mm/s), soportes árbol, interfaz `auto` (2 capas / 0.5 mm), `support_*_z_distance = 0.12`
  (fáciles de quitar), `arachne`, `detect_thin_wall`.
- `A1 · TPU · Lento` → `0.20mm Standard @BBL A1` (`GP079`): velocidades bajas (pared
  30 mm/s), gyroid 20 %, brim, evitar cruces, top monotonic.

## Calibración

- eSUN: **K = 0.025** (impresora, por filamento) y **flow = 1.029** (filamento). Completado.
- SUNLU: **K = 0.02** (impresora, por filamento) y **flow = 0.98** (calibrado; resultado
  0 → sin cambio). Completado.
- TPU: temperatura validada (215 °C); flow sin calibrar.

## Claves técnicas aprendidas

- `only_one_wall_top` es una clave **LEGACY** que Bambu 2.8 ignora; la real es
  **`top_one_wall_type`** con valores `not apply` / `all top` / `topmost`. Usamos
  `not apply` (= paredes completas en la cara superior).
- `pressure_advance` / `enable_pressure_advance` están marcados **"Useless for Bambu
  Printer"** (el slicer no los usa). El K (Flow Dynamics) es **por filamento** y se guarda
  como **PA profile en la memoria de la impresora** (`Calibration → Flow Dynamics →
  Manage Result`, o Device tab → AMS → PA Profile), **NO** en ficheros del slicer.
- El PA profile se asocia al filamento por **marca + material (vendor/material)**, no por
  el `name` del preset. Renombrar el `name` (sin cambiar `inherits`) **no rompe** el enlace.
- El K se pierde solo con: **factory reset** de la impresora, borrado manual en
  **Manage Result**, o el límite de **16 resultados por boquilla**. Bugs de visualización:
  si no aparece, abrir `Manage Result` fuerza la recarga.
- El K se puede **re-crear a mano** en `Calibration → Flow Dynamics → Manage Result`
  tecleando el valor, sin recalibrar. API programable: no hay oficial; se usa MQTT (TLS
  8883, `device/{serial}/request|report`), p. ej. `bambulan` ("set K-values"), `pybambu`,
  `bambu-rs`. ⚠️ Firmware A1 ≥ 01.05.00.00 bloquea escritura de terceros en cloud: hace
  falta LAN + Developer Mode (pierde nube).
- El flow rate (`filament_flow_ratio`) vive en el JSON del filamento (y en la sección
  `calis` del `BambuStudio.conf` local, que no se versiona).
- Fórmula Flow Rate: `nuevo = viejo × (100 + modifier) / 100`. Ej.: 0.98 × 1.05 = **1.029**.
- Base IDs: eSUN PLA+ `GFSL03_05`; 0.20 Strength `GP080`; 0.12 Fine `GP077`; 0.08 Extra
  Fine `GP076`; 0.20 Standard `GP079`.
- `preset_folder` = ID de la carpeta de usuario de Bambu, en
  `~/.var/app/com.bambulab.BambuStudio/config/BambuStudio/user/` (identificador de cuenta;
  no se publica).
- Temperatura de cama: va por placa en claves `textured_plate_temp`, `hot_plate_temp`, etc.
  (del filamento). eSUN ya trae 65 en textured.
- Retracción es de **máquina** (A1 = 0.8 mm, 30 mm/s); override por filamento con
  `filament_retraction_length`.

## Mantenimiento (lubricación)

- Raíles X e Y + poleas tensoras: **ACEITE** (mensual). **Nunca grasa en el raíl X.**
- Husillos Z (la A1 tiene doble husillo): **GRASA** (trimestral).
- Equivalentes aceptados: grasa **Super Lube 92003** / **Lucas Oil 10533**; aceite
  **WD-40 Multi-Use Product** (solo ese modelo de WD-40).

## Pendiente / opcional

- **Boquilla 0.2** + preset `0.06mm Fine @BBL A1 0.2 nozzle` para miniaturas (el salto real
  de calidad).
- Calibrar el flow del TPU si se usa de verdad.
- Torre de temperatura eSUN/SUNLU (los 215 °C del eSUN no están validados por torre; el TPU sí).

# OutRunners (Sega System Multi 32) en NAOMI: estudio y plan del port

Estado (2026-11-13, mañana): **fase 1 compilada, sin probar en placa.** Hay imagen de netboot (`orunners_naomi.bin.gz`,
8,1 MB) generada con el ROM del propietario; el código está en [`outrunners/naomi-port.patch`](../outrunners/naomi-port.patch)
hasta que exista el fork (sección 3). Antes de eso: **estudio hecho.** El juego de PC corre aquí con el ROM del propietario y se ha
medido qué cuesta cada parte y qué usa del chip de vídeo. Conclusión: **factible**, con el vídeo reescrito para la
PowerVR2. La lógica del juego y el programa de sonido caben de sobra en el SH-4.

Base: [cheviman/outrunners-port](https://github.com/cheviman/outrunners-port) (BSD-3-Clause, Sebastian Toyos), port
nativo en C hecho sobre su descompilación [outrunners-decomp](https://github.com/cheviman/outrunners-decomp).
Medido sobre el commit `12af5afe` (submódulo `tools/core` = cheviman/arcade-decomp `2c543676`).

## 1. Qué es el port de PC

- **Juego:** el programa del V60 descompilado a C (`src/`), con un runtime que modela la placa: frame, interrupciones,
  E/S, EEPROM (`runtime/src/`).
- **Sonido:** el programa del Z80 descompilado a C (`src/sound/`) sobre los chips emulados: YM3438 (sigue a ymfm, de
  Aaron Giles) y MultiPCM (sigue a MAME). Se ejecuta en el tiempo de la placa (`sound_cpu.c`).
- **Vídeo:** `runtime/src/video.c` reimplementa el chip de vídeo del System 32 a la manera de MAME. Dibuja cada capa
  en su propio búfer de 16 bits y luego las mezcla píxel a píxel.
- **Datos:** salen del ROM set `orunners` de MAME en la primera ejecución (`extract_assets.py`, o
  `--write-pack` para un único fichero de ~31 MB). El repositorio no lleva nada del juego.
- **Entrada:** volante, gas, freno y cambio de dos marchas (`shift_up1` / `shift_down1`).

## 2. Mediciones (2026-11-13, en el workspace de Claude)

Receta: compilar `orunners_game_headless` (Release), aplicar [`outrunners/census.patch`](../outrunners/census.patch)
y lanzar el guion [`outrunners/race_arcade.txt`](../outrunners/race_arcade.txt): moneda, START hasta la carrera, gas
a fondo y algún volantazo. Con eso se llega a la carrera hacia el fotograma 1700. Se ejecuta con `--screens 1`, una
sola pantalla como en el mueble.

### 2.1 Coste por fotograma en carrera (callgrind, instrucciones x86-64)

Diferencia entre dos ejecuciones (hasta el fotograma 2900 y hasta el 3500): 600 fotogramas de carrera. Se han
descontado los hashes de comprobación del ejecutable headless (s32_state_hash y frame_hash, ~4,8 M/fotograma).

| Parte | Instrucciones / fotograma | Notas |
|---|---:|---|
| Mezcla de capas (`mix_rows`) | 8,7 M | por píxel: prioridades, blending, offsets de color |
| Tilemaps con zoom (NBG0) | 3,5 M | |
| Tilemaps con scroll (NBG2) | 3,5 M | scroll y selección de línea por fila |
| Sprites | 2,2 M | |
| Capa de texto | 2,1 M | |
| Bitmap + borrados | 1,2 M | |
| **Vídeo total** | **~21 M** | |
| MultiPCM (+ lectura de samples) | 2,6 M | `assets_pcm_byte` es un acceso por byte poco eficiente |
| YM3438 (`s32_fm_generate`) | 1,0 M | **OutRunners no toca ninguna nota del FM:** solo usa sus timers |
| Programa del Z80 | ~0,2 M | |
| **Lógica del juego (V60 en C)** | **< 0,5 M** | |

El SH-4 de la NAOMI tiene unos **3,3 M ciclos por fotograma a 60 Hz**. El vídeo tal cual necesitaría del orden de
10 veces eso, unos 5 fps estimados. Esta estimación no está medida en placa: el SH-4 necesita algo más de
instrucciones que x86 para lo mismo y no da una por ciclo. La lógica y el programa del Z80 caben (~10–20 % del
fotograma). El sonido, tal cual, se comería otro fotograma entero, pero el FM sobra y el MultiPCM se puede pasar al
AICA.

### 2.2 Qué usa OutRunners del chip de vídeo (9.000 fotogramas: attract, selección, carrera)

| Función del chip | Uso en OutRunners | Consecuencia para la PVR2 |
|---|---|---|
| Capas | **TEXT, NBG0, NBG2 y BITMAP**; NBG1 y NBG3 nunca | 3 capas de tiles y BITMAP (que no llega a pantalla) |
| NBG0 zoom | 1:1 en el 99,6 % de los fotogramas; zoom solo en ~30 fotogramas de transición; sin rotación | un quad escalado |
| NBG2 | **scroll por línea + selección de fila** siempre activos (`line04` = e?05 / e?0f) | una tira por scanline (224) |
| Ventanas de recorte de capas | no (`off02` = 8000) | nada |
| Sombras de sprite / colores extra / sprites desde RAM | nunca | nada |
| Blending | activo, factor 2; solo TEXT sobre sprites, y TEXT casi no tiene píxeles visibles | dejar para el final |
| Offsets de color (fundidos) | en ~11 % de los fotogramas, iguales en R, G y B (fundido a negro) | quad negro translúcido o color de offset del PVR |
| Sprites | media **56**, máximo **115** por fotograma; ~55 % escalados; algunos de 8 bpp y con tabla indirecta | quads con textura de una caché |
| Recortes de lista de sprites | 4 de media, 12 como máximo | recortar quads en CPU |
| Área de sprites | ~150.000 píxeles por fotograma (dos pantallas) | sin problema para el PVR |

**Paleta:** el System 32 tiene 16.384 colores; la PowerVR2, 1.024 entradas (64 bancos de 16). Los bancos de 16
colores que llegan a la pantalla son 60 de media y **82 como máximo** por fotograma, 309 distintos en toda la
partida. No caben siempre en la paleta del PVR: se usarán texturas de color directo ARGB1555, con el pen 0 como
transparente, y se invalidan cuando cambia su banco de paleta.

**Caché de sprites:** 1.264 imágenes distintas en toda la partida (8,6 MB a 16 bits). En carrera se convierten
**~500 texels nuevos por fotograma** de media y 12.600 en el percentil 99; los picos (100.000) son cambios de escena.
La conversión en CPU es barata y la caché cabe en la VRAM (16 MB en la NAOMI).

Reproducir: `python3 outrunners/analyze_census.py census.txt 1700`.

## 3. Plan del port

Repositorio previsto: un fork de cheviman/outrunners-port en la cuenta 0skarzer0 con rama `naomi`, igual que
dreamcast-cannonball (pendiente de crear; mientras, `git am outrunners/naomi-port.patch` sobre el commit `12af5afe`). Las piezas de NAOMI se reutilizan de Daytona nativo (rama `naomi-native`): `naomi_input.c`
(JVS/MIE), `naomi_dimmfs.c` (ficheros en el DIMM), `naomi_dimmcomms.c` + `live.py` (*peeks* desde la Pi para medir
en placa), `naomi_log.c`, `naomi_save.c` (EEPROM) y `naomi_pack.py` (imagen `.bin.gz`).

### Fase 1 — arranque y medida en placa (compilada el 2026-11-13, sin probar en placa)
- `ports/naomi/`: bucle principal con KOS (`KOS_SUBARCH=naomi`), lógica del juego y Z80 con los timers del YM3438
  (sin síntesis FM). Vídeo provisional: el `video.c` actual a 1 de cada N fotogramas, solo para ver algo.
- Entradas JVS → `s32_inputs`: volante (analógico 0), gas (1), freno (2) con la calibración de
  [hardware.md](hardware.md). La palanca de 2 posiciones hace de LOW/HIGH: adelante `shift_up1`, atrás
  `shift_down1`. Monedero por diferencia de contadores; START con luz.
- Medir por la NetDIMM (`live.py`): ms por fotograma de la lógica y del Z80. **Objetivo: < 3 ms.**

Hecho (en `ports/naomi/` del parche):
- `main.c`: bucle con KOS, JVS (volante, pedales, palanca → SHIFT UP/DOWN, START, monedas por diferencia de
  contadores, SERVICE/TEST), `video.c` cada `draw_every` fotogramas (4 por defecto, se cambia en vivo) copiado a un
  framebuffer de 640×480 RGB565, y tiempos de juego, sonido y vídeo por segundo en el bloque `orunners_naomi_live`.
- `runtime/src/tasks.c`: cambio de tareas para el SH-4 (registros en la pila de la tarea, como en aarch64). En Linux
  las dos tareas del juego usan ~3,5 KB de pila; en la NAOMI llevan 128 KB.
- `ORUNNERS_PACKED_PENS` + `naomi_assets.py`: tiles a 4 bpp y samples aparte → el pack en RAM baja de 31 a 21,6 MB.
  Comprobado en PC: mismos hashes de vídeo que la versión normal en 3.501 fotogramas.
- Sin samples en RAM en esta fase: el MultiPCM suena en silencio (se miden igualmente el Z80 y los chips).
- `naomi_dimmfs`, `naomi_dimmcomms` (peeks), anillo de consola y `naomi_pack.py`, de Daytona nativo.
- Compila y enlaza con sh-elf-gcc 15.2.0 y KOS `368a2eb9` (NAOMI): 646 KB de código y 4,9 MB de datos estáticos.

**Para probar en el mueble:** subir `orunners_naomi.bin.gz` a la Pi del mueble Crazy Taxi (`/boot/roms/`, por
ejemplo como `h-outrunners_naomi.bin.gz`, con su fila en `romsinfo.csv`) y, con el juego en marcha, desde la Pi:
`python3 live.py 10.0.0.4 0x8c0bef84 fps 60` (la dirección es la de esta compilación). Qué mirar: si arranca y se ve
el attract (a ~15 fps de pantalla, a saltos), si `game` llega a 60 fps, los µs de `game`, `sound` y `video`, y si
volante, pedales y monedas aparecen en la columna de entradas. Si se cuelga, la pantalla muestra la consola con el
pc y el pr del hilo principal.

### Fase 2 — render PowerVR2 (lo grande)
- **Páginas de tilemap → texturas** ARGB1555 (512×256 cada una), redibujando solo los tiles que cambian o cuyo banco
  de paleta cambia.
- **NBG0:** uno a cuatro quads con scroll (y escala cuando hay zoom).
- **NBG2:** una tira por línea con la columna (scroll de fila) y la fila de origen (selección de fila) de su tabla.
- **TEXT:** página fija encima.
- **Sprites:** quads desde una caché LRU de texturas (clave: dirección en ROM, tamaño, bpp, color o tabla indirecta y
  versión de los bancos de paleta). Se recortan con los rectángulos de la lista.
- **Prioridades:** la Z de cada capa y grupo de sprites sale de los registros del mezclador (`0x20+`, grupos de
  `0x4c`).
- **Fundidos:** quad negro translúcido con el valor de los offsets.
- Validar contra `video.c` comparando capturas fotograma a fotograma, como hace el proyecto original.

### Fase 3 — sonido en el AICA
- Los 4 MB de samples del MultiPCM, en la RAM del AICA (8 MB).
- Cada escritura del Z80 en el MultiPCM (28 voces) → un canal del AICA (64): tono, volumen, pan, envolvente y bucle.
- El YM3438 solo da los timers que mueven el programa del Z80.

### Fase 4 — distribución
- `outrunners2naomi.exe` (o dentro de `dc2naomict.exe`): arrastrar `orunners.zip` y obtener el `.bin.gz` para el
  mueble Crazy Taxi. Lo derivado del ROM se genera en la máquina del usuario y no se comparte, como pide el autor.

### Memoria
- RAM principal (32 MB): sprites 16 MB + tiles 4 MB (pens a 4 bpp) + programa y estado → ~22 MB.
- RAM del AICA: los 4 MB de PCM.
- VRAM (16 MB): páginas de tilemap y caché de sprites.

## 4. Toolchain

[`outrunners/build_toolchain.sh`](../outrunners/build_toolchain.sh): sh-elf (perfil `stable` de kos-chain: GCC
15.2.0, binutils 2.45, newlib 4.6.0.20260123) con los tarballs de archive.ubuntu.com, porque el workspace bloquea los
mirrors de GNU. Después KOS en el commit `368a2eb9`, el mismo que usa Daytona nativo, en dos árboles:
`/opt/toolchains/dc/kos` (Dreamcast, para las utilidades) y `/opt/toolchains/dc/kos-naomi` (`KOS_SUBARCH=naomi`).
Con 2 núcleos tardó unos 35 minutos. La primera vez falló al compilar las utilidades de KOS (faltaban `libjpeg-dev` y `libelf-dev`; el script ya las instala): el kernel sí se compiló.

## 5. Créditos

cheviman (Sebastian Toyos), por OutRunners port y su descompilación; Aaron Giles, por ymfm; los autores del
MultiPCM y del V60 de MAME (Miguel Angel Horna, Farfetch'd, R. Belmont), en los que se basa el runtime; DragonMinded
(libnaomi), por la secuencia de lectura del cartucho que usa `naomi_dimmfs.c`; y el equipo de KallistiOS.
OutRunners es una marca de SEGA. Este proyecto no está afiliado a SEGA ni respaldado por ella.

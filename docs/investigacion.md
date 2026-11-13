# Investigación: emuladores, decompilaciones y arquitectura

Notas de fondo para elegir cómo traer un juego nuevo al mueble. El catálogo por niveles está en [juegos.md](juegos.md).

## Emulación de arcades clásicos: ¿qué versión de MAME/FBA?

| Base | Ventajas | Inconvenientes | Veredicto |
|---|---|---|---|
| **MAME 0.35 (MAME4ALL)** | Ya portado, rápido, probado | Romset antiguo; faltan Pole Position, Super Off Road, Chase HQ, Turbo OutRun… | ✅ Base actual |
| **MAME 0.37b5 (mame2000)** | Muy parecido a 0.35, algo más de juegos (Super Off Road volvió en 0.37b3) | Hay que portar el frontend de nuevo | 🟢 Buen siguiente paso |
| **MAME 0.78 (mame2003)** | Romset mucho más completo (Pole Position I/II, etc.) | Más pesado; bien para 8 bits, justo para System 16 | 🟡 Para juegos de 8 bits |
| **FBA antiguo (fbalpha2012)** | Muy fuerte en Sega System 16/18, OutRun, X-Board, Y-Board | Flojo en juegos americanos de 8 bits | 🟡 Ideal para la familia Sega |
| **MAME moderno** | Todo el romset | Imposible a velocidad en un SH-4 a 200 MHz | 🔴 |

Sobre el sonido: si un juego va justo, se puede **sustituir la emulación de sonido por música
pregrabada** (muestras) para ganar fps.

### Candidatos en MAME 0.35 (portables con el mismo frontend)

| Juego | Hardware | Control | Dificultad |
|---|---|---|---|
| **Hang-On** | Sega Hang-On | Manillar analógico | ⚠️ Hecho, lento en placa |
| **Konami GT** | Konami (Nemesis) | Volante + pedal + marcha | ⚠️ Hecho, lento en placa |
| **Super Hang-On** (bootleg `shangonb`) | Sega System 16 | Manillar + acelerador/freno | 🟢 |
| **Enduro Racer** (`endurobl`/`endurob2`, bootlegs) | Sega System 16 | Manillar; acelerador/freno digitales | 🟢 |
| **OutRun** | Sega OutRun | Volante + pedales + marcha | 🟢 (pero Cannonball es mejor) |
| **RF2 / Konami RF2** | Konami | Volante + pedal | 🟢 |
| **Spy Hunter** | Bally Midway MCR3 | Volante + pedal + marcha | 🟢 |
| **Max RPM** | MCR3 | Volante + pedal + marcha | 🟢 |
| **Destruction Derby** | MCR3 | Volante | 🟢 |
| **Turbo** | Sega | Volante + pedal + marcha | 🟢 |
| **Night Driver** | Atari | Volante | 🟢 |
| **Sprint 1 / Sprint 2** | Atari | Volante + pedal + marcha | 🟢 |
| **Super Sprint / Championship Sprint** | Atari System 2 | Volante giratorio (dial) | ✅ Super Sprint hecho, 60 fps en placa |
| **APB** | Atari System 2 | Volante | 🟢 |
| **Arkanoid** | Taito | Spinner (dial) | 🟢 (volante → velocidad de giro) |
| **Crash** | Exidy | Volante | 🟢 |

Los juegos con **dial de giro libre** (Super Sprint, Arkanoid y otros spinners) necesitan
convertir la posición del volante en velocidad de rotación; con 270° de recorrido se juegan bien
si se ajusta la sensibilidad.

### Candidatos que necesitan otra versión de MAME o FBA

| Juego | Dónde está | Notas |
|---|---|---|
| **Pole Position / Pole Position II** | mame2003 (0.78) | 3 Z8002 + Z80 + sonido; 8 bits, debería ir (Pole Position ya se juega con Namco Museum por dc2naomi) |
| **Super Off Road** | mame2000 (0.37b3+) | Volante giratorio (dial) |
| **Turbo OutRun** | FBA / MAME moderno | Sega OutRun hardware |
| **Super Monaco GP** | FBA | Sega X-Board: pesado |
| **Power Drift** | FBA / MAME moderno | Y-Board: muy pesado para SH-4 (se juega la versión de Yu Suzuki Game Works por dc2naomi) |
| **Chase H.Q.** | MAME posterior | Taito Z: pesado |

## Arquitectura del port MAME4ALL → NAOMI

- **Toolchain:** KallistiOS con `KOS_SUBARCH=naomi`, GCC 15; imagen con `naomibintool`.
- **Un binario por juego** (`GAME=hangon|konamigt`), con solo el driver necesario compilado y
  la ROM del usuario en el romdisk.
- **Vídeo:** bitmap de 8 bits → paleta RGB565 → subida por *store queues* a una textura PVR
  512x256 sin twiddle, doble buffer, un quad a 640x480. *(En placa real la VRAM no admite
  escrituras de byte: nada de buffers en VRAM.)*
- **Audio:** `snd_stream` de KOS, mono, 23040 Hz, buffer en anillo.
- **Entrada:** driver MIE/JVS de KOS. Monedas por diferencia de contadores (`coin[i].count`),
  calibración de volante/pedales, palanca enclavada LOW/HIGH, START largo = overlay de FPS.
- **CPU 68000:** FAMEC (C) para la principal, Musashi para la secundaria (el núcleo ASM de FAME
  falla con Hang-On).
- **Herramienta `romzip.py`:** reempaqueta un romset moderno con los nombres de MAME 0.35 usando
  el CRC32.
- **Pruebas:** Flycast parcheado (MIE en modo NAOMI) + scripts de rendimiento y carrera.

## Decompilaciones, recompilaciones y ports

| Proyecto | Estado | ¿Viable en NAOMI? | Comentario |
|---|---|---|---|
| **Cannonball** (OutRun) | Completo | ✅ Hecho | Motor reescrito en C++ |
| **OutRunners port** (cheviman) | Port nativo en C sobre su descompilación; 16 escenarios iguales a MAME | 🧪 En curso | Imagen por la PowerVR2 a 60 fps en placa (2026-11-13); sonido en el AICA sin probar. [estudio](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md) |
| **Daytona USA static recomp** | Arranca | 🟠 ~27 fps | Rama `naomi`; aparcado por el port nativo |
| **Daytona USA nativo** (`platform/dreamcast-native`) | Completo en Dreamcast (60 fps) | ✅ 60 fps en NAOMI 2 | Rama `naomi-native`; ROM `daytona93` + programa de sonido del set padre `daytona` |
| **Scud Race** (wanszai) | Port desde decompilación, solo Windows/Xbox | 🔴 de momento | Repositorio muy reciente; sin licencia clara |
| **Ridge Racer Collection / Sega Rally** (wanszai) | PC/Xbox | 🔴 de momento | Pensado para PC; demasiado para SH-4 sin reescribir el render |
| **namco22-decompile** | En curso | 🔴 | Rave Racer, Dirt Dash, Tokyo Wars, Prop Cycle |
| **Ridge Racer (PSX) decomp** | 100 % matching + recomp | 🟠 | Habría que portarlo al PVR; posible a largo plazo |
| **Wipeout (PSX) → Dreamcast** | Port DC a 60 fps | 🟠 | ~172 MB: cabe en el NetDIMM, pero necesita adaptar arranque y entrada NAOMI |
| **Mario Kart 64 → Dreamcast** (mk64-dc) | ~30 fps | 🧪 | Convertido con dc2naomi, sin probar en placa |
| **Wave Race 64 DC** | En curso | 🟠 | Esperar |
| **Sonic R decomp** | Port DC planeado | 🟠 | Esperar |
| **Virtua Racing** | Solo desensamblado de 32X; núcleo FPGA de Model 1 | 🔴 | No hay decompilación del arcade |
| **Arkanoid** | Desensamblado Z80 | ✅ vía MAME | No hace falta decomp: MAME 0.35 lo emula sobrado |
| Turbo OutRun, Super Off Road | No encontrado | — | Usar emulación |

**Idea clave:** un port de Dreamcast casi siempre es el atajo para NAOMI, porque el hardware es
casi el mismo (SH-4 + PowerVR2 + AICA). Lo que cambia es el arranque (cabecera NAOMI), la entrada
(JVS en vez de Maple) y que la VRAM no admite escrituras de byte.

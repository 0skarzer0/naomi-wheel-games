# Investigación: emuladores, decompilaciones y arquitectura

> 🇬🇧 **English:** [the English version is at the end of this page ↓](#english)

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

---

## English

*Translation of the Spanish text above. If the two ever disagree, the Spanish one is the up-to-date one.*

### Research: emulators, decompilations and architecture

Background notes for choosing how to bring a new game to the cabinet. The catalogue by level is in
[juegos.md](juegos.md).

#### Emulating classic arcades: which MAME/FBA version?

| Base | Pros | Cons | Verdict |
|---|---|---|---|
| **MAME 0.35 (MAME4ALL)** | Already ported, fast, tested | Old romset; Pole Position, Super Off Road, Chase HQ, Turbo OutRun… are missing | ✅ Current base |
| **MAME 0.37b5 (mame2000)** | Very close to 0.35, a few more games (Super Off Road returned in 0.37b3) | The frontend has to be ported again | 🟢 Good next step |
| **MAME 0.78 (mame2003)** | Much more complete romset (Pole Position I/II, etc.) | Heavier; fine for 8-bit, tight for System 16 | 🟡 For 8-bit games |
| **Old FBA (fbalpha2012)** | Very strong on Sega System 16/18, OutRun, X-Board, Y-Board | Weak on American 8-bit games | 🟡 Ideal for the Sega family |
| **Modern MAME** | The whole romset | Impossible at full speed on a 200 MHz SH-4 | 🔴 |

About sound: if a game is tight, the **sound emulation can be replaced by prerecorded music** (samples) to gain fps.

##### Candidates in MAME 0.35 (portable with the same frontend)

| Game | Hardware | Control | Difficulty |
|---|---|---|---|
| **Hang-On** | Sega Hang-On | Analogue handlebar | ⚠️ Done, slow on the board |
| **Konami GT** | Konami (Nemesis) | Wheel + pedal + gear | ⚠️ Done, slow on the board |
| **Super Hang-On** (bootleg `shangonb`) | Sega System 16 | Handlebar + accelerator/brake | 🟢 |
| **Enduro Racer** (`endurobl`/`endurob2`, bootlegs) | Sega System 16 | Handlebar; digital accelerator/brake | 🟢 |
| **OutRun** | Sega OutRun | Wheel + pedals + gear | 🟢 (but Cannonball is better) |
| **RF2 / Konami RF2** | Konami | Wheel + pedal | 🟢 |
| **Spy Hunter** | Bally Midway MCR3 | Wheel + pedal + gear | 🟢 |
| **Max RPM** | MCR3 | Wheel + pedal + gear | 🟢 |
| **Destruction Derby** | MCR3 | Wheel | 🟢 |
| **Turbo** | Sega | Wheel + pedal + gear | 🟢 |
| **Night Driver** | Atari | Wheel | 🟢 |
| **Sprint 1 / Sprint 2** | Atari | Wheel + pedal + gear | 🟢 |
| **Super Sprint / Championship Sprint** | Atari System 2 | Spinning wheel (dial) | ✅ Super Sprint done, 60 fps on the board |
| **APB** | Atari System 2 | Wheel | 🟢 |
| **Arkanoid** | Taito | Spinner (dial) | 🟢 (wheel → turning speed) |
| **Crash** | Exidy | Wheel | 🟢 |

Games with a **free-spinning dial** (Super Sprint, Arkanoid and other spinners) need the wheel's position turned into
a rotation speed; with 270° of travel they play well if the sensitivity is tuned.

##### Candidates that need another MAME or FBA version

| Game | Where it is | Notes |
|---|---|---|
| **Pole Position / Pole Position II** | mame2003 (0.78) | 3 Z8002 + Z80 + sound; 8-bit, it should run (Pole Position is already played with Namco Museum through dc2naomi) |
| **Super Off Road** | mame2000 (0.37b3+) | Spinning wheel (dial) |
| **Turbo OutRun** | FBA / modern MAME | Sega OutRun hardware |
| **Super Monaco GP** | FBA | Sega X-Board: heavy |
| **Power Drift** | FBA / modern MAME | Y-Board: far too heavy for the SH-4 (the Yu Suzuki Game Works version is played through dc2naomi) |
| **Chase H.Q.** | Later MAME | Taito Z: heavy |

#### Architecture of the MAME4ALL → NAOMI port

- **Toolchain:** KallistiOS with `KOS_SUBARCH=naomi`, GCC 15; image made with `naomibintool`.
- **One binary per game** (`GAME=hangon|konamigt`), with only the needed driver compiled in and the user's ROM in the
  romdisk.
- **Video:** 8-bit bitmap → RGB565 palette → uploaded by *store queues* to a 512x256 non-twiddled PVR texture, double
  buffered, one quad at 640x480. *(On real hardware the VRAM takes no byte writes: no buffers in VRAM.)*
- **Audio:** KOS's `snd_stream`, mono, 23040 Hz, ring buffer.
- **Input:** KOS's MIE/JVS driver. Coins by counter difference (`coin[i].count`), wheel/pedal calibration, LOW/HIGH
  latched shifter, long START = FPS overlay.
- **68000 CPU:** FAMEC (C) for the main one, Musashi for the second (FAME's ASM core fails with Hang-On).
- **`romzip.py` tool:** repacks a modern romset with MAME 0.35's names using the CRC32.
- **Tests:** patched Flycast (MIE in NAOMI mode) + performance and race scripts.

#### Decompilations, recompilations and ports

| Project | Status | Viable on the NAOMI? | Comment |
|---|---|---|---|
| **Cannonball** (OutRun) | Complete | ✅ Done | Engine rewritten in C++ |
| **OutRunners port** (cheviman) | Native C port on its decompilation; 16 scenarios identical to MAME | 🧪 In progress | Picture through the PowerVR2 at 60 fps on the board (2026-11-13); sound on the AICA untested. [study](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md) |
| **Daytona USA static recomp** | Boots | 🟠 ~27 fps | Branch `naomi`; parked in favour of the native port |
| **Native Daytona USA** (`platform/dreamcast-native`) | Complete on the Dreamcast (60 fps) | ✅ 60 fps on the NAOMI 2 | Branch `naomi-native`; ROM `daytona93` + sound program of the parent set `daytona` |
| **Scud Race** (wanszai) | Port from a decompilation, Windows/Xbox only | 🔴 for now | Very recent repository; no clear licence |
| **Ridge Racer Collection / Sega Rally** (wanszai) | PC/Xbox | 🔴 for now | Made for PC; too much for the SH-4 without rewriting the renderer |
| **namco22-decompile** | In progress | 🔴 | Rave Racer, Dirt Dash, Tokyo Wars, Prop Cycle |
| **Ridge Racer (PSX) decomp** | 100 % matching + recomp | 🟠 | It would have to be ported to the PVR; possible in the long run |
| **Wipeout (PSX) → Dreamcast** | DC port at 60 fps | 🟠 | ~172 MB: it fits in the NetDIMM, but needs its boot and input adapted to the NAOMI |
| **Mario Kart 64 → Dreamcast** (mk64-dc) | ~30 fps | 🧪 | Converted with dc2naomi, untested on the board |
| **Wave Race 64 DC** | In progress | 🟠 | Wait |
| **Sonic R decomp** | DC port planned | 🟠 | Wait |
| **Virtua Racing** | Only a 32X disassembly; Model 1 FPGA core | 🔴 | No decompilation of the arcade game |
| **Arkanoid** | Z80 disassembly | ✅ via MAME | No decomp needed: MAME 0.35 emulates it with room to spare |
| Turbo OutRun, Super Off Road | Not found | — | Use emulation |

**Key idea:** a Dreamcast port is almost always the shortcut to the NAOMI, because the hardware is almost the same
(SH-4 + PowerVR2 + AICA). What changes is the boot (NAOMI header), the input (JVS instead of Maple) and that the VRAM
takes no byte writes.

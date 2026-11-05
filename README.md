# Naomi Wheel Games — juegos de volante, moto y spinner para un mueble Crazy Taxi (NAOMI + NetDIMM)

Objetivo: reunir **el máximo número de juegos de coches, motos y spinner** que se puedan arrancar por
**netboot (NetDIMM)** en un mueble **Crazy Taxi NAOMI** con sus controles originales, y documentarlo
todo para que otros usuarios (y otras IAs) puedan reutilizar el trabajo.

> **Política de ROMs:** este repositorio **no contiene ROMs** ni binarios que las incluyan.
> Solo hay código, herramientas, parches y documentación. Cada usuario genera sus `.bin`
> a partir de sus propios volcados.

---

## 0. Repositorios del proyecto

| Repositorio | Qué es | Traspaso |
|---|---|---|
| [mame4all-naomi](https://github.com/0skarzer0/mame4all-naomi) | MAME4ALL (MAME 0.35) para NAOMI: Hang-On, Konami GT… | [HANDOFF.md](https://github.com/0skarzer0/mame4all-naomi/blob/naomi/HANDOFF.md) |
| [dreamcast-cannonball](https://github.com/0skarzer0/dreamcast-cannonball/tree/naomi) (rama `naomi`) | Cannonball (OutRun) para NAOMI | [naomi/HANDOFF.md](https://github.com/0skarzer0/dreamcast-cannonball/blob/naomi/naomi/HANDOFF.md) |
| [daytona-arcade-recomp](https://github.com/0skarzer0/daytona-arcade-recomp/tree/naomi) (rama `naomi`) | Recompilación de Daytona USA (Model 2) para NAOMI | [platform/dreamcast/HANDOFF.md](https://github.com/0skarzer0/daytona-arcade-recomp/blob/naomi/platform/dreamcast/HANDOFF.md) |
| [daytona-arcade-recomp](https://github.com/0skarzer0/daytona-arcade-recomp/tree/naomi-native) (rama `naomi-native`) | **Port nativo** de Daytona USA (reescrito en C para SH-4, PR #58 del original) para NAOMI | [platform/dreamcast-native/naomi/HANDOFF.md](https://github.com/0skarzer0/daytona-arcade-recomp/blob/naomi-native/platform/dreamcast-native/naomi/HANDOFF.md) |
| [dc2naomi](https://github.com/0skarzer0/dc2naomi) | Cargador de juegos de Dreamcast en NAOMI (experimental) | [HANDOFF.md](https://github.com/0skarzer0/dc2naomi/blob/main/HANDOFF.md) |
| [naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches) | Parches de controles (IPS) para juegos NAOMI / NAOMI 2 / Atomiswave en el mueble Crazy Taxi | [HANDOFF.md](https://github.com/0skarzer0/naomi-ct-patches/blob/main/HANDOFF.md) |

### Cómo retomar el trabajo en un chat nuevo (personas o IAs)

1. Lee este README para la visión general.
2. Lee el `HANDOFF.md` del repositorio en el que vas a trabajar: estado, arquitectura, direcciones,
   cómo compilar y siguientes pasos.
3. Al terminar la sesión, actualiza ese `HANDOFF.md` y, si cambia el estado de algún juego, este README.

### Pendientes generales (2026-11-05)

- MAME4ALL en placa real: Hang-On 47/16 fps y Konami GT 46/13 fps (en Flycast iban a 60), sonido malo y cuelgues (posiblemente con el contador de FPS activo); controles perfectos. Diagnosticar (ver HANDOFF de mame4all-naomi).
- Probar el nuevo control de Cannonball (START al soltar, START + R = vista).
- Probar dc2naomi con Yu Suzuki Game Works.
- **Estándar de controles común** para todos los juegos del mueble: hoy freno + START = crédito en MAME4ALL y = menú en Cannonball.
- Daytona recomp: en carrera va a ~13 fps y baja a 5–8 con muchos coches (medido con el cronómetro del juego). Issue [#62](https://github.com/alphanu1/daytona-arcade-recomp/issues/62) en el repositorio de alphanu1 (2026-11-05); respuesta del autor: probar el **nuevo port nativo** (`platform/dreamcast-native`, 60 fps en Dreamcast).
- **Daytona nativo en NAOMI** (rama `naomi-native`, 2026-11-05): **probado en placa (2026-11-06): controles, gráficos y música perfectos**; faltaban las voces del locutor (selección de pista y cambio, «Gentlemen start your engines», «Time extended»): segunda imagen con las voces, pendiente de probar. Falta también comprobar el guardado en SRAM (0x6000-0x7FFF).
- Jambo! Safari: ✅ **resuelto con parche** ([naomi-ct-patches/jambo-safari](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari)): el lazo se lanza con la palanca del Crazy Taxi sin tocar cableado (variante cruzada, probada en placa). Siguiente: el resto de juegos NAOMI / NAOMI 2 / Atomiswave con el mismo procedimiento ([naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches)).
- dc2naomi: **Yu Suzuki Game Works Vol. 1** preparado como banco de pruebas (imagen de 201 MB con el disco
  original, parches verificados); falta compilar el loader con KallistiOS y probar en Flycast / placa.

---

## 1. Hardware de referencia

| Elemento | Detalle |
|---|---|
| Placa | NAOMI 2 con multibios (también vale NAOMI 1 para casi todo) |
| Carga | NetDIMM 512 MB, netboot desde Raspberry Pi 3 con **WiPi Netbooter** (`.bin.gz` + línea en `romsinfo.csv`) |
| Monitor | 31 kHz (VGA 640x480) |
| Controles | Volante analógico (~270°), acelerador, freno, palanca de 2 posiciones con retorno (adelante/atrás), START, monedero |

Consecuencias para los juegos:

- **Volante absoluto** → perfecto para juegos con volante/potenciómetro. Para spinner/dial (rotación
  infinita) hay que convertir la posición del volante en velocidad de giro.
- **Palanca de 2 posiciones con retorno** → se usa como cambio LOW/HIGH con enclavamiento por software
  (adelante = HIGH, atrás = LOW). Juegos con H de 4/6 velocidades quedan peor.
- **Solo un jugador** con controles de coche; un segundo jugador no tiene mandos.

---

## 2. Resumen rápido por niveles

| Nivel | Qué significa | Juegos |
|---|---|---|
| ✅ **Funciona ya** | Arranca por netboot hoy | Crazy Taxi, Jambo! Safari (lazo con parche), 18 Wheeler, juegos NAOMI 2 (Club Kart, King of Route 66, Wild Riders), Atomiswave convertidos (Maximum Speed, Faster Than Speed), **Cannonball (OutRun)** |
| ⚠️ **Hecho, lento en placa** | En Flycast a 60; en placa ~46 fps y cuelgues | **Hang-On** y **Konami GT** (MAME4ALL portado) |
| 🟢 **Fácil** | Mismo port MAME4ALL, solo hay que añadir el driver | Super Hang-On, Enduro Racer, Spy Hunter, Max RPM, Turbo, Sprint 2, Super Sprint, Arkanoid… |
| 🟡 **Medio** | Requiere portar otra versión de MAME/FBA o un port nativo | Pole Position, Super Off Road, Turbo OutRun, Power Drift, Super Monaco GP, OutRunners (decomp) |
| 🟠 **Difícil** | Mucho trabajo o rendimiento justo | Daytona USA (recomp, ~27 fps), Wipeout / Mario Kart 64 (ports de DC), recopilatorios de Dreamcast |
| 🔴 **No viable (hoy)** | Hardware demasiado potente o sin código | Model 2/3 emulados (Sega Rally, Scud Race, Daytona 2), Ridge Racer arcade, Virtua Racing arcade, Initial D (tarjetas), Sega Driving Simulator (3 monitores) |

---

## 3. Juegos nativos (sin emulación)

### 3.1 NAOMI

| Juego | Controles originales | En mueble Crazy Taxi | Notas |
|---|---|---|---|
| **Crazy Taxi** | Volante, 2 pedales, palanca D/R | ✅ Perfecto | Es el juego del mueble |
| **Jambo! Safari** | Volante, palanca, pedales | ✅ Con parche (probado en placa) | Mismo volante que Crazy Taxi, pero lee la palanca en las entradas del J2: sin el [parche de controles](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari) no se lanza el lazo |
| **18 Wheeler: American Pro Trucker** (STD/DX) | Volante con force feedback, palanca de 3 posiciones (low/high/reverse), 2 pedales | ✅ Jugable | Volante con distinto tope (≈320°), se juega bien |
| **Wave Runner GP** | Manillar de moto acuática | ✅ Jugable | El manillar es analógico como un volante |
| **Ferrari F355 Challenge** (twin/deluxe) / **F355 Challenge 2** | Volante, 3 pedales, palanca de 6 velocidades (o levas) | ⚠️ Comprobar | El deluxe usa 3 placas/3 monitores; probar la versión twin/1 pantalla y el cambio automático |

No son NAOMI aunque a veces se confunden: *Emergency Call Ambulance* es **Model 3**.

### 3.2 NAOMI 2 (necesitan placa NAOMI 2; el multibios del mueble lo es)

| Juego | Formato | En mueble Crazy Taxi | Notas |
|---|---|---|---|
| **Club Kart: European Session** / **Club Kart Prize** | Cartucho | ✅ | Karts, volante + pedales |
| **The King of Route 66** | Cartucho | ✅ | Secuela de 18 Wheeler |
| **Wild Riders** | Cartucho | ✅ (manillar → volante) | Motos; en algunos sets hay que ajustar el freno trasero en el menú de test |
| **Soul Surfer** | Cartucho | ⚠️ | Tabla de surf, control raro con volante |
| **Initial D Arcade Stage 1/2/3** | GD-ROM | 🔴/⚠️ | Pide lector de tarjetas magnéticas; investigar si arranca sin él |
| **Sega Driving Simulator** | — | 🔴 | 3 monitores, sistema de autoescuela |

### 3.3 Atomiswave → NAOMI (conversiones de Darksoft)

Las conversiones **AW2NAOMI** se cargan por netboot igual que un `.bin` normal de NAOMI.
Recomendación de la comunidad: **NetDIMM con 512 MB como máximo** (pasar el test de DIMM).

| Juego | Año | Notas |
|---|---|---|
| **Maximum Speed** | 2003 | Carreras, volante |
| **Faster Than Speed** | 2004 | Carreras, volante (hay versión con fix al salir del menú de servicio) |

Los ajustes por defecto se pueden fijar con un SRAM generado en Demul + `attach_sram` del repositorio
de netboot de DragonMinded.

---

## 4. Ports propios en este proyecto

| Proyecto | Estado | Rendimiento | Comentario |
|---|---|---|---|
| **Cannonball** (OutRun, motor reescrito) | ✅ Funciona | 60 fps | Solo con ROMs de OutRun (no sirve para Turbo OutRun ni Super Hang-On) |
| **MAME4ALL Hang-On** | ⚠️ Lento en placa | Placa: 47/16; Flycast: 60 / 41–55 | Controles OK; cuelgue en etapa 1 |
| **MAME4ALL Konami GT** | ⚠️ Lento en placa | Placa: 46/13; Flycast: 60 | Controles OK; sonido malo; cuelgue |
| **Daytona USA recomp** (rama `naomi`) | 🟠 Arranca | ~27 fps | Limitado por CPU (i960 ≈19 ms, TGP ≈7 ms por frame); sustituido por el port nativo |
| **Daytona USA nativo** (rama `naomi-native`) | ✅ Funciona (voces en prueba) | Fluido en placa | El juego reescrito en C (dfchil/alphanu1), idéntico al original; assets desde la NetDIMM, JVS, SRAM |
| **Daytona USA 2001** (DC → NAOMI) | 🔴 Parado | — | Pantalla negra; el cargador de juegos de Dreamcast en NAOMI no está resuelto |
| **Yu Suzuki Game Works Vol. 1** (DC → NAOMI) | 🧪 Flycast OK | — | Menú y Power Drift jugables en Flycast (NAOMI); pendiente de placa |

### 4.1 Arquitectura del port MAME4ALL → NAOMI (lo que ya existe)

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

---

## 5. Emulación de arcades clásicos: ¿qué versión de MAME/FBA?

| Base | Ventajas | Inconvenientes | Veredicto |
|---|---|---|---|
| **MAME 0.35 (MAME4ALL)** | Ya portado, rápido, probado | Romset antiguo; faltan Pole Position, Super Off Road, Chase HQ, Turbo OutRun… | ✅ Base actual |
| **MAME 0.37b5 (mame2000)** | Muy parecido a 0.35, algo más de juegos (Super Off Road volvió en 0.37b3) | Hay que portar el frontend de nuevo | 🟢 Buen siguiente paso |
| **MAME 0.78 (mame2003)** | Romset mucho más completo (Pole Position I/II, etc.) | Más pesado; bien para 8 bits, justo para System 16 | 🟡 Para juegos de 8 bits |
| **FBA antiguo (fbalpha2012)** | Muy fuerte en Sega System 16/18, OutRun, X-Board, Y-Board | Flojo en juegos americanos de 8 bits | 🟡 Ideal para la familia Sega |
| **MAME moderno** | Todo el romset | Imposible a velocidad en un SH-4 a 200 MHz | 🔴 |

Sobre el sonido: si un juego va justo, se puede **sustituir la emulación de sonido por música
pregrabada** (muestras) para ganar fps.

### 5.1 Candidatos en MAME 0.35 (portables con el mismo frontend)

| Juego | Hardware | Control | Dificultad |
|---|---|---|---|
| **Hang-On** | Sega Hang-On | Manillar analógico | 🧪 Hecho |
| **Konami GT** | Konami (Nemesis) | Volante + pedal + marcha | 🧪 Hecho |
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
| **Super Sprint / Championship Sprint** | Atari System 2 | Volante giratorio (dial) | 🟢 (falta revisar el romset) |
| **APB** | Atari System 2 | Volante | 🟢 |
| **Arkanoid** | Taito | Spinner (dial) | 🟢 (volante → velocidad de giro) |
| **Crash** | Exidy | Volante | 🟢 |

Los juegos con **dial de giro libre** (Super Sprint, Arkanoid y otros spinners) necesitan
convertir la posición del volante en velocidad de rotación; con 270° de recorrido se juegan bien
si se ajusta la sensibilidad.

### 5.2 Candidatos que necesitan otra versión de MAME o FBA

| Juego | Dónde está | Notas |
|---|---|---|
| **Pole Position / Pole Position II** | mame2003 (0.78) | 3 Z8002 + Z80 + sonido; 8 bits, debería ir |
| **Super Off Road** | mame2000 (0.37b3+) | Volante giratorio (dial) |
| **Turbo OutRun** | FBA / MAME moderno | Sega OutRun hardware |
| **Super Monaco GP** | FBA | Sega X-Board: pesado |
| **Power Drift** | FBA / MAME moderno | Y-Board: muy pesado para SH-4 |
| **Chase H.Q.** | MAME posterior | Taito Z: pesado |

---

## 6. Decompilaciones, recompilaciones y ports

| Proyecto | Estado | ¿Viable en NAOMI? | Comentario |
|---|---|---|---|
| **Cannonball** (OutRun) | Completo | ✅ Hecho | Motor reescrito en C++ |
| **OutRunners decomp** (cheviman) | ~79 % de funciones limpias; System 32 modelado en C; 16 escenarios iguales a MAME | 🟡 Prometedor | C + SDL2; cuando esté completo, portable a KOS |
| **Daytona USA static recomp** | Arranca | 🟠 ~27 fps | Ya en rama `naomi` |
| **Daytona USA nativo** (`platform/dreamcast-native`) | Completo en Dreamcast (60 fps) | 🟡 Compilado para NAOMI | Rama `naomi-native`; ROM `daytona93` + programa de sonido del set padre `daytona` |
| **Scud Race** (wanszai) | Port desde decompilación, solo Windows/Xbox | 🔴 de momento | Repositorio muy reciente; sin licencia clara |
| **Ridge Racer Collection / Sega Rally** (wanszai) | PC/Xbox | 🔴 de momento | Pensado para PC; demasiado para SH-4 sin reescribir el render |
| **namco22-decompile** | En curso | 🔴 | Rave Racer, Dirt Dash, Tokyo Wars, Prop Cycle |
| **Ridge Racer (PSX) decomp** | 100 % matching + recomp | 🟠 | Habría que portarlo al PVR; posible a largo plazo |
| **Wipeout (PSX) → Dreamcast** | Port DC a 60 fps | 🟠 | ~172 MB: cabe en el NetDIMM, pero necesita adaptar arranque y entrada NAOMI |
| **Mario Kart 64 → Dreamcast** (mk64-dc) | ~30 fps | 🟠 | Mismo trabajo de adaptación que Wipeout |
| **Wave Race 64 DC** | En curso | 🟠 | Esperar |
| **Sonic R decomp** | Port DC planeado | 🟠 | Esperar |
| **Virtua Racing** | Solo desensamblado de 32X; núcleo FPGA de Model 1 | 🔴 | No hay decompilación del arcade |
| **Arkanoid** | Desensamblado Z80 | ✅ vía MAME | No hace falta decomp: MAME 0.35 lo emula sobrado |
| Turbo OutRun, Super Off Road | No encontrado | — | Usar emulación |

**Idea clave:** un port de Dreamcast casi siempre es el atajo para NAOMI, porque el hardware es
casi el mismo (SH-4 + PowerVR2 + AICA). Lo que cambia es el arranque (cabecera NAOMI), la entrada
(JVS en vez de Maple) y que la VRAM no admite escrituras de byte.

---

## 7. Recopilatorios de Dreamcast (si se resuelve el cargador DC → NAOMI)

| Recopilatorio | Juegos de coches/motos |
|---|---|
| **Yu Suzuki Game Works Vol. 1** | Hang-On, OutRun, Power Drift (+ Space Harrier, After Burner II) |
| **Namco Museum** | Pole Position |
| **Midway's Greatest Arcade Hits Vol. 1** | Spy Hunter (versión DC) |
| **Midway's Greatest Arcade Hits Vol. 2** | Spy Hunter, 720° |
| Atari Anniversary Edition | Sin juegos de coches |

Todos dependen de que el cargador de juegos de Dreamcast en NAOMI funcione (falló con Daytona 2001).
**Yu Suzuki Game Works** es ahora el banco de pruebas: 204 MB de ficheros, cabe en la NetDIMM con sus
LBA originales; análisis completo en el HANDOFF de dc2naomi.

---

## 8. Hoja de ruta propuesta

1. **Validar en placa real** Hang-On y Konami GT (MAME4ALL).
2. **Ampliar MAME4ALL-NAOMI** con los juegos de 5.1: Super Hang-On, Enduro Racer, Spy Hunter,
   Max RPM, Turbo, Sprint 2, Super Sprint, Arkanoid (modo spinner).
3. **Frontend común tipo libretro para NAOMI** (vídeo PVR, audio AICA, JVS con volante, pedales,
   palanca y monedero) para enchufar `mame2000`, `mame2003` y `fbalpha2012`.
4. **FBA 2012** para la familia Sega (Turbo OutRun, Super Monaco GP) y **mame2003** para
   Pole Position.
5. **Cargador Dreamcast → NAOMI** para recopilatorios y ports (Wipeout, Mario Kart 64).
6. Seguir **OutRunners decomp**; probar en placa el **Daytona nativo** (rama `naomi-native`) y, si funciona, ofrecer `NATIVE_NAOMI` al proyecto original.

## 8.1 Parches de controles

Algunos juegos nativos esperan la palanca o los botones en otros pines que el mueble Crazy Taxi. En vez
de recablear, se parchea el código del juego. Todo está en el repositorio [naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches):
tabla por juego, procedimiento y herramientas (`apply_patch.py`, desensamblador e intérprete SH-4).

## 9. Estructura del repositorio propuesta

```
naomi-wheel-games/
├── README.md              ← este documento
├── docs/
│   ├── hardware.md        ← mueble, JVS, calibración, netboot
│   ├── games.md           ← tabla completa de compatibilidad
│   └── porting-guide.md   ← cómo portar un driver nuevo (para personas e IAs)
├── mame4all-naomi/        ← código del port (sin ROMs)
├── frontend/              ← frontend común (futuro)
├── tools/
│   ├── romzip.py          ← reempaquetado de romsets por CRC32
│   └── make_romsinfo.py   ← genera líneas de romsinfo.csv para WiPi
└── flycast-patches/       ← parches para probar MIE/JVS en Flycast
```

## 10. Aviso legal

- No se distribuyen ROMs, BIOS ni binarios que las contengan.
- Las marcas pertenecen a sus propietarios (Sega, Konami, Atari, Namco, Midway, Taito…).
- Los proyectos de terceros (decompilaciones, Cannonball, MAME, FBA) mantienen sus licencias;
  MAME 0.35/0.37/0.78 y FBA antiguo tienen **licencias no comerciales**.

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
| [naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches) | Parches de controles (IPS) para juegos NAOMI / NAOMI 2 / Atomiswave en el mueble Crazy Taxi, y lector de tarjetas virtual (Initial D) | [HANDOFF.md](https://github.com/0skarzer0/naomi-ct-patches/blob/main/HANDOFF.md) |
| [model1-naomi](https://github.com/0skarzer0/model1-naomi) | Virtua Racing (Sega Model 1) en NAOMI: estudio de viabilidad | [HANDOFF.md](https://github.com/0skarzer0/model1-naomi/blob/main/HANDOFF.md) |

**Hardware del mueble, valores JVS de volante y pedales y trampas del hardware real:** [docs/hardware.md](docs/hardware.md).
**Qué hay cargado hoy en la Raspberry del mueble y qué está probado en la placa:** [docs/pi60-juegos.md](docs/pi60-juegos.md).

### Cómo retomar el trabajo en un chat nuevo (personas o IAs)

1. Lee este README para la visión general.
2. Lee el `HANDOFF.md` del repositorio en el que vas a trabajar: estado, arquitectura, direcciones,
   cómo compilar y siguientes pasos.
3. Al terminar la sesión, actualiza ese `HANDOFF.md` y, si cambia el estado de algún juego, este README.

### Estado a 2026-11-13

- **dc2naomi (juegos de Dreamcast en la NAOMI):** funcionan en el mueble, probados en placa, **Crazy Taxi 2, Namco
  Museum (Pole Position), Daytona USA 2001, F355 Challenge, 18 Wheeler, Sega Rally 2 (Windows CE) y los cinco juegos de
  Yu Suzuki Game Works en imágenes separadas** (OutRun, Hang-On, Power Drift, After Burner II, Space Harrier), todos
  con su VMU guardada en un fichero de la Raspberry. Arreglos de esta semana, todos medidos en placa: el petardeo de la
  música de Power Drift (su mezclador se quedaba parado una vuelta del anillo de sonido cuando un tic llegaba tarde),
  mandos propios de After Burner II (gases analógicos en el gatillo L, disparo automático) con **las luces del arcade
  en el botón START del mueble**, disparo rápido en Space Harrier, y la RAM del juego puesta a cero antes de arrancar.
  Convertidos y subidos, **pendientes de probar en placa:** Test Drive 6, Test Drive Le Mans, Wacky Races, Jeremy
  McGrath Supercross 2000, Star Wars Episode I Racer, Demolition Racer, TNN Hardcore Heat, Tokyo Xtreme Racer 2,
  Metropolis Street Racer (audio a mono para que quepa), San Francisco Rush 2049 (dos versiones) y la demo de
  **OutRun 2006 Coast 2 Coast de ArkRetro** (v37). Lista completa: [docs/pi60-juegos.md](docs/pi60-juegos.md).
- **MAME4ALL:** **Super Sprint a 60 fps en la placa** (CPU T11 recompilada estáticamente). Hang-On y Konami GT siguen
  lentos en placa.
- **naomi-ct-patches:** Jambo! Safari probado en placa; 18 Wheeler e Initial D con parche verificado en intérprete, y un
  **lector de tarjetas virtual** para Initial D (imagen `initiald_exp_reva_ct` en la Raspberry).
- **model1-naomi:** midiendo si el SH-4 puede emular el V60 de Virtua Racing; nada jugable todavía.

### Pendientes generales (2026-11-05, histórico)

- MAME4ALL en placa real: Hang-On 47/16 fps y Konami GT 46/13 fps (en Flycast iban a 60), sonido malo y cuelgues (posiblemente con el contador de FPS activo); controles perfectos. Diagnosticar (ver HANDOFF de mame4all-naomi).
- Probar el nuevo control de Cannonball (START al soltar, START + R = vista).
- **Estándar de controles común** para todos los juegos del mueble: hoy freno + START = crédito en MAME4ALL y = menú en Cannonball.
- Daytona recomp: en carrera va a ~13 fps y baja a 5–8 con muchos coches (medido con el cronómetro del juego). Issue [#62](https://github.com/alphanu1/daytona-arcade-recomp/issues/62) en el repositorio de alphanu1 (2026-11-05); respuesta del autor: probar el **nuevo port nativo** (`platform/dreamcast-native`, 60 fps en Dreamcast).
- **Daytona nativo en NAOMI** (rama `naomi-native`, 2026-11-05): **terminado y medido en placa (2026-11-11)**: 60 fps en demo y en carrera (dibujo 7,7-11,3 ms de los 16,67 disponibles), controles, gráficos, voces y música correctos. La música de Beginner necesitó una copia ADPCM propia (el hueco libre de la RAM del AICA queda fragmentado por las frases del locutor). La imagen contesta a los *peeks* de la NetDIMM: `naomi/live.py` lee fps y log por red desde la Pi. Ajustes de esa noche: bocina del menú residente (suena a la vez que la voz), una frase del locutor corta a la anterior, carga de música 8 veces más rápida (Game Over de 1.186 ms a ~250) y tablas de dibujo de Expert activadas usando los 32 MB. Pendiente: en la pantalla de Game Over el port no dibuja el coche de fondo (decisión del proyecto original: los bancos de paleta del coche se reutilizan para los rótulos del resultado).
- Jambo! Safari: ✅ **resuelto con parche** ([naomi-ct-patches/jambo-safari](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari)): el lazo se lanza con la palanca del Crazy Taxi sin tocar cableado (variante cruzada, probada en placa). Siguiente: el resto de juegos NAOMI / NAOMI 2 / Atomiswave con el mismo procedimiento ([naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches)).
- dc2naomi (2026-11-10) — **funciona en placa.** La pantalla negra tras el logo de SEGA era la escritura de `PCTRA`
  del residente, que en la NAOMI 2 deja sin respuesta al TA (el 3D). Quitada, **funcionan en el mueble Crazy Taxi:
  Crazy Taxi 2, Namco Museum, Yu Suzuki Game Works y Daytona USA 2001**, e Ikaruga en el mueble estándar. Mandos
  por juego (volante, pedales, palanca), memoria (VMU) emulada y **guardada en un fichero `.vmu` por juego en la
  Raspberry del WiPi**: comprobado que Daytona recupera su partida tras cargar otro juego. Programa para Windows
  (`dc2naomi.exe` / `dc2naomict.exe`, v0.2, sin release todavía). F355 y 18 Wheeler ya funcionan en placa (con VMU). Aparcados: KOF99, Last Blade 2.
  Siguiente: reconvertir con VMU los juegos hechos sin ella.
  Todo el detalle en el [HANDOFF de dc2naomi](https://github.com/0skarzer0/dc2naomi/blob/main/HANDOFF.md).
- **OutRunners** (2026-11-13) — **port empezado**, a partir de [cheviman/outrunners-port](https://github.com/cheviman/outrunners-port).
  Medido con el ROM del propietario: la lógica del juego y el programa del Z80 caben de sobra en el SH-4. El vídeo
  tal cual (mezcla por píxel al estilo de MAME, ~21 M instrucciones x86 por fotograma) no cabe: hay que dibujar con
  la PowerVR2. OutRunners usa poco del chip: capas TEXT, NBG0 y NBG2, ~56 sprites por fotograma, sin sombras ni
  ventanas. El FM no toca notas, así que el sonido se reduce al MultiPCM, que pasará al AICA.
  Estudio, mediciones y plan por fases: [docs/outrunners.md](docs/outrunners.md). **Fase 1 compilada** (arranque,
  JVS y tiempos en vivo por la NetDIMM; vídeo provisional por software): imagen lista, **sin probar en placa**.

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
| **Daytona USA nativo** (rama `naomi-native`) | ✅ Funciona | 60 fps en placa (medidos por NetDIMM) | El juego reescrito en C (dfchil/alphanu1), idéntico al original; assets desde la NetDIMM, JVS, SRAM |
| **Daytona USA 2001** (DC → NAOMI) | ✅ Funciona en placa | — | dc2naomi `daytona5`: mandos del mueble y VMU guardada en fichero (comprobado en placa) |
| **Yu Suzuki Game Works Vol. 1** (DC → NAOMI) | ✅ Funciona en placa | — | Disco entero (`ysgw7`) y **una imagen por juego** (OutRun, Hang-On, Power Drift, After Burner II, Space Harrier), todas probadas en placa. Power Drift: petardeo de la música resuelto. After Burner II: disparo automático, acelerador = gases, freno = misil y luces del arcade en el botón START. Space Harrier: disparo rápido en el acelerador |
| **Coches de Dreamcast por lotes** (DC → NAOMI) | 🧪 Subidos, sin probar en placa | — | Test Drive 6, TD Le Mans, Wacky Races, Jeremy McGrath Supercross 2000, Star Wars Racer, Demolition Racer, TNN Hardcore Heat, Tokyo Xtreme Racer 2, Metropolis Street Racer, SF Rush 2049: mandos del mueble y VMU desbloqueada; los que no cabían en 512 MB, con vídeos recodificados o audio a mono |
| **OutRun 2006 Coast 2 Coast**, demo de ArkRetro (homebrew de DC → NAOMI) | 🧪 Subida, sin probar en placa | — | v37 (2026-11-12): llega al título y a la demo en Flycast; cabe en 512 MB con 4 de sus 28 canciones largas (las demás suenan como una de esas cuatro) |
| **Super Sprint** (MAME4ALL) | ✅ Funciona en placa | 60 fps | T11 recompilado estáticamente; volante como volante giratorio |
| **Virtua Tennis** (DC → NAOMI) | ✅ Arranca en placa | — | Primer juego de Dreamcast que arrancó en la placa real (2026-11-08); faltan los mandos |
| **Ikaruga** (DC → NAOMI) | ✅ Terminado | — | Mueble estándar (palancas, 6 botones); con VMU en fichero y partida desbloqueada (probado en placa) |
| **Crazy Taxi 2** (DC → NAOMI) | ✅ Terminado | — | `ct2h7`: volante, pedales, marchas con la palanca, salto con doble toque adelante |
| **Namco Museum** (DC → NAOMI) | ✅ Terminado | — | `nmus7`: Pole Position con volante, VMU en fichero (comprobado en placa) |
| **F355, 18 Wheeler** (DC → NAOMI) | ✅ Funcionan en placa | — | Con VMU en fichero y partida desbloqueada; terminados |
| **Sega Rally 2** (DC, Windows CE → NAOMI) | ✅ Funciona en placa | — | Con VMU en fichero; sin la música de las carreras (CDDA); modo oculto de 30 FPS activado de serie (pendiente de probar en placa) |

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
| **OutRunners port** (cheviman) | Port nativo en C sobre su descompilación; 16 escenarios iguales a MAME | 🟡 En curso | Medido (2026-11-13): lógica y Z80 caben; vídeo a reescribir para PVR2, sonido MultiPCM → AICA. [docs/outrunners.md](docs/outrunners.md) |
| **Daytona USA static recomp** | Arranca | 🟠 ~27 fps | Ya en rama `naomi` |
| **Daytona USA nativo** (`platform/dreamcast-native`) | Completo en Dreamcast (60 fps) | ✅ 60 fps en NAOMI 2 | Rama `naomi-native`; ROM `daytona93` + programa de sonido del set padre `daytona` |
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
| **Yu Suzuki Game Works Vol. 1** | Hang-On, OutRun, Power Drift (+ Space Harrier, After Burner II): ✅ **funcionan en placa** |
| **Namco Museum** | Pole Position: ✅ **funciona en placa** |
| **Midway's Greatest Arcade Hits Vol. 1** | Spy Hunter (versión DC) |
| **Midway's Greatest Arcade Hits Vol. 2** | Spy Hunter, 720° |
| Atari Anniversary Edition | Sin juegos de coches |

Todos dependen de que el cargador de juegos de Dreamcast en NAOMI funcione. **Ya arranca un juego en placa
(Virtua Tennis, 2026-11-08)**; los que suben el sonido por DMA G2 (Ikaruga, probablemente Namco Museum) se paran,
porque esa DMA no termina en la NAOMI.
**Yu Suzuki Game Works** es ahora el banco de pruebas: 204 MB de ficheros, cabe en la NetDIMM con sus
LBA originales; análisis completo en el HANDOFF de dc2naomi.
**Namco Museum** (5,7 MB) es el segundo banco de pruebas: funciona en Flycast; en la placa se congela al arrancar
el sonido (sospechoso: la DMA G2 del AICA, como Ikaruga; antes se sospechó del bit 5 de `SB_FFST`).
Qué cambió SEGA entre el Crazy Taxi de Dreamcast y el de NAOMI: [docs/crazy-taxi-dreamcast-vs-naomi.md](docs/crazy-taxi-dreamcast-vs-naomi.md).

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
6. **Portar OutRunners** ([docs/outrunners.md](docs/outrunners.md): arranque y medida en placa, render PVR2, sonido en el AICA); probar en placa el **Daytona nativo** (rama `naomi-native`) y, si funciona, ofrecer `NATIVE_NAOMI` al proyecto original.

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

---

## 11. Agradecimientos

Este proyecto solo adapta al mueble el trabajo de otras personas; todo lo siguiente lo ha hecho posible, de forma
directa o como inspiración o ayuda indirecta. Si falta alguien, abrid una issue y se añade.

- **alphanu1** ([daytona-arcade-recomp](https://github.com/alphanu1/daytona-arcade-recomp)) y **dfchil**, autor del port
  nativo de Daytona USA (PR #58) y de [enDjinn](https://github.com/dfchil/enDjinn),
  [AICAflow](https://github.com/dfchil/aicaflow) y [AICAforge](https://github.com/dfchil/AICAforge). Daytona nativo
  en NAOMI es su juego funcionando en otra placa. Detalle en el
  [README de la rama `naomi-native`](https://github.com/0skarzer0/daytona-arcade-recomp/blob/naomi-native/platform/dreamcast-native/naomi/README.md#acknowledgements).
- **DragonMinded**: [libnaomi](https://github.com/DragonMinded/libnaomi) (lectura por el puerto de cartucho y protocolo
  de peek / poke de la NetDIMM), las herramientas de netboot (`netdimm.py`, `netdimm_send`) y el repositorio de netboot
  con `attach_sram`.
- **El equipo y los colaboradores de KallistiOS**, con su subarquitectura NAOMI y `naomibintool`, base de todos los
  ports nativos de este proyecto; y los proyectos **GNU binutils, GCC y newlib**, que forman la toolchain `sh-elf`.
- **El WiPi Netbooter y Piforce / [Piforce-Web](https://github.com/dev-tty0/Piforce-Web)**, que a su vez usan las
  herramientas Triforce de debugmode: la Raspberry Pi que arranca la placa por red.
- **Darksoft**, por las conversiones AW2NAOMI de Atomiswave.
- **Chris White**, autor de **Cannonball** (OutRun), y quienes lo portaron a Dreamcast, de donde parte el port a NAOMI
  ([dreamcast-cannonball](https://github.com/0skarzer0/dreamcast-cannonball)).
- **El equipo de MAME y los autores de MAME4ALL, mame2000, mame2003 y FBA**, base del port de arcades clásicos.
- **Flycast** y sus colaboradores, el emulador con el que se prueba antes de subirlo a la placa.
- **[ArkRetro](https://github.com/ArkRetro)**, autor de la demo de OutRun 2006 Coast 2 Coast para Dreamcast que se juega en el
  mueble con dc2naomi.
- **[bucanero](https://github.com/bucanero)** ([dreamcast-saves](https://github.com/bucanero/dreamcast-saves)): las partidas
  desbloqueadas que llevan en su VMU los juegos de Dreamcast del mueble. El resto de lo que usa dc2naomi está en sus
  [agradecimientos](https://github.com/0skarzer0/dc2naomi#agradecimientos).
- **gyrovorbis** ([SH4ZAM](https://github.com/gyrovorbis/sh4zam)) y **la comunidad de vgmrips**, cuyo pack de música de
  Daytona USA (Sega Model 2) es lo que suena en el port.
- **Los autores de los proyectos de la sección 6** que sirven de referencia o futura base: cheviman (OutRunners port y su descompilación; Aaron Giles, por ymfm, en el que se basa su YM3438),
  wanszai (Scud Race, Ridge Racer Collection, Sega Rally), namco22-decompile, la decompilación de Ridge Racer (PSX), el
  port de Wipeout a Dreamcast, mk64-dc, Wave Race 64 DC y la decompilación de Sonic R.
- **Claude** (Anthropic), a través de Claude Code: el código y la documentación de los ports de este proyecto se han
  escrito y depurado con Claude en sesiones con el propietario del mueble, que es quien prueba cada imagen en la placa
  y aporta las fotos y las mediciones de las que sale cada diagnóstico.

Los nombres que aparecen aquí se conocen por los repositorios y las páginas citadas; las licencias de cada proyecto
siguen siendo las suyas (sección 10).

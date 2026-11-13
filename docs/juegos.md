# Juegos para el mueble Crazy Taxi: catálogo y compatibilidad

> 🇬🇧 **English:** [the English version is at the end of this page ↓](#english)

Qué se puede jugar en un mueble Crazy Taxi NAOMI con sus controles, por niveles de dificultad. **Qué está cargado hoy
en la Raspberry del mueble y qué está probado en placa:** [pi60-juegos.md](pi60-juegos.md) (la tabla de estado al
día). Las versiones de MAME/FBA y las decompilaciones candidatas: [investigacion.md](investigacion.md).

## Resumen rápido por niveles

| Nivel | Qué significa | Juegos |
|---|---|---|
| ✅ **Funciona ya** | Arranca por netboot hoy | Crazy Taxi, Jambo! Safari (lazo con parche), 18 Wheeler, juegos NAOMI 2 (Club Kart, King of Route 66, Wild Riders), Atomiswave convertidos (Maximum Speed, Faster Than Speed), **Cannonball (OutRun)**, **Daytona USA nativo**, **Super Sprint** (MAME4ALL), los juegos de Dreamcast convertidos con dc2naomi |
| 🧪 **En curso** | Funciona en parte o sin probar en placa | **OutRunners** (port nativo: imagen a 60 fps en placa, sonido sin probar) |
| ⚠️ **Hecho, lento en placa** | En Flycast a 60; en placa ~46 fps y cuelgues | **Hang-On** y **Konami GT** (MAME4ALL portado) |
| 🟢 **Fácil** | Mismo port MAME4ALL, solo hay que añadir el driver | Super Hang-On, Enduro Racer, Spy Hunter, Max RPM, Turbo, Sprint 2, Arkanoid… |
| 🟡 **Medio** | Requiere portar otra versión de MAME/FBA o un port nativo | Super Off Road, Turbo OutRun, Super Monaco GP (Pole Position y Power Drift ya se juegan por dc2naomi) |
| 🟠 **Difícil** | Mucho trabajo o rendimiento justo | Wipeout (port de DC) |
| 🔴 **No viable (hoy)** | Hardware demasiado potente o sin código | Model 2/3 emulados (Sega Rally, Scud Race, Daytona 2), Ridge Racer arcade, Virtua Racing arcade, Initial D (tarjetas), Sega Driving Simulator (3 monitores) |

## Juegos nativos (sin emulación)

### NAOMI

| Juego | Controles originales | En mueble Crazy Taxi | Notas |
|---|---|---|---|
| **Crazy Taxi** | Volante, 2 pedales, palanca D/R | ✅ Perfecto | Es el juego del mueble |
| **Jambo! Safari** | Volante, palanca, pedales | ✅ Con parche (probado en placa) | Mismo volante que Crazy Taxi, pero lee la palanca en las entradas del J2: sin el [parche de controles](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari) no se lanza el lazo |
| **18 Wheeler: American Pro Trucker** (STD/DX) | Volante con force feedback, palanca de 3 posiciones (low/high/reverse), 2 pedales | ✅ Jugable | Volante con distinto tope (≈320°), se juega bien |
| **Wave Runner GP** | Manillar de moto acuática | ✅ Jugable | El manillar es analógico como un volante |
| **Ferrari F355 Challenge** (twin/deluxe) / **F355 Challenge 2** | Volante, 3 pedales, palanca de 6 velocidades (o levas) | ⚠️ Comprobar | El deluxe usa 3 placas/3 monitores; probar la versión twin/1 pantalla y el cambio automático |

No son NAOMI aunque a veces se confunden: *Emergency Call Ambulance* es **Model 3**.

### NAOMI 2 (necesitan placa NAOMI 2; el multibios del mueble lo es)

| Juego | Formato | En mueble Crazy Taxi | Notas |
|---|---|---|---|
| **Club Kart: European Session** / **Club Kart Prize** | Cartucho | ✅ | Karts, volante + pedales |
| **The King of Route 66** | Cartucho | ✅ | Secuela de 18 Wheeler |
| **Wild Riders** | Cartucho | ✅ (manillar → volante) | Motos; en algunos sets hay que ajustar el freno trasero en el menú de test |
| **Soul Surfer** | Cartucho | ⚠️ | Tabla de surf, control raro con volante |
| **Initial D Arcade Stage 1/2/3** | GD-ROM | 🔴/⚠️ | Pide lector de tarjetas magnéticas; investigar si arranca sin él |
| **Sega Driving Simulator** | — | 🔴 | 3 monitores, sistema de autoescuela |

### Atomiswave → NAOMI (conversiones de Darksoft)

Las conversiones **AW2NAOMI** se cargan por netboot igual que un `.bin` normal de NAOMI.
Recomendación de la comunidad: **NetDIMM con 512 MB como máximo** (pasar el test de DIMM).

| Juego | Año | Notas |
|---|---|---|
| **Maximum Speed** | 2003 | Carreras, volante |
| **Faster Than Speed** | 2004 | Carreras, volante (hay versión con fix al salir del menú de servicio) |

Los ajustes por defecto se pueden fijar con un SRAM generado en Demul + `attach_sram` del repositorio
de netboot de DragonMinded.

## Ports propios y conversiones

| Proyecto | Estado | Rendimiento | Comentario |
|---|---|---|---|
| **Cannonball** (OutRun, motor reescrito) | ✅ Funciona | 60 fps | Solo con ROMs de OutRun (no sirve para Turbo OutRun ni Super Hang-On) |
| **MAME4ALL Hang-On** | ⚠️ Lento en placa | Placa: 47/16; Flycast: 60 / 41–55 | Controles OK; cuelgue en etapa 1 |
| **MAME4ALL Konami GT** | ⚠️ Lento en placa | Placa: 46/13; Flycast: 60 | Controles OK; sonido malo; cuelgue |
| **Daytona USA recomp** (rama `naomi`) | 🟠 Aparcado | ~27 fps (13 en carrera) | Limitado por CPU (i960 ≈19 ms, TGP ≈7 ms por frame); sustituido por el port nativo |
| **Daytona USA nativo** (rama `naomi-native`) | ✅ Funciona | 60 fps en placa (medidos por NetDIMM) | El juego reescrito en C (dfchil/alphanu1), idéntico al original; assets desde la NetDIMM, JVS, SRAM |
| **Daytona USA 2001** (DC → NAOMI) | ✅ Funciona en placa | — | dc2naomi `daytona5`: mandos del mueble y VMU guardada en fichero (comprobado en placa) |
| **Yu Suzuki Game Works Vol. 1** (DC → NAOMI) | ✅ Funciona en placa | — | Disco entero (`ysgw7`) y **una imagen por juego** (OutRun, Hang-On, Power Drift, After Burner II, Space Harrier), todas probadas en placa. Power Drift: petardeo de la música resuelto. After Burner II: disparo automático, acelerador = gases, freno = misil y luces del arcade en el botón START. Space Harrier: disparo rápido en el acelerador |
| **Coches de Dreamcast por lotes** (DC → NAOMI) | 🧪 Subidos, sin probar en placa | — | Test Drive 6, TD Le Mans, Wacky Races, Jeremy McGrath Supercross 2000, Star Wars Racer, Demolition Racer, TNN Hardcore Heat, Tokyo Xtreme Racer 2, Metropolis Street Racer, SF Rush 2049: mandos del mueble y VMU desbloqueada; los que no cabían en 512 MB, con vídeos recodificados o audio a mono |
| **OutRun 2006 Coast 2 Coast**, demo de ArkRetro (homebrew de DC → NAOMI) | 🧪 Subida, sin probar en placa | — | v37 (2026-11-12): llega al título y a la demo en Flycast; cabe en 512 MB con 4 de sus 28 canciones largas (las demás suenan como una de esas cuatro) |
| **Mario Kart 64** (port de Dreamcast de jnmartin84, homebrew KallistiOS → NAOMI) | ✅ Funciona en placa | ~30 fps, alguna caída | Compilado con KallistiOS parcheada (`NAOMI_HOST`) y empaquetado con dc2naomi ([receta](https://github.com/0skarzer0/dc2naomi/tree/main/homebrew/mk64)); acelerador = A, freno = B, palanca adelante = salto/derrape, atrás = objeto; sin VMU todavía; versión en español pendiente |
| **Super Sprint** (MAME4ALL) | ✅ Funciona en placa | 60 fps | T11 recompilado estáticamente; volante como volante giratorio |
| **OutRunners** (port nativo de cheviman/outrunners-port) | 🧪 En curso | 60 fps en placa (imagen) | Imagen por la PowerVR2 probada en placa; sombras, fundidos y sonido en el AICA hechos y sin probar. [estudio](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md) |
| **Virtua Tennis** (DC → NAOMI) | ✅ Arranca en placa | — | Primer juego de Dreamcast que arrancó en la placa real (2026-11-08); faltan los mandos |
| **Ikaruga** (DC → NAOMI) | ✅ Terminado | — | Mueble estándar (palancas, 6 botones); con VMU en fichero y partida desbloqueada (probado en placa) |
| **Crazy Taxi 2** (DC → NAOMI) | ✅ Terminado | — | `ct2h7`: volante, pedales, marchas con la palanca, salto con doble toque adelante |
| **Namco Museum** (DC → NAOMI) | ✅ Terminado | — | `nmus7`: Pole Position con volante, VMU en fichero (comprobado en placa) |
| **F355, 18 Wheeler** (DC → NAOMI) | ✅ Funcionan en placa | — | Con VMU en fichero y partida desbloqueada; terminados |
| **Sega Rally 2** (DC, Windows CE → NAOMI) | ✅ Funciona en placa | — | Con VMU en fichero; sin la música de las carreras (CDDA); modo oculto de 30 FPS activado de serie (probado en placa) |

## Recopilatorios de Dreamcast (con dc2naomi)

| Recopilatorio | Juegos de coches/motos |
|---|---|
| **Yu Suzuki Game Works Vol. 1** | Hang-On, OutRun, Power Drift (+ Space Harrier, After Burner II): ✅ **funcionan en placa** |
| **Namco Museum** | Pole Position: ✅ **funciona en placa** |
| **Midway's Greatest Arcade Hits Vol. 1** | Spy Hunter (versión DC) |
| **Midway's Greatest Arcade Hits Vol. 2** | Spy Hunter, 720° |
| Atari Anniversary Edition | Sin juegos de coches |

Se cargan con [dc2naomi](https://github.com/0skarzer0/dc2naomi), que funciona en placa desde el 2026-11-10 (Yu Suzuki
Game Works y Namco Museum incluidos; la historia de cómo se llegó, en su HANDOFF y en [historial.md](historial.md)).
Faltan por probar los de Midway.
Qué cambió SEGA entre el Crazy Taxi de Dreamcast y el de NAOMI: [crazy-taxi-dreamcast-vs-naomi.md](crazy-taxi-dreamcast-vs-naomi.md).

## Parches de controles

Algunos juegos nativos esperan la palanca o los botones en otros pines que el mueble Crazy Taxi. En vez
de recablear, se parchea el código del juego. Todo está en el repositorio [naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches):
tabla por juego, procedimiento y herramientas (`apply_patch.py`, desensamblador e intérprete SH-4).

---

## English

*Translation of the Spanish text above. If the two ever disagree, the Spanish one is the up-to-date one.*

### Games for the Crazy Taxi cabinet: catalogue and compatibility

What can be played on a Crazy Taxi NAOMI cabinet with its controls, by difficulty. **What is loaded today on the
cabinet's Raspberry Pi and what has been tested on the board:** [pi60-juegos.md](pi60-juegos.md) (the up-to-date status
table). Candidate MAME/FBA versions and decompilations: [investigacion.md](investigacion.md).

#### Quick summary by level

| Level | Meaning | Games |
|---|---|---|
| ✅ **Already works** | Boots by netboot today | Crazy Taxi, Jambo! Safari (lasso with a patch), 18 Wheeler, NAOMI 2 games (Club Kart, King of Route 66, Wild Riders), converted Atomiswave games (Maximum Speed, Faster Than Speed), **Cannonball (OutRun)**, **native Daytona USA**, **Super Sprint** (MAME4ALL), the Dreamcast games converted with dc2naomi |
| 🧪 **In progress** | Partly works or untested on the board | **OutRunners** (native port: picture at 60 fps on the board, sound untested) |
| ⚠️ **Done, slow on the board** | 60 in Flycast; ~46 fps and hangs on the board | **Hang-On** and **Konami GT** (ported MAME4ALL) |
| 🟢 **Easy** | Same MAME4ALL port, only the driver has to be added | Super Hang-On, Enduro Racer, Spy Hunter, Max RPM, Turbo, Sprint 2, Arkanoid… |
| 🟡 **Medium** | Needs porting another MAME/FBA version or a native port | Super Off Road, Turbo OutRun, Super Monaco GP (Pole Position and Power Drift are already played through dc2naomi) |
| 🟠 **Hard** | A lot of work or tight performance | Wipeout (DC port) |
| 🔴 **Not viable (today)** | Hardware too powerful or no code | Emulated Model 2/3 (Sega Rally, Scud Race, Daytona 2), Ridge Racer arcade, Virtua Racing arcade, Initial D (cards), Sega Driving Simulator (3 monitors) |

#### Native games (no emulation)

##### NAOMI

| Game | Original controls | On the Crazy Taxi cabinet | Notes |
|---|---|---|---|
| **Crazy Taxi** | Wheel, 2 pedals, D/R shifter | ✅ Perfect | It is the cabinet's own game |
| **Jambo! Safari** | Wheel, shifter, pedals | ✅ With a patch (tested on the board) | Same wheel as Crazy Taxi, but it reads the shifter on player 2's inputs: without the [control patch](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari) the lasso cannot be thrown |
| **18 Wheeler: American Pro Trucker** (STD/DX) | Force-feedback wheel, 3-position shifter (low/high/reverse), 2 pedals | ✅ Playable | Wheel with a different stop (≈320°), plays well |
| **Wave Runner GP** | Jet-ski handlebar | ✅ Playable | The handlebar is analogue like a wheel |
| **Ferrari F355 Challenge** (twin/deluxe) / **F355 Challenge 2** | Wheel, 3 pedals, 6-speed shifter (or paddles) | ⚠️ To check | The deluxe uses 3 boards/3 monitors; try the twin/single-screen version and automatic gears |

Not NAOMI although sometimes mistaken for it: *Emergency Call Ambulance* is **Model 3**.

##### NAOMI 2 (they need a NAOMI 2 board; the cabinet's multi-BIOS board is one)

| Game | Format | On the Crazy Taxi cabinet | Notes |
|---|---|---|---|
| **Club Kart: European Session** / **Club Kart Prize** | Cartridge | ✅ | Karts, wheel + pedals |
| **The King of Route 66** | Cartridge | ✅ | Sequel to 18 Wheeler |
| **Wild Riders** | Cartridge | ✅ (handlebar → wheel) | Motorbikes; in some sets the rear brake has to be adjusted in the test menu |
| **Soul Surfer** | Cartridge | ⚠️ | Surfboard, awkward control with a wheel |
| **Initial D Arcade Stage 1/2/3** | GD-ROM | 🔴/⚠️ | Asks for a magnetic card reader; find out whether it boots without one |
| **Sega Driving Simulator** | — | 🔴 | 3 monitors, driving-school system |

##### Atomiswave → NAOMI (Darksoft's conversions)

The **AW2NAOMI** conversions are loaded by netboot just like a normal NAOMI `.bin`. The community's advice:
**a NetDIMM with 512 MB at most** (it must pass the DIMM test).

| Game | Year | Notes |
|---|---|---|
| **Maximum Speed** | 2003 | Racing, wheel |
| **Faster Than Speed** | 2004 | Racing, wheel (there is a version with a fix for leaving the service menu) |

Default settings can be fixed with an SRAM made in Demul + `attach_sram` from DragonMinded's netboot repository.

#### Own ports and conversions

| Project | Status | Performance | Comment |
|---|---|---|---|
| **Cannonball** (OutRun, rewritten engine) | ✅ Works | 60 fps | OutRun ROMs only (not for Turbo OutRun or Super Hang-On) |
| **MAME4ALL Hang-On** | ⚠️ Slow on the board | Board: 47/16; Flycast: 60 / 41–55 | Controls OK; hang in stage 1 |
| **MAME4ALL Konami GT** | ⚠️ Slow on the board | Board: 46/13; Flycast: 60 | Controls OK; bad sound; hang |
| **Daytona USA recomp** (branch `naomi`) | 🟠 Parked | ~27 fps (13 in a race) | CPU-bound (i960 ≈19 ms, TGP ≈7 ms per frame); replaced by the native port |
| **Native Daytona USA** (branch `naomi-native`) | ✅ Works | 60 fps on the board (measured through the NetDIMM) | The game rewritten in C (dfchil/alphanu1), identical to the original; assets from the NetDIMM, JVS, SRAM |
| **Daytona USA 2001** (DC → NAOMI) | ✅ Works on the board | — | dc2naomi `daytona5`: the cabinet's controls and the VMU saved in a file (checked on the board) |
| **Yu Suzuki Game Works Vol. 1** (DC → NAOMI) | ✅ Works on the board | — | Whole disc (`ysgw7`) and **one image per game** (OutRun, Hang-On, Power Drift, After Burner II, Space Harrier), all tested on the board. Power Drift: music crackling fixed. After Burner II: auto-fire, accelerator = throttle, brake = missile and the arcade's lamps on the START button. Space Harrier: rapid fire on the accelerator |
| **Dreamcast racing games in batches** (DC → NAOMI) | 🧪 Uploaded, untested on the board | — | Test Drive 6, TD Le Mans, Wacky Races, Jeremy McGrath Supercross 2000, Star Wars Racer, Demolition Racer, TNN Hardcore Heat, Tokyo Xtreme Racer 2, Metropolis Street Racer, SF Rush 2049: the cabinet's controls and an unlocked VMU; those that did not fit in 512 MB with re-encoded videos or mono audio |
| **OutRun 2006 Coast 2 Coast**, ArkRetro's demo (DC homebrew → NAOMI) | 🧪 Uploaded, untested on the board | — | v37 (2026-11-12): reaches the title and the demo in Flycast; fits in 512 MB with 4 of its 28 long songs (the others play as one of those four) |
| **Mario Kart 64** (jnmartin84's Dreamcast port, KallistiOS homebrew → NAOMI) | ✅ Works on the board | ~30 fps, some drops | Built with a patched KallistiOS (`NAOMI_HOST`) and packed with dc2naomi ([recipe](https://github.com/0skarzer0/dc2naomi/tree/main/homebrew/mk64)); gas = A, brake = B, lever forward = hop/drift, back = item; no VMU yet; Spanish version pending |
| **Super Sprint** (MAME4ALL) | ✅ Works on the board | 60 fps | T11 statically recompiled; wheel as a spinning wheel |
| **OutRunners** (native port of cheviman/outrunners-port) | 🧪 In progress | 60 fps on the board (picture) | Picture through the PowerVR2 tested on the board; shadows, fades and sound on the AICA done and untested. [study](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md) |
| **Virtua Tennis** (DC → NAOMI) | ✅ Boots on the board | — | First Dreamcast game that booted on the real board (2026-11-08); controls missing |
| **Ikaruga** (DC → NAOMI) | ✅ Finished | — | Standard cabinet (sticks, 6 buttons); with the VMU in a file and an unlocked save (tested on the board) |
| **Crazy Taxi 2** (DC → NAOMI) | ✅ Finished | — | `ct2h7`: wheel, pedals, gears with the shifter, jump with a double tap forward |
| **Namco Museum** (DC → NAOMI) | ✅ Finished | — | `nmus7`: Pole Position with the wheel, VMU in a file (checked on the board) |
| **F355, 18 Wheeler** (DC → NAOMI) | ✅ Work on the board | — | With the VMU in a file and an unlocked save; finished |
| **Sega Rally 2** (DC, Windows CE → NAOMI) | ✅ Works on the board | — | With the VMU in a file; without the race music (CDDA); hidden 30 FPS mode on by default (tested on the board) |

#### Dreamcast compilations (with dc2naomi)

| Compilation | Car/bike games |
|---|---|
| **Yu Suzuki Game Works Vol. 1** | Hang-On, OutRun, Power Drift (+ Space Harrier, After Burner II): ✅ **work on the board** |
| **Namco Museum** | Pole Position: ✅ **works on the board** |
| **Midway's Greatest Arcade Hits Vol. 1** | Spy Hunter (DC version) |
| **Midway's Greatest Arcade Hits Vol. 2** | Spy Hunter, 720° |
| Atari Anniversary Edition | No car games |

They are loaded with [dc2naomi](https://github.com/0skarzer0/dc2naomi), which has worked on the board since 2026-11-10
(Yu Suzuki Game Works and Namco Museum included; how it got there, in its HANDOFF and in [historial.md](historial.md)).
The Midway ones are still to be tested. What SEGA changed between the Dreamcast and the NAOMI Crazy Taxi:
[crazy-taxi-dreamcast-vs-naomi.md](crazy-taxi-dreamcast-vs-naomi.md).

#### Control patches

Some native games expect the shifter or the buttons on different pins than the Crazy Taxi cabinet. Instead of
rewiring, the game's code is patched. Everything is in the [naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches)
repository: a table per game, the procedure and the tools (`apply_patch.py`, an SH-4 disassembler and interpreter).

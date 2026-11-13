# Juegos para el mueble Crazy Taxi: catálogo y compatibilidad

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
| 🟠 **Difícil** | Mucho trabajo o rendimiento justo | Wipeout (port de DC), Mario Kart 64 (port de DC, convertido, sin probar en placa) |
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
| **Super Sprint** (MAME4ALL) | ✅ Funciona en placa | 60 fps | T11 recompilado estáticamente; volante como volante giratorio |
| **OutRunners** (port nativo de cheviman/outrunners-port) | 🧪 En curso | 60 fps en placa (imagen) | Imagen por la PowerVR2 probada en placa; sombras, fundidos y sonido en el AICA hechos y sin probar. [estudio](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md) |
| **Virtua Tennis** (DC → NAOMI) | ✅ Arranca en placa | — | Primer juego de Dreamcast que arrancó en la placa real (2026-11-08); faltan los mandos |
| **Ikaruga** (DC → NAOMI) | ✅ Terminado | — | Mueble estándar (palancas, 6 botones); con VMU en fichero y partida desbloqueada (probado en placa) |
| **Crazy Taxi 2** (DC → NAOMI) | ✅ Terminado | — | `ct2h7`: volante, pedales, marchas con la palanca, salto con doble toque adelante |
| **Namco Museum** (DC → NAOMI) | ✅ Terminado | — | `nmus7`: Pole Position con volante, VMU en fichero (comprobado en placa) |
| **F355, 18 Wheeler** (DC → NAOMI) | ✅ Funcionan en placa | — | Con VMU en fichero y partida desbloqueada; terminados |
| **Sega Rally 2** (DC, Windows CE → NAOMI) | ✅ Funciona en placa | — | Con VMU en fichero; sin la música de las carreras (CDDA); modo oculto de 30 FPS activado de serie (pendiente de probar en placa) |

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

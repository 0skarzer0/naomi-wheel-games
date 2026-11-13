# Historial del proyecto

> 🇬🇧 **English:** [the English version is at the end of this page ↓](#english)

Estados y pendientes fechados que ya no describen el presente; se guardan porque explican decisiones. El estado
actual está en el [README](../README.md) y en [pi60-juegos.md](pi60-juegos.md); el detalle de cada port, en su
`HANDOFF.md`.

## 2026-11-12 y 13: lector de tarjetas virtual y free play

- Primer lector de tarjetas virtual (Initial D Rev A): arranca en placa y el juego habla con él sin errores. Falta
  comprobar compra y grabado de tarjeta. Detalle en el [HANDOFF de naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches/blob/main/HANDOFF.md).
- Initial D se cuelga en el attract tras una partida también sin parchear: BIOS multirregión (ver [pi60-juegos.md](pi60-juegos.md)).
- Free play y attract mudo en 49 de las 50 imágenes de la Pi; King of Route 66 corrupto.
- Acceso a la Pi desde la nube: shell del PC del usuario (en la misma red) y SSH.

## 2026-11-13 (tarde): reorganización

- Nace [naomi-kit](https://github.com/0skarzer0/naomi-kit) y OutRunners pasa a usarlo; la recompilación de Daytona para
  Dreamcast se marca sin mantenimiento y se elimina de la rama `naomi-native` (el nativo ya funciona en placa).
- Se añaden CONTRIBUTING, el mapa de repos, la tabla de estado y la propuesta de controles comunes.

## Estado a 2026-11-13 (copia del README de ese día)

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
  **OutRun 2006 Coast 2 Coast de ArkRetro** (v37). Lista completa: [docs/pi60-juegos.md](pi60-juegos.md).
- **MAME4ALL:** **Super Sprint a 60 fps en la placa** (CPU T11 recompilada estáticamente). Hang-On y Konami GT siguen
  lentos en placa.
- **naomi-ct-patches:** Jambo! Safari probado en placa; 18 Wheeler e Initial D con parche verificado en intérprete, y un
  **lector de tarjetas virtual** para Initial D (imagen `initiald_exp_reva_ct` en la Raspberry).
- **model1-naomi:** midiendo si el SH-4 puede emular el V60 de Virtua Racing; nada jugable todavía.

## Pendientes generales a 2026-11-05

- MAME4ALL en placa real: Hang-On 47/16 fps y Konami GT 46/13 fps (en Flycast iban a 60), sonido malo y cuelgues (posiblemente con el contador de FPS activo); controles perfectos. Diagnosticar (ver HANDOFF de mame4all-naomi).
- Probar el nuevo control de Cannonball (START al soltar, START + R = vista).
- **Estándar de controles común** para todos los juegos del mueble: hoy START pulsado = crédito (al soltar, START) en MAME4ALL y = menú en Cannonball.
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
  Estudio, mediciones y plan por fases: [estudio de OutRunners](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md). **Fase 2 en la placa** (2026-11-13):
  render PowerVR2 a 60 fps en attract y casi toda la carrera; sonido en el AICA (fase 3) hecho, sin probar aún.

## Hoja de ruta de la primera semana (2026-11-04)

Planteada al empezar; los puntos 1, 5 y 6 se han hecho (Hang-On y Konami GT, validados y lentos en placa; dc2naomi
funciona; OutRunners y Daytona nativo, en placa).


1. **Validar en placa real** Hang-On y Konami GT (MAME4ALL).
2. **Ampliar MAME4ALL-NAOMI** con los juegos de 5.1: Super Hang-On, Enduro Racer, Spy Hunter,
   Max RPM, Turbo, Sprint 2, Super Sprint, Arkanoid (modo spinner).
3. **Frontend común tipo libretro para NAOMI** (vídeo PVR, audio AICA, JVS con volante, pedales,
   palanca y monedero) para enchufar `mame2000`, `mame2003` y `fbalpha2012`.
4. **FBA 2012** para la familia Sega (Turbo OutRun, Super Monaco GP) y **mame2003** para
   Pole Position.
5. **Cargador Dreamcast → NAOMI** para recopilatorios y ports (Wipeout, Mario Kart 64).
6. **Portar OutRunners** ([estudio de OutRunners](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md): arranque y medida en placa, render PVR2, sonido en el AICA); probar en placa el **Daytona nativo** (rama `naomi-native`) y, si funciona, ofrecer `NATIVE_NAOMI` al proyecto original.

---

## English

*Translation of the Spanish text above. If the two ever disagree, the Spanish one is the up-to-date one.*

### Project history

Dated statuses and to-do lists that no longer describe the present; they are kept because they explain decisions.
The current status is in the [README](../README.md) and in [pi60-juegos.md](pi60-juegos.md); each port's details, in its
`HANDOFF.md`.

#### 2026-11-12 and 13: virtual card reader and free play

- First virtual card reader (Initial D Rev A): it boots on the board and the game talks to it without errors. Buying
  and writing a card still to be checked. Details in the
  [naomi-ct-patches HANDOFF](https://github.com/0skarzer0/naomi-ct-patches/blob/main/HANDOFF.md).
- Initial D hangs in attract mode after a game also unpatched: multi-region BIOS (see [pi60-juegos.md](pi60-juegos.md)).
- Free play and silent attract in 49 of the 50 images on the Pi; King of Route 66 corrupt.
- Access to the Pi from the cloud: a shell on the user's PC (on the same network) and SSH.

#### 2026-11-13 (afternoon): reorganisation

- [naomi-kit](https://github.com/0skarzer0/naomi-kit) is born and OutRunners starts using it; the Daytona
  recompilation for the Dreamcast is marked unmaintained and removed from the `naomi-native` branch (the native one
  already works on the board).
- CONTRIBUTING, the repo map, the status table and the common controls proposal are added.

#### Status at 2026-11-13 (copy of that day's README)

- **dc2naomi (Dreamcast games on the NAOMI):** working on the cabinet, tested on the board: **Crazy Taxi 2, Namco
  Museum (Pole Position), Daytona USA 2001, F355 Challenge, 18 Wheeler, Sega Rally 2 (Windows CE) and the five Yu Suzuki
  Game Works games in separate images** (OutRun, Hang-On, Power Drift, After Burner II, Space Harrier), all with their
  VMU saved in a file on the Raspberry Pi. This week's fixes, all measured on the board: Power Drift's music crackling
  (its mixer stood still for one turn of the sound ring when a tick came late), After Burner II's own controls
  (analogue throttle on the L trigger, auto-fire) with **the arcade's lamps on the cabinet's START button**, rapid fire
  in Space Harrier, and the game's RAM cleared before starting. Converted and uploaded, **to be tested on the board:**
  Test Drive 6, Test Drive Le Mans, Wacky Races, Jeremy McGrath Supercross 2000, Star Wars Episode I Racer, Demolition
  Racer, TNN Hardcore Heat, Tokyo Xtreme Racer 2, Metropolis Street Racer (mono audio so that it fits), San Francisco
  Rush 2049 (two versions) and **ArkRetro's OutRun 2006 Coast 2 Coast** demo (v37). Full list:
  [docs/pi60-juegos.md](pi60-juegos.md).
- **MAME4ALL:** **Super Sprint at 60 fps on the board** (T11 CPU statically recompiled). Hang-On and Konami GT still
  slow on the board.
- **naomi-ct-patches:** Jambo! Safari tested on the board; 18 Wheeler and Initial D with a patch verified in an
  interpreter, and a **virtual card reader** for Initial D (image `initiald_exp_reva_ct` on the Raspberry Pi).
- **model1-naomi:** measuring whether the SH-4 can emulate Virtua Racing's V60; nothing playable yet.

#### General to-do list at 2026-11-05

- MAME4ALL on real hardware: Hang-On 47/16 fps and Konami GT 46/13 fps (60 in Flycast), bad sound and hangs (possibly
  with the FPS counter on); perfect controls. To diagnose (see the mame4all-naomi HANDOFF).
- Test Cannonball's new control (START on release, START + R = view).
- **A common control standard** for every game on the cabinet: today START pressed = credit (released, START) in
  MAME4ALL and = menu in Cannonball.
- Daytona recomp: in a race it runs at ~13 fps and drops to 5–8 with many cars (measured with the game's own timer).
  Issue [#62](https://github.com/alphanu1/daytona-arcade-recomp/issues/62) in alphanu1's repository (2026-11-05); the
  author's answer: try the **new native port** (`platform/dreamcast-native`, 60 fps on the Dreamcast).
- **Native Daytona on the NAOMI** (branch `naomi-native`, 2026-11-05): **finished and measured on the board
  (2026-11-11)**: 60 fps in the demo and in a race (drawing 7.7-11.3 ms of the 16.67 available), controls, graphics,
  voices and music correct. Beginner's music needed its own ADPCM copy (the free space in the AICA's RAM is fragmented
  by the announcer's phrases). The image answers the NetDIMM's *peeks*: `naomi/live.py` reads fps and the log over the
  network from the Pi. That night's tweaks: the resident menu's horn (it plays together with the voice), one announcer
  phrase cutting the previous one, music loading 8 times faster (Game Over from 1,186 ms to ~250) and Expert's drawing
  tables enabled using the 32 MB. To do: on the Game Over screen the port does not draw the car in the background (a
  decision of the original project: the car's palette banks are reused for the result captions).
- Jambo! Safari: ✅ **solved with a patch** ([naomi-ct-patches/jambo-safari](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari)):
  the lasso is thrown with the Crazy Taxi's shifter without touching the wiring (crossed variant, tested on the board).
  Next: the rest of the NAOMI / NAOMI 2 / Atomiswave games with the same procedure
  ([naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches)).
- dc2naomi (2026-11-10) — **works on the board.** The black screen after the SEGA logo was the resident's `PCTRA`
  write, which on the NAOMI 2 leaves the TA (the 3D) unresponsive. With it removed, **working on the Crazy Taxi
  cabinet: Crazy Taxi 2, Namco Museum, Yu Suzuki Game Works and Daytona USA 2001**, and Ikaruga on the standard cabinet.
  Per-game controls (wheel, pedals, shifter), emulated memory card (VMU) **saved in one `.vmu` file per game on the
  WiPi's Raspberry Pi**: checked that Daytona gets its save back after loading another game. Windows program
  (`dc2naomi.exe` / `dc2naomict.exe`, v0.2, no release yet). F355 and 18 Wheeler already work on the board (with VMU).
  Parked: KOF99, Last Blade 2. Next: reconvert with VMU the games made without it. All the details in the
  [dc2naomi HANDOFF](https://github.com/0skarzer0/dc2naomi/blob/main/HANDOFF.md).
- **OutRunners** (2026-11-13) — **port started**, from [cheviman/outrunners-port](https://github.com/cheviman/outrunners-port).
  Measured with the owner's ROM: the game logic and the Z80 program fit easily on the SH-4. The video as it is
  (per-pixel MAME-style mixing, ~21 M x86 instructions per frame) does not fit: it has to be drawn with the PowerVR2.
  OutRunners uses little of the chip: TEXT, NBG0 and NBG2 layers, ~56 sprites per frame, no shadows or windows. The FM
  plays no notes, so the sound comes down to the MultiPCM, which will move to the AICA. Study, measurements and phased
  plan: [OutRunners study](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md).
  **Phase 2 on the board** (2026-11-13): PowerVR2 rendering at 60 fps in attract mode and most of a race; sound on the
  AICA (phase 3) done, not yet tested.

#### First week's roadmap (2026-11-04)

Set out at the start; points 1, 5 and 6 are done (Hang-On and Konami GT validated and slow on the board; dc2naomi
works; OutRunners and native Daytona on the board).

1. **Validate on real hardware** Hang-On and Konami GT (MAME4ALL).
2. **Extend MAME4ALL-NAOMI** with the games of 5.1: Super Hang-On, Enduro Racer, Spy Hunter, Max RPM, Turbo, Sprint 2,
   Super Sprint, Arkanoid (spinner mode).
3. **A common libretro-style frontend for the NAOMI** (PVR video, AICA audio, JVS with wheel, pedals, shifter and coin
   mech) to plug in `mame2000`, `mame2003` and `fbalpha2012`.
4. **FBA 2012** for the Sega family (Turbo OutRun, Super Monaco GP) and **mame2003** for Pole Position.
5. **Dreamcast → NAOMI loader** for compilations and ports (Wipeout, Mario Kart 64).
6. **Port OutRunners** ([OutRunners study](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md):
   boot and measurement on the board, PVR2 rendering, sound on the AICA); test the **native Daytona** (branch
   `naomi-native`) on the board and, if it works, offer `NATIVE_NAOMI` to the original project.

# Historial del proyecto

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

# Juegos cargados en la Raspberry del mueble Crazy Taxi (2026-11-13)

> 🇬🇧 **English:** [the English version is at the end of this page ↓](#english)

La Raspberry Pi 3 con **WiPi Netbooter** del mueble está en la red de casa en `192.168.68.60` y llega a la NetDIMM
de la NAOMI 2 por `10.0.0.4`. Cada juego es un `.bin.gz` en `/boot/roms/` más una fila en `/boot/config/romsinfo.csv`
(importada a la web con `/sbin/piforce/importcsv.py`). Los juegos de Dreamcast (`dc2naomi`) llevan además su tarjeta
de memoria en un `.vmu` del mismo nombre (scripts de [dc2naomi/wipi](https://github.com/0skarzer0/dc2naomi/tree/main/wipi)).
Las credenciales de acceso no se guardan en ningún repositorio.

Leyenda: ✅ funciona en la placa · 🧪 subido, sin probar en placa · ⚠️ funciona con problemas conocidos · — sin datos
en este proyecto (es el juego original y no se ha documentado su prueba).
Prefijos del nombre de fichero: `n1-`/`n2-` NAOMI / NAOMI 2 originales, `aw-` Atomiswave convertido, `h-` homebrew o
port propio, `dc-` juego de Dreamcast convertido con dc2naomi (`_dc2naomict` = mandos del mueble Crazy Taxi).

## Originales de NAOMI, NAOMI 2 y Atomiswave

| Fichero | Juego | Estado |
|---|---|---|
| `n1-crazy_taxi-[840-0002]` | Crazy Taxi | ✅ |
| `n1-jambo_safari_ct_cruzado` | Jambo! Safari con parche de palanca | ✅ ([naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari)) |
| `n1-18_wheeler_std-[840-0036]` | 18 Wheeler Standard | ✅ |
| `n1-18wheeler_std_ct` | 18 Wheeler con parche de controles | 🧪 (la BIOS multirregión cuelga este juego) |
| `n1-tokyo_bus_tour-[840-0045]` | Tokyo Bus Guide | — |
| `n1-wave_runner_gp-[840-0064]` | Wave Runner GP | — (manillar analógico: debería ir) |
| `n2-club_kart_european_session-[840-0062]` | Club Kart European Session | ✅ |
| `n2-the_king_of_route66-[840-0087]` | The King of Route 66 | ⚠️ funcionaba, pero el 2026-11-13 el fichero no pasa `pigz -t` (gzip incompleto): hay que volver a copiarlo desde un volcado bueno |
| `n2-wild_riders-[840-0046]` | Wild Riders | ✅ |
| `n2-initial_d_export_rev.a`, `_2_export`, `_3_export` | Initial D Arcade Stage 1, 2 y 3 (Export) | ⚠️ piden lector de tarjetas; la Rev A se cuelga en el attract después de jugar una partida (ver nota de abajo) |
| `n2-initiald_exp_reva_ct` | Initial D Rev A con parche de cambio y CARD R/W apagado por defecto | 🧪 ([naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches/tree/main/initial-d)) |
| `initiald_exp_reva_vcard` (sin fila en el CSV de la web hasta que el usuario la añada) | Initial D Rev A con parche de cambio, **lector de tarjetas virtual** y free play | 🧪 arranca en placa y habla con el juego sin errores (36-56 paquetes, 0 NAK); falta comprobar que da y graba la tarjeta ([card-reader](https://github.com/0skarzer0/naomi-ct-patches/tree/main/card-reader)) |
| `aw-faster_than_speed_AW10` | Faster Than Speed | ✅ |
| `aw-maximum_speed_AW09` | Maximum Speed | ✅ |

## Ports y homebrew

| Fichero | Juego | Estado |
|---|---|---|
| `h-outrun_1986` | Cannonball (OutRun) | ✅ 60 fps |
| `h-Daytona_USA_(MODEL2)` | Daytona USA, port nativo (mismo tamaño que `daytona_native_naomi`, otra compilación) | ✅ 60 fps |
| `h-hangon_mame4all_naomi` | Hang-On (MAME4ALL) | ⚠️ lento en placa |
| `h-konamigt_mame4all_naomi` | Konami GT (MAME4ALL) | ⚠️ lento en placa |
| `h-ssprint_mame4all_naomi` | Super Sprint (MAME4ALL): pantalla completa con bilinear, volante analógico, sonido 11 kHz | ✅ 60 fps |
| `h-jvstest` | Prueba de entradas JVS (calibración de volante y pedales) | ✅ |
| `h-outrunners_naomi` | OutRunners, port nativo ([estudio de OutRunners](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md)): imagen PowerVR2 a ~60 fps; sonido por el AICA aún sin probar (en pruebas) | 🧪 |

## Juegos de Dreamcast convertidos con [dc2naomi](https://github.com/0skarzer0/dc2naomi)

| Fichero | Juego | Estado |
|---|---|---|
| `dc-ct2h8_dc2naomi` | Crazy Taxi 2 | ✅ |
| `dc-nmus7_dc2naomi` | Namco Museum (Pole Position) | ✅ |
| `dc-daytona5_dc2naomi` | Daytona USA 2001 | ✅ |
| `dc-f355b_dc2naomi` | F355 Challenge | ✅ |
| `dc-18wheeler2_dc2naomi` | 18 Wheeler: American Pro Trucker | ✅ |
| `dc-sega_rally2_dc2naomi` | Sega Rally 2 (Windows CE; 30 FPS de serie; sin la música de carrera, que es audio de CD) | ✅ |
| `dc-ysgw7_dc2naomi` | Yu Suzuki Game Works Vol. 1, disco entero | ✅ |
| `dc-outrun_dc2naomict` | OutRun (de Yu Suzuki GW) | ✅ |
| `dc-hangon_dc2naomict` | Hang-On (de Yu Suzuki GW) | ✅ |
| `dc-powerdrift_dc2naomict` | Power Drift (de Yu Suzuki GW): petardeo de la música resuelto | ✅ |
| `dc-afterburner2_dc2naomict` | After Burner II: disparo automático, acelerador = gases, freno = misil, START + acelerador = frenar, START + freno = quitar o poner el disparo automático; luces del arcade en el botón START | ✅ |
| `dc-spaceharrier_dc2naomict` | Space Harrier: disparo rápido (10 por segundo) en el acelerador | ✅ |
| `dc-td6_dc2naomict` | Test Drive 6 | 🧪 |
| `dc-tdlemans_dc2naomict` | Test Drive Le Mans | 🧪 |
| `dc-wackyraces_dc2naomict` | Wacky Races | 🧪 |
| `dc-jmsx2000_dc2naomict` | Jeremy McGrath Supercross 2000 | 🧪 |
| `dc-swracer_dc2naomict` | Star Wars Episode I Racer | 🧪 |
| `dc-demolition_dc2naomict` | Demolition Racer No Exit (vídeos recodificados) | 🧪 |
| `dc-tnnhh_dc2naomict` | TNN Motorsports Hardcore Heat (vídeos recodificados) | 🧪 |
| `dc-txr2_dc2naomict` | Tokyo Xtreme Racer 2 (vídeos recodificados) | 🧪 |
| `dc-msr_dc2naomict` | Metropolis Street Racer (audio a mono) | 🧪 |
| `dc-rush2049_dc2naomict` / `dc-rush2049_9_dc2naomict` | San Francisco Rush 2049: música en mono / 9 canciones intactas | 🧪 |
| `dc-mk64_dc2naomict` (+ `mk64dbg`, diagnóstico) | Mario Kart 64 (port de Dreamcast compilado con KallistiOS parcheada: [receta](https://github.com/0skarzer0/dc2naomi/tree/main/homebrew/mk64)): acelerador = A, freno = B, palanca adelante = salto/derrape, atrás = objeto, volante 2,5 veces más rápido; sin VMU todavía | ✅ (la versión con la palanca cambiada, del 2026-11-13 tarde, está en la carpeta `dc2naomi` del PC: la Pi estaba apagada) |
| `h-or2006_dc2naomi` | OutRun 2006 Coast 2 Coast, demo de ArkRetro v24 | 🧪 |
| `h-or37_dc2naomict` | OutRun 2006 Coast 2 Coast, demo de ArkRetro v37: 4 de sus 28 canciones largas (las demás suenan como una de esas cuatro) | 🧪 |

En `/boot/roms/` hay además dos ficheros sin fila en el CSV (no salen en el menú): `daytona_native_naomi.bin.gz` y
`initiald_exp_reva_vcard.bin.gz`, versiones de prueba (el Daytona nativo, en una compilación distinta de la del menú).

## Free play y attract sin sonido en todas las imágenes (2026-11-13)

Con [`tools/sysdef_all.py`](https://github.com/0skarzer0/naomi-ct-patches/blob/main/tools/sysdef_all.py) se cambiaron en
la cabecera de **49 de las 50 imágenes** los ajustes por defecto de las 8 regiones (free play, attract mudo); la 50
(King of Route 66) está corrupta. Los originales están en `/boot/roms_orig/` de la Pi. La BIOS aplica esos valores solo
al cambiar de juego, y algunos juegos tienen además su propio ajuste de sonido en GAME ASSIGNMENTS. Las imágenes
nuevas hay que pasarlas también por el script.

## Initial D: se cuelga en el attract tras una partida (2026-11-12)

Tras una partida, en el attract (modo de repetición), el juego se cuelga igual con el volcado **original sin parchear**,
con el parche de controles y con el lector virtual, por lo que no es de los parches. Coincide con lo publicado en
arcade-projects sobre la BIOS multirregión antigua en NAOMI 2 (Initial D 3 y Spawn; lo arregla la v2.01, rev C/H). Falta
comprobar la versión de BIOS de la placa (menú de test, SYSTEM INFORMATION). Mismo problema de fondo que 18 Wheeler.

El detalle de cada conversión (parches, tamaños, partidas guardadas, pruebas) está en el
[HANDOFF de dc2naomi](https://github.com/0skarzer0/dc2naomi/blob/main/HANDOFF.md).

---

## English

*Translation of the Spanish text above. If the two ever disagree, the Spanish one is the up-to-date one.*

### Games loaded on the Crazy Taxi cabinet's Raspberry Pi (2026-11-13)

The cabinet's Raspberry Pi 3 with **WiPi Netbooter** is on the home network at `192.168.68.60` and reaches the NAOMI 2's
NetDIMM at `10.0.0.4`. Each game is a `.bin.gz` in `/boot/roms/` plus a row in `/boot/config/romsinfo.csv` (imported
into the web page with `/sbin/piforce/importcsv.py`). Dreamcast games (`dc2naomi`) also carry their memory card in a
`.vmu` of the same name (scripts in [dc2naomi/wipi](https://github.com/0skarzer0/dc2naomi/tree/main/wipi)). Access
credentials are not kept in any repository.

Legend: ✅ works on the board · 🧪 uploaded, untested on the board · ⚠️ works with known problems · — no data in this
project (it is the original game and its test has not been documented).
File name prefixes: `n1-`/`n2-` original NAOMI / NAOMI 2, `aw-` converted Atomiswave, `h-` homebrew or own port, `dc-`
Dreamcast game converted with dc2naomi (`_dc2naomict` = Crazy Taxi cabinet controls).

#### Original NAOMI, NAOMI 2 and Atomiswave games

| File | Game | Status |
|---|---|---|
| `n1-crazy_taxi-[840-0002]` | Crazy Taxi | ✅ |
| `n1-jambo_safari_ct_cruzado` | Jambo! Safari with the shifter patch | ✅ ([naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches/tree/main/jambo-safari)) |
| `n1-18_wheeler_std-[840-0036]` | 18 Wheeler Standard | ✅ |
| `n1-18wheeler_std_ct` | 18 Wheeler with the control patch | 🧪 (the multi-region BIOS hangs this game) |
| `n1-tokyo_bus_tour-[840-0045]` | Tokyo Bus Guide | — |
| `n1-wave_runner_gp-[840-0064]` | Wave Runner GP | — (analogue handlebar: it should work) |
| `n2-club_kart_european_session-[840-0062]` | Club Kart European Session | ✅ |
| `n2-the_king_of_route66-[840-0087]` | The King of Route 66 | ⚠️ it worked, but on 2026-11-13 the file fails `pigz -t` (incomplete gzip): it has to be copied again from a good dump |
| `n2-wild_riders-[840-0046]` | Wild Riders | ✅ |
| `n2-initial_d_export_rev.a`, `_2_export`, `_3_export` | Initial D Arcade Stage 1, 2 and 3 (Export) | ⚠️ they ask for a card reader; Rev A hangs in attract mode after playing a game (see the note below) |
| `n2-initiald_exp_reva_ct` | Initial D Rev A with the shift patch and CARD R/W off by default | 🧪 ([naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches/tree/main/initial-d)) |
| `initiald_exp_reva_vcard` (no row in the web CSV until the user adds it) | Initial D Rev A with the shift patch, **virtual card reader** and free play | 🧪 boots on the board and talks to the game without errors (36-56 packets, 0 NAK); it remains to check that it issues and writes the card ([card-reader](https://github.com/0skarzer0/naomi-ct-patches/tree/main/card-reader)) |
| `aw-faster_than_speed_AW10` | Faster Than Speed | ✅ |
| `aw-maximum_speed_AW09` | Maximum Speed | ✅ |

#### Ports and homebrew

| File | Game | Status |
|---|---|---|
| `h-outrun_1986` | Cannonball (OutRun) | ✅ 60 fps |
| `h-Daytona_USA_(MODEL2)` | Daytona USA, native port (same size as `daytona_native_naomi`, a different build) | ✅ 60 fps |
| `h-hangon_mame4all_naomi` | Hang-On (MAME4ALL) | ⚠️ slow on the board |
| `h-konamigt_mame4all_naomi` | Konami GT (MAME4ALL) | ⚠️ slow on the board |
| `h-ssprint_mame4all_naomi` | Super Sprint (MAME4ALL): full screen with bilinear filtering, analogue wheel, 11 kHz sound | ✅ 60 fps |
| `h-jvstest` | JVS input test (wheel and pedal calibration) | ✅ |
| `h-outrunners_naomi` | OutRunners, native port ([OutRunners study](https://github.com/0skarzer0/outrunners-port/blob/naomi/ports/naomi/docs/study.md)): PowerVR2 picture at ~60 fps; sound through the AICA not yet tested (being tested) | 🧪 |

#### Dreamcast games converted with [dc2naomi](https://github.com/0skarzer0/dc2naomi)

| File | Game | Status |
|---|---|---|
| `dc-ct2h8_dc2naomi` | Crazy Taxi 2 | ✅ |
| `dc-nmus7_dc2naomi` | Namco Museum (Pole Position) | ✅ |
| `dc-daytona5_dc2naomi` | Daytona USA 2001 | ✅ |
| `dc-f355b_dc2naomi` | F355 Challenge | ✅ |
| `dc-18wheeler2_dc2naomi` | 18 Wheeler: American Pro Trucker | ✅ |
| `dc-sega_rally2_dc2naomi` | Sega Rally 2 (Windows CE; 30 FPS by default; without the race music, which is CD audio) | ✅ |
| `dc-ysgw7_dc2naomi` | Yu Suzuki Game Works Vol. 1, whole disc | ✅ |
| `dc-outrun_dc2naomict` | OutRun (from Yu Suzuki GW) | ✅ |
| `dc-hangon_dc2naomict` | Hang-On (from Yu Suzuki GW) | ✅ |
| `dc-powerdrift_dc2naomict` | Power Drift (from Yu Suzuki GW): music crackling fixed | ✅ |
| `dc-afterburner2_dc2naomict` | After Burner II: auto-fire, accelerator = throttle, brake = missile, START + accelerator = slow down, START + brake = auto-fire on or off; the arcade's lamps on the START button | ✅ |
| `dc-spaceharrier_dc2naomict` | Space Harrier: rapid fire (10 per second) on the accelerator | ✅ |
| `dc-td6_dc2naomict` | Test Drive 6 | 🧪 |
| `dc-tdlemans_dc2naomict` | Test Drive Le Mans | 🧪 |
| `dc-wackyraces_dc2naomict` | Wacky Races | 🧪 |
| `dc-jmsx2000_dc2naomict` | Jeremy McGrath Supercross 2000 | 🧪 |
| `dc-swracer_dc2naomict` | Star Wars Episode I Racer | 🧪 |
| `dc-demolition_dc2naomict` | Demolition Racer No Exit (re-encoded videos) | 🧪 |
| `dc-tnnhh_dc2naomict` | TNN Motorsports Hardcore Heat (re-encoded videos) | 🧪 |
| `dc-txr2_dc2naomict` | Tokyo Xtreme Racer 2 (re-encoded videos) | 🧪 |
| `dc-msr_dc2naomict` | Metropolis Street Racer (mono audio) | 🧪 |
| `dc-rush2049_dc2naomict` / `dc-rush2049_9_dc2naomict` | San Francisco Rush 2049: mono music / 9 untouched songs | 🧪 |
| `dc-mk64_dc2naomict` (+ `mk64dbg`, diagnostics) | Mario Kart 64 (Dreamcast port built with a patched KallistiOS: [recipe](https://github.com/0skarzer0/dc2naomi/tree/main/homebrew/mk64)): accelerator = A, brake = B, shifter forward = hop/drift, back = item, wheel 2.5 times faster; no VMU yet | ✅ (the version with the changed shifter, from late 2026-11-13, is in the PC's `dc2naomi` folder: the Pi was off) |
| `h-or2006_dc2naomi` | OutRun 2006 Coast 2 Coast, ArkRetro's demo v24 | 🧪 |
| `h-or37_dc2naomict` | OutRun 2006 Coast 2 Coast, ArkRetro's demo v37: 4 of its 28 long songs (the others play as one of those four) | 🧪 |

`/boot/roms/` also holds two files without a CSV row (not in the menu): `daytona_native_naomi.bin.gz` and
`initiald_exp_reva_vcard.bin.gz`, test versions (native Daytona, in a build different from the menu's).

#### Free play and silent attract in every image (2026-11-13)

With [`tools/sysdef_all.py`](https://github.com/0skarzer0/naomi-ct-patches/blob/main/tools/sysdef_all.py) the default
settings of the 8 regions (free play, silent attract) were changed in the header of **49 of the 50 images**; the 50th
(King of Route 66) is corrupt. The originals are in `/boot/roms_orig/` on the Pi. The BIOS only applies those values
when the game changes, and some games also have their own sound setting in GAME ASSIGNMENTS. New images have to go
through the script too.

#### Initial D: hangs in attract mode after a game (2026-11-12)

After a game, in attract mode (replay), the game hangs the same way with the **original unpatched** dump, with the
control patch and with the virtual reader, so it is not the patches. It matches what was published on arcade-projects
about the old multi-region BIOS on the NAOMI 2 (Initial D 3 and Spawn; v2.01, rev C/H, fixes it). The board's BIOS
version is still to be checked (test menu, SYSTEM INFORMATION). Same underlying problem as 18 Wheeler.

The details of each conversion (patches, sizes, saves, tests) are in the
[dc2naomi HANDOFF](https://github.com/0skarzer0/dc2naomi/blob/main/HANDOFF.md).

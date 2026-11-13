# Naomi Wheel Games — juegos de volante, moto y spinner para un mueble Crazy Taxi (NAOMI + NetDIMM)

Objetivo: reunir **el máximo número de juegos de coches, motos y spinner** que se puedan arrancar por
**netboot (NetDIMM)** en un mueble **Crazy Taxi NAOMI** con sus controles originales, y documentarlo
todo para que otros usuarios (y otras IAs) puedan reutilizar el trabajo.

> **Política de ROMs:** este repositorio **no contiene ROMs** ni binarios que las incluyan.
> Solo hay código, herramientas, parches y documentación. Cada usuario genera sus `.bin`
> a partir de sus propios volcados.

*In English:* racing, bike and spinner games for a SEGA Crazy Taxi upright (NAOMI 2, 512 MB NetDIMM, netbooted from
a Raspberry Pi): native ports (Daytona USA, Cannonball/OutRun, OutRunners), MAME4ALL, a loader that runs Dreamcast
games on the NAOMI with the cabinet's wheel (dc2naomi), and control patches for NAOMI games. No ROMs here: every
tool builds images from the user's own dumps. The documents are in Spanish; the code comments, in English.

---

## Repositorios del proyecto

| Repositorio | Qué es | Traspaso |
|---|---|---|
| [mame4all-naomi](https://github.com/0skarzer0/mame4all-naomi) | MAME4ALL (MAME 0.35) para NAOMI: Hang-On, Konami GT… | [HANDOFF.md](https://github.com/0skarzer0/mame4all-naomi/blob/naomi/HANDOFF.md) |
| [dreamcast-cannonball](https://github.com/0skarzer0/dreamcast-cannonball/tree/naomi) (rama `naomi`) | Cannonball (OutRun) para NAOMI | [naomi/HANDOFF.md](https://github.com/0skarzer0/dreamcast-cannonball/blob/naomi/naomi/HANDOFF.md) |
| [daytona-arcade-recomp](https://github.com/0skarzer0/daytona-arcade-recomp/tree/naomi) (rama `naomi`) | Recompilación de Daytona USA (Model 2) para NAOMI | [platform/dreamcast/HANDOFF.md](https://github.com/0skarzer0/daytona-arcade-recomp/blob/naomi/platform/dreamcast/HANDOFF.md) |
| [daytona-arcade-recomp](https://github.com/0skarzer0/daytona-arcade-recomp/tree/naomi-native) (rama `naomi-native`) | **Port nativo** de Daytona USA (reescrito en C para SH-4, PR #58 del original) para NAOMI | [platform/dreamcast-native/naomi/HANDOFF.md](https://github.com/0skarzer0/daytona-arcade-recomp/blob/naomi-native/platform/dreamcast-native/naomi/HANDOFF.md) |
| [dc2naomi](https://github.com/0skarzer0/dc2naomi) | Cargador de juegos de Dreamcast en NAOMI (experimental) | [HANDOFF.md](https://github.com/0skarzer0/dc2naomi/blob/main/HANDOFF.md) |
| [naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches) | Parches de controles (IPS) para juegos NAOMI / NAOMI 2 / Atomiswave en el mueble Crazy Taxi, y lector de tarjetas virtual (Initial D) | [HANDOFF.md](https://github.com/0skarzer0/naomi-ct-patches/blob/main/HANDOFF.md) |
| [model1-naomi](https://github.com/0skarzer0/model1-naomi) | Virtua Racing (Sega Model 1) en NAOMI: estudio de viabilidad | [HANDOFF.md](https://github.com/0skarzer0/model1-naomi/blob/main/HANDOFF.md) |
| Este repositorio, [`outrunners/`](outrunners/) | **OutRunners** para NAOMI: parche sobre [cheviman/outrunners-port](https://github.com/cheviman/outrunners-port), herramientas y estudio | [outrunners/HANDOFF.md](outrunners/HANDOFF.md) |


### Cómo retomar el trabajo en un chat nuevo (personas o IAs)

1. Lee este README para la visión general.
2. Lee el `HANDOFF.md` del repositorio en el que vas a trabajar: estado, arquitectura, direcciones,
   cómo compilar y siguientes pasos.
3. Al terminar la sesión, actualiza ese `HANDOFF.md` y, si cambia el estado de algún juego,
   [docs/pi60-juegos.md](docs/pi60-juegos.md) y el apartado "Estado" de aquí. Lo que deje de ser actual pasa a
   [docs/historial.md](docs/historial.md), con su fecha.

## Estado (2026-11-13)

Qué está cargado en la Raspberry del mueble y qué está probado en placa, juego a juego: **[docs/pi60-juegos.md](docs/pi60-juegos.md)**.

- **Funcionan en placa:** los juegos originales de NAOMI / NAOMI 2 / Atomiswave del mueble; **Daytona USA nativo**
  y **Cannonball (OutRun)** a 60 fps; **Super Sprint** (MAME4ALL) a 60 fps; y con **dc2naomi**, Crazy Taxi 2, Namco
  Museum (Pole Position), Daytona USA 2001, F355 Challenge, 18 Wheeler, Sega Rally 2 y los cinco juegos de Yu Suzuki
  Game Works, todos con su VMU guardada en la Raspberry.
- **En curso:** **OutRunners** (port nativo): imagen por la PowerVR2 a 60 fps en placa; sombras, fundidos exactos,
  sonido en el AICA y un conversor para Windows hechos y sin probar en placa ([outrunners/HANDOFF.md](outrunners/HANDOFF.md)).
- **Subidos, sin probar en placa:** una docena de juegos de Dreamcast convertidos con dc2naomi (Test Drive 6, Star
  Wars Racer, Metropolis Street Racer, SF Rush 2049, Mario Kart 64, la demo de OutRun 2006 de ArkRetro…) y los
  parches de 18 Wheeler e Initial D (con lector de tarjetas virtual).
- **Lentos en placa:** Hang-On y Konami GT (MAME4ALL), ~46 fps y cuelgues.
- **Estudio:** model1-naomi (¿puede el SH-4 emular el V60 de Virtua Racing?), nada jugable todavía.

## Siguientes pasos

1. **OutRunners:** probar en placa la imagen con sonido, sombras y fundidos; luego el conversor para Windows.
2. **Probar en placa** los juegos de Dreamcast convertidos que faltan y los parches de 18 Wheeler e Initial D.
3. **Estándar de controles común** para todos los juegos del mueble (moneda, START, vista, menú): hoy cada port lo
   resuelve a su manera (OutRunners: START = moneda; MAME4ALL: freno + START = crédito; Cannonball: freno + START = menú).
4. **MAME4ALL:** Hang-On y Konami GT lentos en placa; añadir los drivers fáciles de [docs/juegos.md](docs/juegos.md)
   (Super Hang-On, Enduro Racer, Spy Hunter, Turbo, Arkanoid…).
5. **Más allá:** un frontend común tipo libretro para NAOMI (mame2000, mame2003, fbalpha2012) para los juegos de
   [docs/investigacion.md](docs/investigacion.md).

## Documentación

| Documento | Qué hay |
|---|---|
| [docs/pi60-juegos.md](docs/pi60-juegos.md) | Juego a juego, qué hay en la Raspberry del mueble y su estado en placa |
| [docs/juegos.md](docs/juegos.md) | Catálogo por niveles de dificultad: nativos de NAOMI, ports propios, recopilatorios de Dreamcast, parches |
| [docs/hardware.md](docs/hardware.md) | El mueble: placa, carga, valores JVS de volante y pedales, trampas del hardware real |
| [docs/investigacion.md](docs/investigacion.md) | Versiones de MAME/FBA candidatas, arquitectura del port MAME4ALL, decompilaciones y recompilaciones |
| [docs/outrunners.md](docs/outrunners.md) | Estudio y medidas del port de OutRunners |
| [docs/crazy-taxi-dreamcast-vs-naomi.md](docs/crazy-taxi-dreamcast-vs-naomi.md) | Qué cambió SEGA entre el Crazy Taxi de Dreamcast y el de NAOMI |
| [docs/historial.md](docs/historial.md) | Estados y pendientes antiguos, con su fecha |

## Contenido del repositorio

```
naomi-wheel-games/
├── README.md        ← este documento
├── docs/            ← la documentación de arriba
└── outrunners/      ← el port de OutRunners: parche, toolchain, herramientas de la Pi, HANDOFF
```

El código de los demás proyectos está en sus repositorios (tabla de arriba).

## Hardware de referencia

| Elemento | Detalle |
|---|---|
| Placa | NAOMI 2 con multibios (también vale NAOMI 1 para casi todo) |
| Carga | NetDIMM 512 MB, netboot desde Raspberry Pi 3 con **WiPi Netbooter** (`.bin.gz` + línea en `romsinfo.csv`) |
| Monitor | 31 kHz (VGA 640x480) |
| Controles | Volante analógico (~270°), acelerador, freno, palanca de 2 posiciones con retorno (adelante/atrás), START, monedero |

Detalle, valores medidos y consecuencias para cada tipo de juego: [docs/hardware.md](docs/hardware.md).

---

## Aviso legal

- No se distribuyen ROMs, BIOS ni binarios que las contengan.
- Las marcas pertenecen a sus propietarios (Sega, Konami, Atari, Namco, Midway, Taito…). OutRunners es una
  marca de SEGA; ningún proyecto de aquí está afiliado a SEGA ni respaldado por ella.
- Los proyectos de terceros (decompilaciones, Cannonball, MAME, FBA) mantienen sus licencias;
  MAME 0.35/0.37/0.78 y FBA antiguo tienen **licencias no comerciales**.

---

## Agradecimientos

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
- **Los autores de los proyectos de [investigacion.md](docs/investigacion.md)** que sirven de referencia o futura base: cheviman (OutRunners port y su descompilación; Aaron Giles, por ymfm, en el que se basa su YM3438),
  wanszai (Scud Race, Ridge Racer Collection, Sega Rally), namco22-decompile, la decompilación de Ridge Racer (PSX), el
  port de Wipeout a Dreamcast, mk64-dc, Wave Race 64 DC y la decompilación de Sonic R.
- **Claude** (Anthropic), a través de Claude Code: el código y la documentación de los ports de este proyecto se han
  escrito y depurado con Claude en sesiones con el propietario del mueble, que es quien prueba cada imagen en la placa
  y aporta las fotos y las mediciones de las que sale cada diagnóstico.

Los nombres que aparecen aquí se conocen por los repositorios y las páginas citadas; las licencias de cada proyecto
siguen siendo las suyas (Aviso legal).

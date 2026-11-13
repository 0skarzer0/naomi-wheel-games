# OutRunners en NAOMI — traspaso para otra sesión

Última actualización: 2026-11-13. Estudio y medidas: [../docs/outrunners.md](../docs/outrunners.md). Detalle técnico
del port: `ports/naomi/README.md` dentro del parche.

## Dónde está cada cosa

| Qué | Dónde |
|---|---|
| Código del port | [`naomi-port.patch`](naomi-port.patch): `git am` sobre [cheviman/outrunners-port](https://github.com/cheviman/outrunners-port) `12af5afe` (con `git submodule update --init --depth 1`). Todavía no hay fork en la cuenta 0skarzer0. Si se crea `0skarzer0/outrunners-port`, subir los commits del parche como rama `naomi` |
| Toolchain | [`build_toolchain.sh`](build_toolchain.sh): sh-elf GCC 15.2.0 + KOS `368a2eb9` en `/opt/toolchains/dc/kos` (Dreamcast) y `/opt/toolchains/dc/kos-naomi` (`KOS_SUBARCH=naomi`, con `naomibintool`). ~35 min con 2 núcleos |
| Estudio de vídeo en PC | `census.patch`, `race_arcade.txt`, `analyze_census.py` ([README.md](README.md)) |
| Herramientas de la Pi | [`pi/`](pi/): `pi_env.sh`, `dimm_wait.sh`, `send_and_log.sh`, `install_pi_tools.sh`, `or_info.py`; más `live.py`, `watch.py` y `profile.py` de `ports/naomi/` |
| ROM | `orunners.zip` (set de MAME) del usuario: **pedírselo**; nunca subir nada derivado de él |

## Cómo reconstruir el entorno desde cero (workspace de Claude)

```sh
bash naomi-wheel-games/outrunners/build_toolchain.sh          # una vez, ~35 min
git clone https://github.com/cheviman/outrunners-port && cd outrunners-port
git checkout 12af5afe && git submodule update --init --depth 1
git am ../naomi-wheel-games/outrunners/naomi-port.patch
ports/naomi/build_naomi.sh /ruta/orunners.zip build/naomi     # imagen: build/naomi/orunners_naomi.bin.gz
```

Para recompilar solo el programa: `source /opt/toolchains/dc/kos-naomi/environ.sh; make -C ports/naomi clean all`.
**Haz siempre `clean`**: el Makefile no sigue las dependencias de las cabeceras, y un `.o` viejo con otra versión de
`naomi.h` mueve el bloque de datos en vivo. Después, `naomibintool` + `naomi_pack.py` + `gzip`, como al final de
`build_naomi.sh`. Pruebas por etapas: `make EXTRA=-DORUNNERS_NAOMI_STAGE=N` (0: KOS y peeks; 1: assets leídos;
2: todo listo, espera un poke en `naomi_stop_at`).

## Cómo probar en el mueble (Crazy Taxi, NAOMI 2)

- La placa está en la Pi `192.168.68.60` (WiPi), usuario `root`; **la contraseña se le pide al usuario**. La NetDIMM se
  ve desde la Pi como `10.0.0.4`.
- Desde el workspace no se llega a su red: se entra con `device_bash` en su ordenador, que necesita una carpeta
  conectada (la usada fue `C:\Users\Usuario\Documents\dc2naomi`; en `outrunners\` están las imágenes que se envían).
  Para pasar la imagen del workspace a su ordenador: `device_commit_files` desde `/mnt/user-data/outputs/`.
  **Cada vez con un nombre de fichero nuevo**: con el mismo nombre puede llegar una versión anterior. Comprobar el
  md5 en su ordenador.
- En la Pi: `export PI_PASS=...; outrunners/pi/install_pi_tools.sh ports/naomi` (una vez). Después,
  `outrunners/pi/send_and_log.sh imagen.bin.gz 0x8c...` copia, envía (`dc2naomi_send.py`), espera y muestra la
  consola. La dirección del bloque en vivo sale de `sh-elf-nm orunners_naomi.elf | grep orunners_naomi_live`.
- En la Pi (`/sbin/piforce/`): `outrunners_live.py 10.0.0.4 ADDR fps 10`, `... draw N`, `... log`;
  `or_watch.py ADDR [POKE_ADDR VALOR]`; `or_profile.py ADDR` (pcs muestreados, para `sh-elf-addr2line -f`).
- El menú del WiPi ya tiene la fila "OutRunners (prueba)" para `h-outrunners_naomi.bin.gz`.

**Trampas** (cada una costó un buen rato):
1. Un peek sin respuesta deja la NetDIMM ocupada hasta ~1 min y los envíos siguientes fallan (`send rc=124`).
   Antes de enviar, `dimm_wait.sh`. No matar peeks a medias.
2. `pkill -f PATRÓN` por ssh con un patrón que también aparece en la propia línea de órdenes mata la shell remota
   (`exit 255`).
3. Mientras el programa lee los assets (~7,5 s), los peeks no se atienden: el bucle de lectura retoma el candado
   de la NetDIMM antes de que el hilo de los peeks lo consiga. Leer la consola a partir de ~25 s del envío.
4. Una excepción no tratada queda en la consola y el programa sigue respondiendo peeks (versión del bloque en vivo
   `0xdeadXXXX`). Si no responde nada, el programa no llegó a `naomi_dimmcomms_start` o la CPU está colgada.
5. `timehack.py` del WiPi corre en la Pi; no molestó.

## Estado (2026-11-13, 14:20)

**Fase 2 en marcha y funcionando en la placa:** la imagen sale por la PowerVR2 (el usuario: "se ve
estupendamente"). Medido con `race.py` (carrera sin nadie en el mueble):
- attract y casi toda la carrera a **60 fps** (juego ~8 ms, sonido ~1 ms, escena ~4–5 ms, envío ~1,2 ms);
- bajones puntuales en tramos con paleta animada (muchas texturas reconvertidas a la vez): mejorados con tablas de
  colores por celda y el bitmap redibujado solo en las filas visibles; **falta medir esa versión en la placa**
  (imagen `or_141552`, sin enviar: se cortó el enlace con el ordenador del usuario).
- Sin sonido: la síntesis MultiPCM está apagada (`ORUNNERS_NO_PCM_SYNTHESIS`) hasta la fase 3 (AICA). Con ella, en
  carrera se comía ~16 ms por fotograma (generaba silencio: no hay samples en RAM).

Arreglos de esta fase que conviene recordar:
- **Accesos desalineados:** el código del V60 lee palabras en direcciones impares (scenery.c, `palette_cycle`); el
  SH-4 da error de dirección. `naomi_log.c` los emula byte a byte, también en el hueco de retardo de un salto
  (contador `misaligned` en el bloque en vivo, +0x78; ~100 en una carrera).
- **No `vid_waitvbl`** con la PVR: `pvr_wait_ready` ya sincroniza con el vblank; con los dos iba a 30 fps.
- **`memcmp` de newlib es byte a byte** en SH-4: `same()` compara por palabras (de 9 a 4 ms la escena).
- Quads ordenados por textura y enviados con *direct rendering*: el envío de ~500 quads, de 3,5 a 1,2 ms.

Bloque en vivo de la imagen actual: `0x8c0c5548` (cambia con cada compilación: `sh-elf-nm`).

## Fase 2 — render PowerVR2

Código: `runtime/src/video_scene.c` (escena de quads, portable, incluida por `video.c` con `ORUNNERS_VIDEO_SCENE`),
`runtime/src/video_scene_soft.c` (rasterizador de PC para comparar) y `ports/naomi/pvr_video.c` (texturas ARGB1555
no twiddled en VRAM, polígonos punch-through, profundidad = prioridad del mezclador).

Comparar con `video.c` en el PC (mismo fotograma, mismo estado):
```sh
cmake -B build-scene -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-DORUNNERS_VIDEO_SCENE && make -C build-scene orunners_game_headless
ORUNNERS_SCENE_COMPARE=/tmp/scene build/bin/orunners_game_headless --script race_arcade.txt --hashes /dev/null \
    --video-hashes /dev/null --screens 1 --assets orunners.assets
# una línea cada 30 fotogramas: píxeles distintos; /tmp/scene/scene_N.ppm (original | escena) cada 600;
# ORUNNERS_SCENE_DUMP=N, ORUNNERS_SCENE_QUADS=N para un fotograma concreto (y sus imágenes)
```
Resultado (2026-11-13): la mayoría de fotogramas con <1 % de píxeles distintos (bordes de sprites escalados).
Los fundidos son aproximados (la PVR multiplica; la placa resta): se ven algo más grises.

Pendiente de la fase 2:
1. Medir en placa la versión con tablas de color y mirar los bajones restantes (`or_profile.py` en carrera:
   dejar el gas puesto con un poke de `test_inputs` y perfilar en segundo plano, `nohup`).
2. Blending de TEXT sobre sprites (el panel translúcido de la selección; `missing` 0x10).
3. Fundidos más fieles (quizá una pasada translúcida).
4. Recortes "outside" de la lista de sprites y ventanas de tilemaps (OutRunners no los usa en lo visto).

Herramienta nueva en la Pi: `race.py` (de `ports/naomi/`, copiado como `/sbin/piforce/or_race.py`):
`python3 or_race.py ADDR 100` echa moneda, pulsa START, acelera y gira; imprime fps y tiempos.




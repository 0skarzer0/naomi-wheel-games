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

## Estado (2026-11-13)

Fase 1 en la placa: lógica ~8 ms y sonido ~2,9 ms por fotograma; `video.c` por software ~360 ms. Imagen actual en la
Pi: bloque en vivo `0x8c0beaf0`, dibuja 1 de cada 30 (se puede cambiar con `draw`).

## Fase 2 — render PowerVR2 (lo siguiente)

Objetivo: sustituir `s32_video_draw_frame()` + `show_frame()` por un render PVR, con `video.c` aún disponible para
comparar. Lo que usa OutRunners, del censo de [../docs/outrunners.md](../docs/outrunners.md) §2.2:
- Capas TEXT, NBG0 (scroll; zoom solo en unos 30 fotogramas de transición), NBG2 (scroll por línea y selección de
  fila) y BITMAP (no llega a pantalla). NBG1 y NBG3 no se usan. Sin ventanas de recorte ni sombras.
- ~56 sprites por fotograma (máximo 115), ~55 % escalados, algunos de 8 bpp o con tabla indirecta; recortes de la
  lista de sprites (4 de media).
- Prioridades del mezclador por capa y grupo de sprite; fundidos por offsets iguales en R, G y B; blending de TEXT
  sobre sprites, que casi no tiene píxeles.
- Paleta de 16.384 colores (82 bancos de 16 como máximo por fotograma): texturas de color directo ARGB1555
  convertidas desde la paleta, con caché.

Orden propuesto:
1. Esqueleto PVR en `ports/naomi/pvr_video.c`: `pvr_init`, una lista translúcida/punch-through, 320×224 escalado a
   640×448. Dibujar NBG0 como página de tilemap en textura (512×256 ARGB1555), regenerando solo los tiles que
   cambian.
2. NBG2 con una tira por línea (row scroll y row select de su tabla), TEXT encima.
3. Sprites como quads desde una caché LRU de texturas (clave: dirección, tamaño, bpp, color o tabla, versión de la
   paleta) y recortes en CPU.
4. Orden Z según los registros de prioridad del mezclador; fundidos con un quad negro translúcido.
5. Comparar con `video.c` en PC: la misma lógica de "qué dibujar" en una versión de PC que genere quads y los
   rasterice, para validar sin la placa.

Lo que hay que leer de `runtime/src/video.c`: `draw_layers` y los `*_pixel` (cómo se direcciona cada tilemap),
`draw_sprite_list` / `draw_sprite` (formato de la lista), `mix_rows` (prioridades), `palette_color`.

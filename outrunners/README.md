# Herramientas del estudio de OutRunners

Ver [../docs/outrunners.md](../docs/outrunners.md). **Para continuar el trabajo: [HANDOFF.md](HANDOFF.md).**

| Fichero | Para qué |
|---|---|
| `census.patch` | Censo de vídeo para `runtime/src/video.c` de [cheviman/outrunners-port](https://github.com/cheviman/outrunners-port) (commit `12af5afe`): con `ORUNNERS_CENSUS=fichero`, una línea por fotograma con los registros de vídeo y mezclador, los sprites y los bancos de paleta visibles |
| `race_arcade.txt` | Guion de controles para `orunners_game_headless`: moneda, START, gas y volante; llega a la carrera hacia el fotograma 1700 |
| `analyze_census.py` | Resume el censo |
| `naomi-port.patch` | El port a NAOMI (fase 1) para `git am` sobre cheviman/outrunners-port `12af5afe`, hasta que exista el fork |
| `pi/` | Envío a la placa y lectura de la consola por la Pi del mueble (`HANDOFF.md`) |
| `build_toolchain.sh` | sh-elf + KOS (normal y NAOMI) sin acceso a los mirrors de GNU |

Receta:

```sh
git clone https://github.com/cheviman/outrunners-port && cd outrunners-port
git submodule update --init --depth 1
git apply /ruta/naomi-wheel-games/outrunners/census.patch
mkdir rom && cp /ruta/orunners.zip rom/
cmake -B build -DCMAKE_BUILD_TYPE=Release -DORUNNERS_ROM=$PWD/rom/orunners.zip
make -C build -j2 orunners_game_headless orunners_assets
ORUNNERS_CENSUS=/tmp/census.txt build/bin/orunners_game_headless --script /ruta/race_arcade.txt \
    --hashes /dev/null --video-hashes /dev/null --screens 1
python3 /ruta/naomi-wheel-games/outrunners/analyze_census.py /tmp/census.txt 1700
```

Coste por partes (lo de la tabla 2.1): dos ejecuciones con `valgrind --tool=callgrind` cuyo guion termina en los
fotogramas 2900 y 3500 (línea `N end`), y restar la columna exclusiva de `callgrind_annotate`.

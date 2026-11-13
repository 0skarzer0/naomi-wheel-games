#!/usr/bin/env python3
"""Resume el censo de vídeo de OutRunners (census.patch) para diseñar el render PVR2 de la NAOMI.

Uso: python3 analyze_census.py census.txt [primer_fotograma_de_carrera]

census.txt lo escribe orunners_game_headless (con census.patch aplicado) cuando ORUNNERS_CENSUS=fichero:
una línea por fotograma con registros del chip de vídeo y del mezclador, contadores de sprites y bancos
de paleta de 16 colores que llegan a la pantalla, y una línea "S ..." por sprite dibujado.
"""
import collections
import statistics
import sys

LAYERS = "TEXT NBG0 NBG1 NBG2 NBG3 BITMAP SPRITES BACKDROP".split()


def main():
    path = sys.argv[1]
    race_from = int(sys.argv[2]) if len(sys.argv) > 2 else 1700
    frames, sprites, current = [], [], []
    for line in open(path):
        if line.startswith("S "):
            current.append(tuple(line.split()[1:]))
        else:
            frames.append(dict(kv.split("=", 1) for kv in line.split()))
            sprites.append(current)
            current = []

    print(f"fotogramas: {len(frames)} (carrera desde el {race_from})")
    for key in ["drawn", "ctl00", "off02", "line04", "z0", "z1", "mix4e", "mix4c", "bl", "off", "extra"]:
        print(f"  {key}: {collections.Counter(f[key] for f in frames).most_common(6)}")

    race = frames[race_from:]
    for key in ["spr", "zoom", "shadow", "ind", "b8", "ram", "clip", "area"]:
        values = [int(f[key]) for f in race]
        print(f"  {key}: media {statistics.mean(values):.0f}, máximo {max(values)}")

    if "ubanks" in frames[0]:
        values = [int(f["ubanks"]) for f in frames]
        print(f"bancos de paleta visibles por fotograma: media {statistics.mean(values):.0f}, "
              f"máximo {max(values)}, distintos en toda la partida {frames[-1]['everbanks']}")
        for index, name in enumerate(LAYERS):
            per = [int(f["banks"].split(",")[index]) for f in frames]
            print(f"  {name}: media {statistics.mean(per):.1f}, máximo {max(per)}")

    cache, new_images, new_texels = set(), [], []
    for frame in sprites:
        count = texels = 0
        for key in set(frame):
            if key not in cache:
                cache.add(key)
                count += 1
                texels += int(key[1]) * (4 if key[3] == "1" else 8) * int(key[2])
        new_images.append(count)
        new_texels.append(texels)
    if cache:
        total = sum(int(k[1]) * (4 if k[3] == "1" else 8) * int(k[2]) for k in cache)
        tail = sorted(new_texels[race_from:])
        print(f"imágenes de sprite distintas: {len(cache)}, {total * 2 / 2**20:.1f} MB a 16 bits")
        print(f"texels nuevos por fotograma en carrera: media {statistics.mean(tail):.0f}, "
              f"p95 {tail[int(len(tail) * .95)]}, p99 {tail[int(len(tail) * .99)]}, máximo {tail[-1]}")


if __name__ == "__main__":
    main()

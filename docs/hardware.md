# Hardware del mueble Crazy Taxi (referencia para todos los proyectos)

Valores medidos en el mueble real. Úsalos en cualquier port o parche para que los controles
respondan igual en todos los juegos.

## Placa y carga

| Elemento | Detalle |
|---|---|
| Placa | NAOMI 2 con multibios (BIOS de exportación EPR-23608B; no se sube al repositorio). **Versión de la multibios sin confirmar**: las antiguas cuelgan 18 Wheeler e Initial D en el attract (ver [pi60-juegos.md](pi60-juegos.md)); la v2.01 (rev C/H) corrige al menos algunos cuelgues |
| Memoria de juego | NetDIMM 512 MB |
| Carga | Netboot desde Raspberry Pi 3 con WiPi Netbooter: ficheros `.bin.gz` + una línea en `romsinfo.csv` |
| Monitor | 31 kHz (640x480), no trifrecuencia |

## Controles (JVS, leídos con el driver MIE de KallistiOS)

| Control | Lectura JVS | Valores medidos (2026-11-02) |
|---|---|---|
| Volante | Analógico 0 | izquierda **8448** · centro **33792** · derecha **60160** |
| Acelerador | Analógico 1 | suelto **11776** · a fondo **47104** |
| Freno | Analógico 2 | suelto **14080** · a fondo **47360** |
| Palanca de cambios | Jugador 1 arriba / abajo | 2 posiciones con muelle (vuelve al centro): adelante = arriba, atrás = abajo |
| START | Jugador 1 START | Botón con luz (salida JVS) |
| Monedero | Contador de monedas 1 | Leer por **diferencia de contadores** (`coin[i].count`); el pulso de moneda del driver llega ya borrado |
| TEST / SERVICE | Panel de servicio | |

Notas:
- Margen recomendado en pedales: ~6 % en cada extremo; ampliar la calibración en caliente si un control
  pasa de los valores medidos.
- Programa de prueba y calibración: `naomi/jvstest/` en
  [dreamcast-cannonball (rama naomi)](https://github.com/0skarzer0/dreamcast-cannonball/tree/naomi/naomi/jvstest).
- Implementaciones que usan estos valores: `src/main/sdl2/input.cpp` (`poll_naomi`) en Cannonball y
  `src/naomi/naomi_input.cpp` en mame4all-naomi.

## Combinaciones de botones en uso

| Proyecto | Freno + START | Otras |
|---|---|---|
| mame4all-naomi | — (START pulsado = crédito, al soltar = START) | START 3 s = contador de FPS |
| Cannonball | Menú principal | START mantenido + palanca atrás = cambiar vista; START actúa al soltarlo |

Pendiente: decidir un estándar común.

## Ajustes por defecto de los juegos (free play, attract mudo)

La cabecera NAOMI de cada imagen lleva, de `0x1E0` a `0x25F`, los valores por defecto del menú de sistema (16 bytes por
región): `+0` = 1 aplica, `+1` bit 1 = attract sin sonido, `+3` = 27 es FREE PLAY. La BIOS los aplica solo cuando inicializa
los ajustes de un juego distinto del anterior. Herramienta: `tools/system_defaults.py` (una imagen) y
`tools/sysdef_all.py` (todas las de la Pi) en [naomi-ct-patches](https://github.com/0skarzer0/naomi-ct-patches).

## Lector de tarjetas

Los juegos que guardan en tarjeta magnética (Initial D) usan un lector Sanwa CRP-1231BR-10 en el puerto serie CN8. En
vez de cable y adaptador, [naomi-ct-patches/card-reader](https://github.com/0skarzer0/naomi-ct-patches/tree/main/card-reader)
añade a la imagen un lector virtual en software; la tarjeta es un fichero en la Pi. Con el parche de controles, en
Initial D un toque corto de START hace de «vista» (el SÍ de comprar tarjeta) y mantenerlo pulsado es START (el NO).

## Trampas del hardware real (no las reproduce Flycast)

- La VRAM **no admite escrituras de byte**: usar escrituras de 16/32 bits o store queues.
- La DMA del PVR se cuelga en NAOMI.
- Los núcleos de CPU emulados (FAMEC, RAZE, Musashi, T11, 6502) van **2–5 veces más lentos** que en Flycast:
  medir siempre en la placa.

## Consecuencias para los juegos

- **Volante absoluto** → perfecto para juegos con volante/potenciómetro. Para spinner/dial (rotación
  infinita) hay que convertir la posición del volante en velocidad de giro.
- **Palanca de 2 posiciones con retorno** → se usa como cambio LOW/HIGH con enclavamiento por software
  (adelante = HIGH, atrás = LOW). Juegos con H de 4/6 velocidades quedan peor.
- **Solo un jugador** con controles de coche; un segundo jugador no tiene mandos.

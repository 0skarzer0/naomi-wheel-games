# Hardware del mueble Crazy Taxi (referencia para todos los proyectos)

Valores medidos en el mueble real. Úsalos en cualquier port o parche para que los controles
respondan igual en todos los juegos.

## Placa y carga

| Elemento | Detalle |
|---|---|
| Placa | NAOMI 2 con multibios (BIOS de exportación EPR-23608B; no se sube al repositorio) |
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
| mame4all-naomi | Meter un crédito | START 3 s = contador de FPS |
| Cannonball | Menú principal | START mantenido + palanca atrás = cambiar vista; START actúa al soltarlo |

Pendiente: decidir un estándar común.

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

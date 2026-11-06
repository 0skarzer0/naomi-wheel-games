# Crazy Taxi: Dreamcast frente a NAOMI — qué cambió SEGA

Comparación del mismo juego compilado por SEGA (Hitmaker) para las dos máquinas, para saber qué necesita un juego
de Dreamcast para funcionar en NAOMI (y al revés). Aquí sólo se publican los hallazgos, nunca los datos del juego.

| Versión | Programa | Dirección | Librerías |
|---|---|---|---|
| Crazy Taxi (USA), GD-ROM de Dreamcast | `1ST_READ.BIN`, 1,47 MB | `0x8c010000` | Shinobi 1.62zr, Kamui, ADX (CRI) |
| Crazy Taxi 2 (USA), GD-ROM de Dreamcast | `1ST_READ.BIN`, 1,45 MB | `0x8c010000` | Shinobi 1.76, Kamui, ADX, libsnd |
| Crazy Taxi (840-0002), cartucho NAOMI | ROM `0x000000-0x2e0000` | `0x8c020000`, entrada `0x8c021000` | libam 1.22 ("NAOMI LIBRARY FOR AM"), Mioz 1.10 ("NAOMI ARCADE CONTROLLER": JVS, EEPROM, INTR), Kamui |

Cabecera del cartucho NAOMI: lista de carga del programa en `0x360` (`rom 0x0 → 0x0c020000, 0x2e0000 bytes`),
modo test en `0x3c0` (`rom 0x300000 → 0x0c020000, 0x100000`), puntos de entrada en `0x420` (`0x0c021000` juego,
`0x0c020000` test).

## Lo que es igual

* **El código gráfico (Kamui) es el mismo**, byte a byte salvo direcciones. Las dos versiones:
  * ponen `SB_LMMODE0` (`0xa05f6884`) a **0** en la misma rutina (DC `0x8c15317c`, NAOMI `0x8c0892fc`);
  * suben las texturas por **DMA canal 2 a `0x11000000 | desplazamiento en VRAM`** (DC `0x8c157962`, NAOMI
    `0x8c08ae7a`).

  O sea, la ruta directa de texturas por `0x11xxxxxx` con `LMMODE0 = 0` **sí funciona en una NAOMI**.
* **La tabla de inicialización del bus de sistema de Holly es idéntica**: mismos valores en todos los registros de
  DMA, maple, G1 y G2 (`0xa05f6800-0xa05f7c80`), incluidos los tiempos de espera de G2 (`0xa05f7890 = 0x1b`,
  `0xa05f7894 = 0x271`) y los registros de protección (`MDAPRO 0x61557f00`, `G2APRO 0x46597f00`,
  `PDAPRO 0x67027f00`).
* **El arranque del sonido es el mismo código**: escribe `0xa0702800`, para el ARM (`0xa0702c00 |= 1`), copia el
  driver a `0xa0800000`, escribe el buzón en `0xa0800050/60` releyendo hasta que se queda, y suelta el ARM.

## Lo que SEGA cambió para NAOMI

* **Sin Shinobi.** La versión NAOMI no lleva la librería de sistema Shinobi ni su módulo `syG2`: escribe la RAM y
  los registros del AICA directamente. Las de Dreamcast pasan por las funciones G2 de Shinobi, que esperan a
  `SB_FFST` (`0xa05f688c`): Crazy Taxi y Crazy Taxi 2 miran **los bits 0 y 4** (`tst #1`, `tst #16`). La Shinobi
  1.43, más antigua, de Namco Museum mira **el bit 5** (`tst #32`) con las interrupciones enmascaradas: es nuestro
  sospechoso de su cuelgue en la NAOMI 2.
* **Los datos salen del cartucho, no del GD-ROM**: la versión NAOMI lee los registros de la placa de ROM
  `0xa05f7000-0xa05f7074` y ajusta los tiempos del bus G1 para ella (`0xa05f7480`, `7484`, `7490`, `74a0`, `74a4`,
  `74b8`). La de Dreamcast sólo escribe `7490/7494/74a0` (tabla de arranque en `0x8c01106c`).
* **Los mandos** van por JVS (librería Mioz, por el bus maple hasta la MIE) en vez de mandos maple de Dreamcast, y
  la configuración se guarda en la EEPROM de la NAOMI en vez de en la flash/VMU.
* **Vídeo**: la versión de Dreamcast programa la pantalla ella misma (`FB_R_SOF1`, `FB_R_SIZE`, borde, `SPG_*` —
  `0xa05f8040-0xa05f8064`, `80c4`, `80dc`, `8134-8150`); la de NAOMI toca muchos menos (siempre es VGA a 31 kHz).

## Qué significa para cargar juegos de Dreamcast en NAOMI (dc2naomi)

1. **La ruta de texturas no es el problema por sí sola**: el propio juego NAOMI de SEGA usa `0x11000000` con
   `LMMODE0 = 0`. Nuestra prueba en placa decía que esa ruta no escribía nada, pero fue el primer caso, antes de
   ningún reinicio del TA; los otros dos fueron después de uno. La prueba nueva (`nmus_ch2`) repite el caso `0x11`
   antes y después de reiniciar el TA para salir de dudas.
2. **Holly no necesita nada especial**: la tabla de inicialización del propio juego de Dreamcast es exactamente la
   que usa un juego NAOMI.
3. Lo que queda de Dreamcast es lo que el cargador ya sustituye (GD-ROM → NetDIMM, mando maple → JVS, flash) más
   manías de librería como la espera del bit 5 de `SB_FFST` de las Shinobi antiguas.

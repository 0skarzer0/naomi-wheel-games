# Parches de controles para el mueble Crazy Taxi

Aquí solo hay **parches** (IPS) y scripts; nunca ROMs. Cada usuario los aplica a su propio volcado:

```sh
python3 apply_patch.py TU_ROM.bin[.gz] juego/parche.ips SALIDA.bin.gz
```

## Tabla por juego

| Juego | Entrada original | Reasignación en el mueble Crazy Taxi | Estado |
|---|---|---|---|
| [Jambo! Safari](jambo-safari/) (840-0013 Rev A) | Palanca en J2 ARRIBA/ABAJO | Palanca D/R (J1 ARRIBA/ABAJO) → J2, en cruz: adelante = lazo | 🧪 Probado en intérprete; falta Flycast/placa |

## Procedimiento (repetible con otros juegos NAOMI / NAOMI 2 / Atomiswave)

1. **Comparar mapeos**: `naomi_roms_input.h` de Flycast e `INPUT_PORTS` de `naomi.cpp` en MAME, frente a
   lo que manda el mueble (volante = analógico 0, acelerador = 1, freno = 2, palanca = J1 ARRIBA/ABAJO,
   START del J1).
2. **Encontrar la conversión JVS → variables del juego**: buscar cadenas de depuración o del test de
   entradas (`SW1:%x`, `LEVER UP`…), seguir sus referencias en los pools de literales y llegar a la
   función que copia los bytes JVS crudos a las estructuras por jugador.
3. **Parchear en un único punto** si es posible (la conversión), mejor que en cada lector. Si hace
   falta espacio, compactar la propia función en vez de usar zonas "libres" dudosas.
4. **Probar la equivalencia** con `tools/sh4mini.py`: función original + puente físico simulado frente a
   la función parcheada.
5. Probar en Flycast y en placa; anotar el resultado en la tabla.
6. Checksums: la cabecera NAOMI no lleva; comprobar en cada juego si hace autotest de ROM.

## Herramientas

| Fichero | Para qué |
|---|---|
| `apply_patch.py` | Aplica un IPS a un `.bin`/`.bin.gz` y comprueba la zona original (`.ips.sha1`) |
| `tools/sh4dis.py` | Desensamblador SH-4 con literales resueltos (`pip install capstone>=6`) |
| `tools/sh4mini.py` | Intérprete SH-4 mínimo para pruebas de equivalencia de funciones pequeñas |

# Cómo colaborar / añadir un juego

> 🇬🇧 **English:** [the English version is at the end of this page ↓](#english)

## Reglas

1. **Nada de ROMs, BIOS ni datos derivados de ellas** (ni en el repo, ni en issues, ni en releases). Solo código,
   herramientas, parches y documentación. Los usuarios generan sus imágenes con sus propios volcados.
2. **Agradece todo lo que uses**, también lo que solo sirvió de inspiración: en el README del repo del port y en la
   sección «Agradecimientos» de aquí. Si falta alguien, es un fallo: abre una issue.
3. **Deja constancia en GitHub de cada operación** (receta, herramienta, medida, fallo y arreglo), para que otra
   persona o IA pueda repetirla.
4. **Credenciales:** nunca la contraseña de la Raspberry ni de nada; los documentos dicen «pedírsela al usuario».
5. **Lo que no se ha probado en placa se dice** (🧪), con la fecha. No se marca ✅ sin prueba real.

## Añadir un juego nuevo

1. Mira [docs/juegos.md](docs/juegos.md) (catálogo y dificultad) y [crazytaxi_cabinet_info](https://github.com/0skarzer0/crazytaxi_cabinet_info)
   (controles, JVS y trampas del mueble).
2. Si es un port nativo, empieza por [naomi-kit](https://github.com/0skarzer0/naomi-kit): arranque, controles,
   ficheros de la NetDIMM, datos en vivo y scripts de la Pi ya están hechos. Sigue su
   [controles estándar](https://github.com/0skarzer0/naomi-kit/blob/main/docs/controls.md).
3. Repo propio (o rama) con su `HANDOFF.md`: estado, arquitectura, direcciones, cómo compilar, siguientes pasos.
4. Aquí: una fila en la tabla de repos del [README](README.md), el estado en
   [docs/pi60-juegos.md](docs/pi60-juegos.md) y, cuando cambie, lo antiguo a [docs/historial.md](docs/historial.md)
   con su fecha.
5. Mide en la placa (fps con `pi/live.py` de [naomi-pi-tools](https://github.com/0skarzer0/naomi-pi-tools), que lee el bloque de cualquier proyecto) antes de dar un juego por funcionando.

## Estilo

Documentos en español, con la traducción al inglés al final (enlazada arriba con «🇬🇧 English»); comentarios del código en inglés. Frases cortas, datos con
su fecha y su fuente.

---

## English

*Translation of the Spanish text above. If the two ever disagree, the Spanish one is the up-to-date one.*

### How to contribute / add a game

#### Rules

1. **No ROMs, BIOS or data derived from them** (not in the repo, not in issues, not in releases). Only code, tools,
   patches and documentation. Users build their images from their own dumps.
2. **Credit everything you use**, including what only served as inspiration: in the README of the port's repo and in
   the "Acknowledgements" section here. If someone is missing, that is a bug: open an issue.
3. **Leave a record on GitHub of every operation** (recipe, tool, measurement, failure and fix), so that another
   person or AI can repeat it.
4. **Credentials:** never the password of the Raspberry Pi or of anything else; documents say "ask the user for it".
5. **What has not been tested on the board is said so** (🧪), with the date. Nothing is marked ✅ without a real test.

#### Adding a new game

1. Look at [docs/juegos.md](docs/juegos.md) (catalogue and difficulty) and [crazytaxi_cabinet_info](https://github.com/0skarzer0/crazytaxi_cabinet_info)
   (the cabinet's controls, JVS values and traps).
2. If it is a native port, start from [naomi-kit](https://github.com/0skarzer0/naomi-kit): boot, controls, NetDIMM
   files, live data and Raspberry Pi scripts are already done. Follow its
   [standard controls](https://github.com/0skarzer0/naomi-kit/blob/main/docs/controls.md).
3. Its own repo (or branch) with its `HANDOFF.md`: status, architecture, addresses, how to build, next steps.
4. Here: a row in the repos table of the [README](README.md), the status in
   [docs/pi60-juegos.md](docs/pi60-juegos.md) and, when it changes, the old state to
   [docs/historial.md](docs/historial.md) with its date.
5. Measure on the board (fps with `pi/live.py` from [naomi-pi-tools](https://github.com/0skarzer0/naomi-pi-tools), which reads any project's block) before calling a game working.

#### Style

Documents in Spanish, with the English translation at the end (linked from the top); code comments in English. Short
sentences, figures with their date and source.

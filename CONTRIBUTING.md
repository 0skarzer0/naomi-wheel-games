# Cómo colaborar / añadir un juego

*In short:* no ROMs, ever; document every step on GitHub; credit everything you used. Details below (in Spanish).

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

1. Mira [docs/juegos.md](docs/juegos.md) (catálogo y dificultad) y [docs/hardware.md](docs/hardware.md) (controles
   y JVS del mueble).
2. Si es un port nativo, empieza por [naomi-kit](https://github.com/0skarzer0/naomi-kit): arranque, controles,
   ficheros de la NetDIMM, datos en vivo y scripts de la Pi ya están hechos. Sigue su
   [controles estándar](https://github.com/0skarzer0/naomi-kit/blob/main/docs/controls.md).
3. Repo propio (o rama) con su `HANDOFF.md`: estado, arquitectura, direcciones, cómo compilar, siguientes pasos.
4. Aquí: una fila en la tabla de repos del [README](README.md), el estado en
   [docs/pi60-juegos.md](docs/pi60-juegos.md) y, cuando cambie, lo antiguo a [docs/historial.md](docs/historial.md)
   con su fecha.
5. Mide en la placa (fps con `naomi-kit/tools/pi/live.py`) antes de dar un juego por funcionando.

## Estilo

Documentos en español, con un resumen en inglés arriba; comentarios del código en inglés. Frases cortas, datos con
su fecha y su fuente.

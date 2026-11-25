# naomi-wheel-games — instrucciones para Claude

## Qué es
**Índice general** del proyecto: juegos de coches, motos y spinner para el mueble Crazy Taxi (NAOMI + NetDIMM), con la tabla de todos los repos. Aquí casi solo hay documentación; el código está en cada repo. Cada documento lleva su versión en inglés al final.

## Qué leer primero
1. [README.md](README.md): estado y mapa de repos.
2. [docs/juegos.md](docs/juegos.md) (catálogo) y [docs/pi60-juegos.md](docs/pi60-juegos.md) (lo que hay en la Pi del Crazy Taxi, hoy la .251).
3. [docs/historial.md](docs/historial.md) e [docs/investigacion.md](docs/investigacion.md) solo si hace falta; hardware: [crazytaxi_cabinet_info](https://github.com/0skarzer0/crazytaxi_cabinet_info). Normas: [CONTRIBUTING.md](CONTRIBUTING.md).

## Reglas que no se saltan
- **Los juegos del usuario (ROMs, discos, imágenes) y su `info.txt` están en `C:\Users\Usuario\Documents\dc2naomi` y no se suben nunca a GitHub** (ni se copian al repo, ni se citan sus datos en commits o documentos). Tampoco BIOS ni binarios que lleven ROMs dentro.
- **Las contraseñas van en variables de entorno** (la de las Raspberry, `PIPASS`), **nunca en un archivo** del repo ni en un commit.
- "Probado" = funciona en la placa real; Flycast es solo el primer paso.
- Raspberry (WiPi Netbooter): mueble Crazy Taxi **192.168.68.251** (los documentos antiguos dicen **.60**), mueble estándar **192.168.68.250** (antes .59).
- Al terminar: HANDOFF y docs al día, commit y push.

# Equipo de agentes (Claude + Gemini)

Este proyecto puede usar Gemini vía Antigravity CLI (`agy`) como ayudante para ahorrar tokens.
- Activa el modo equipo con `/equipo <tarea>`; las reglas completas están en `.claude/commands/equipo.md`.
- Encargos y respuestas: `.agy-tasks/` (plantilla en `_plantilla.md`). Script: `scripts/agy-task.ps1` (estado del equipo en `.agy-tasks/_estado.md`).
- `agy` debe usar la API key de Google AI Studio (`GEMINI_API_KEY`), nunca el login de la suscripción.
- Los ayudantes solo leen; los cambios en archivos los hace Claude tras revisar.

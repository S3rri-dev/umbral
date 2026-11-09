---
name: verificar-umbral
description: Verifica cambios de Umbral en Swift, recursos, scripts, empaquetado o interfaz macOS. Usa el script del CI, prepara una copia con datos aislados si hace falta y registra qué quedó comprobado.
---

# Verificar Umbral

Trabaja desde la raíz del repositorio. Lee [AGENTS.md](../../../AGENTS.md), revisa `git status --short --branch` y delimita los cambios que vas a verificar. Consulta las [verificaciones previas](../../../docs/VERIFICATION.md) si necesitas reproducir un recorrido concreto.

| Cambio | Comprobación |
| --- | --- |
| Documentación o guías | Revisa el diff, los enlaces y los comandos citados. |
| Scripts | Comprueba la sintaxis con `bash -n` o `zsh -n` según el shebang. Ejecuta el recorrido afectado con entradas de prueba. |
| Swift, recursos, compilación o bundle | Ejecuta `./tests/run.sh`. Para un bundle recién generado o montado, ejecuta `./tests/run.sh "/ruta/a/Umbral.app"` para verificarlo directamente. |
| DMG | Usa `./scripts/package-dmg.sh` si el encargo requiere generar un instalador. Monta el resultado en solo lectura, verifica el bundle con `./tests/run.sh "/ruta/al/volumen/Umbral.app"` y comprueba el enlace a Aplicaciones. Lee [Publicar una versión](../../../docs/RELEASING.md) si se pide un paquete de distribución. |

[El CI](../../../.github/workflows/ci.yml) ejecuta `./tests/run.sh` en macOS Intel para compilar y verificar el bundle ARM64. Las pruebas internas del ejecutable y del asistente se ejecutan en Apple Silicon. Una prueba interna del asistente valida su lógica y deja por verificar el control físico.

## Interfaz real

Si el cambio afecta ventanas, bienvenida, menús, ajustes, permisos o interacción con macOS, crea una copia del bundle recién verificado.

```sh
qa_app="$(./scripts/prepare-ui-test.sh dist/Umbral.app)"
open "$qa_app"
```

El script imprime la ruta de la copia y le da un identificador propio. Usa la ruta exacta para la revisión nativa, con datos sintéticos si el recorrido escribe archivos. Comprueba el resultado visible y cierra la copia al terminar. Las acciones que concedan permisos, instalen servicios o cambien ajustes del sistema requieren autorización para esa prueba. Si falta, verifica la ruta previa y deja la acción pendiente.

## Evidencia

Revisa `git diff --check` y el diff final, incluidos los archivos nuevos. Indica el comando y el resultado de cada comprobación automática. Para la interfaz indica la versión del bundle, macOS, el recorrido y el resultado observado. Anota por separado las comprobaciones omitidas o pendientes y su motivo. Registra evidencias nuevas de la app o de distribución en [Verificación](../../../docs/VERIFICATION.md). La preparación de una copia y la ejecución de las pruebas internas se registran aparte de la interacción nativa.

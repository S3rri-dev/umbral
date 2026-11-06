# Verificación de Umbral 1.0.0

**6 de noviembre de 2026 · Mac Apple Silicon · macOS 27.0.1.**

- `./tests/run.sh` comprueba el ejecutable ARM64, el objetivo macOS 14, el Info.plist, los contornos de Fuga, la firma local y que los símbolos estén libres de rutas privadas de compilación.
- En una copia nativa con el identificador público se recorrieron los cuatro pasos de bienvenida. La elección de Ventanas abrió esa categoría sin pedir permisos.
- Buscar «volumen» encontró el mezclador. Su ficha mostró **En preparación**.
- El tema claro y el acento naranja se aplicaron de forma independiente. Se comprobó el símbolo monocromo en **Ajustes → Barra de menús**.

La comprobación automatizada compila y verifica el bundle ARM64 desde el runner macOS 26 Intel. La revisión gráfica se hizo en el Mac Apple Silicon indicado arriba. La edición pública usa firma ad hoc. Quedan pendientes la notarización, una prueba en macOS 14 y la verificación de navegación con flechas en la barra lateral.

## Umbral 2.0.0

**6 de noviembre de 2026 · Apple Silicon · macOS 27.0.1.**

- Se abrió una copia con preferencias aisladas. Se comprobó la bienvenida en español, el panel de barra de menús, el acceso a Ajustes y el selector de acento.
- La página Funciones mostró 43 herramientas y 13 entradas de Dynamic Island. La prueba interna comprobó los 43 identificadores, las ocho entradas del monitor y la exclusión del resto del catálogo.
- Las pruebas internas del ejecutable y del asistente de ventiladores pasaron. Quedan por probar con permisos concedidos las rutas globales de entrada, audio y captura, así como el comportamiento en macOS 14 y la ventilación con firma Developer ID.

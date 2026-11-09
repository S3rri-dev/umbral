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

## Flujo de desarrollo con Codex

**9 de noviembre de 2026 · Apple Silicon · macOS 27.0.1.**

- `./tests/run.sh` compiló y verificó el bundle ARM64. Pasaron `SELFTEST OK` y `fan-control-helper: ok`. La segunda ejecución sobre el bundle existente dejó el archivo de preferencias de Umbral igual y el self-test funcionó sin generar un plist propio.
- `./scripts/prepare-ui-test.sh dist/Umbral.app` generó una copia temporal con un identificador distinto y firma local válida. El script rechazó un bundle ajeno y una llamada sin argumentos.
- En la copia de Umbral 2.0.0 se recorrieron los cuatro pasos de bienvenida con el perfil Esencial. La selección mostró 43 funciones en el catálogo, el paso de permisos dejó continuar y el panel nativo se abrió al terminar. Se cerró desde **Salir**.
- El flujo local dejó pendientes el CI remoto, la publicación y las pruebas de funciones que exigen permisos del sistema. Se conservan los límites de la verificación de 2.0.0.

## Dynamic Island y compañero gato

**9 de noviembre de 2026 · Umbral 2.0.0 · Apple Silicon · macOS 27.0.1.**

- `./tests/run.sh` compiló el bundle ARM64 y verificó los recursos, incluido el maullido. Pasaron `SELFTEST OK` y `fan-control-helper: ok`. El self-test comprueba el intervalo de comida, el rebote y el límite de tamaño de los perfiles, y la clasificación de los avisos por identificador de aplicación.
- En una copia con identificador y preferencias propios, el notch compacto mostró el título y el artista de dos canciones en reproducción. En **Ajustes → Dynamic Island → Comportamiento** se eligió **Elástica** y se abrió y contrajo la isla.
- En **Compañero**, la comida cambió el estado de **Tiene hambre** a **Ya ha comido** y quedó registrada en las preferencias de la copia. **Siesta** mostró los ojos cerrados y el control **Despertar**. Con la actividad musical de la copia desactivada se vio al gato junto al notch físico.
- Quedaron pendientes el maullido audible, una prueba prolongada de las visitas autónomas y la recepción de un aviso real de Teléfono o FaceTime con Accesibilidad concedida. La prueba no cambió los permisos del sistema.

- Se instaló esta compilación en `/Applications/Umbral.app`. Pasaron `./tests/run.sh /Applications/Umbral.app` y la comprobación de arranque desde esa ruta.

# Preparar una publicación

1. Actualiza la versión y el número de compilación en `Info.plist`, el historial y las notas en `docs/releases/`.
2. Ejecuta `./tests/run.sh` y verifica el arranque y las pantallas en una sesión gráfica.
3. Confirma los cambios y crea la etiqueta `vX.Y.Z`. Ejecuta `./scripts/package.sh` desde un árbol limpio.
4. Monta el DMG, verifica el bundle y comprueba las sumas. El manifiesto incluye el commit que se empaquetó.
5. Con la identidad de GitHub verificada, sube la etiqueta y los paquetes a una release. El flujo **Preparar release** puede preparar un borrador para una etiqueta existente.

Si una publicación contiene un paquete defectuoso, retira el activo afectado, documenta el problema y publica una versión de corrección con una etiqueta nueva.

## Instalación en el Mac de desarrollo

En cada versión, instala en `/Applications/Umbral.app` el bundle verificado de la entrega. Si hay una versión anterior abierta, ciérrala antes de sustituir el bundle. Conserva el identificador de aplicación, el dominio de preferencias y los datos locales. Comprueba la versión instalada con `./tests/run.sh /Applications/Umbral.app` y verifica que arranca desde esa ruta.

# Verificación de Umbral 1.0.0

**6 de noviembre de 2026 · Mac Apple Silicon · macOS 27.0.1.**

- `./tests/run.sh` compiló y comprobó el ejecutable ARM64, el objetivo macOS 14, el Info.plist, los contornos de Fuga y la firma local.
- En una copia nativa con el identificador público se recorrieron los cuatro pasos de bienvenida. La elección de Ventanas abrió esa categoría sin pedir permisos.
- Buscar «volumen» encontró el mezclador. Su ficha mostró **En preparación**.
- El tema claro y el acento naranja se aplicaron de forma independiente. Se comprobó el símbolo monocromo en **Ajustes → Barra de menús**.

La comprobación automatizada del bundle se ejecuta en GitHub Actions sobre macOS ARM64. La revisión gráfica se hizo en el Mac indicado arriba. La edición pública usa firma ad hoc. Quedan pendientes la notarización, una prueba en macOS 14 y la verificación de navegación con flechas en la barra lateral.

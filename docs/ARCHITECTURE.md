# Arquitectura

Umbral 2.0.0 es una aplicación AppKit con vistas SwiftUI. `AppDelegate` crea los ajustes, la bienvenida y el panel de barra de menús. El catálogo de 43 herramientas se declara en `Core/FeatureCatalog.swift`. `FeatureRuntime` coordina su disponibilidad y la puesta en marcha de los servicios al instalarlas o activarlas.

El bundle contiene el ejecutable principal, un adaptador para reproducción multimedia y un asistente de ventiladores. El asistente incluye validación de identidad y protección de retorno a automático. El control manual requiere que el asistente y la app tengan la firma de un equipo propio configurado.

`scripts/compile.sh` construye para Apple Silicon. `scripts/build.sh` empaqueta los recursos y firma los tres binarios. La procedencia del código se documenta en [Software de terceros](../THIRD_PARTY_NOTICES.md).

# Arquitectura

Umbral es un ejecutable SwiftPM con una interfaz SwiftUI. `MacUtilitiesApp` coordina la ventana y el `MenuBarExtra`. AppKit proporciona el icono de plantilla y la activación de la ventana desde el panel.

`Catalog.swift` define las fichas y sus categorías. La bienvenida, las preferencias y el panel rápido son vistas separadas. `AppStorage` persiste solo preferencias. `Resources/` contiene los dos vectores de Fuga y el empaquetado los convierte a ICNS y PNG para el bundle.

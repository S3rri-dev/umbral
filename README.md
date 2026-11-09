<div align="center">

<img src="docs/images/icon.png" width="88" alt="Icono Fuga de Umbral">

# Umbral

Un catálogo de utilidades para Mac con acceso desde la barra de menús.

[![CI](https://github.com/S3rri-dev/umbral/actions/workflows/ci.yml/badge.svg)](https://github.com/S3rri-dev/umbral/actions/workflows/ci.yml)
[![GPL](https://img.shields.io/badge/c%C3%B3digo-GPL--3.0--or--later-666666)](LICENSE)
[![Apple Silicon](https://img.shields.io/badge/Mac-Apple%20Silicon-666666)](docs/INSTALL.md)

**[Descargar para Mac](https://github.com/S3rri-dev/umbral/releases/latest)** · **[Primeros pasos](docs/GETTING_STARTED.md)** · **[Ayuda](SUPPORT.md)**

Español · [English](README.en.md)

</div>

![Dos piezas de Fuga en grafito y aluminio](docs/images/hero.jpg)

## Umbral 2.0.0

La bienvenida te deja elegir entre tres configuraciones o seleccionar las herramientas una por una. Desde **Ajustes → Funciones** puedes cambiar esa selección y revisar qué permisos usa cada herramienta.

Dynamic Island muestra la música en reproducción y tiene un gato animado al que puedes dar de comer, mandar a dormir o pedirle un maullido. El movimiento y el sonido del gato se ajustan por separado.

El catálogo reúne 43 herramientas. Incluye ventanas, Dock, portapapeles, audio, energía, grabación, Dynamic Island y monitorización del sistema. [Alcance de la versión](docs/ROADMAP.md)

## Instalar

Descarga el DMG y arrastra **Umbral.app** a Aplicaciones. Para compilar un DMG a partir del código fuente, ejecuta `./scripts/package-dmg.sh`.

Apple Silicon. Objetivo mínimo de compilación macOS 14. El DMG lleva firma ad hoc. [Instalación](docs/INSTALL.md) · [Verificación](docs/VERIFICATION.md)

## Privacidad y permisos

Las herramientas solicitan los permisos que requieren según tu selección. Puedes consultar su finalidad en la bienvenida o en Ajustes. [Privacidad](docs/PRIVACY.md) · [Permisos](docs/PERMISSIONS.md) · [Preferencias](docs/DATA.md)

## Compilar y probar

Necesitas un Mac Apple Silicon con Xcode Command Line Tools y Python 3 para las comprobaciones.

```sh
git clone https://github.com/S3rri-dev/umbral.git
cd umbral
./tests/run.sh
open dist/Umbral.app
```

[Arquitectura](docs/ARCHITECTURE.md) · [Contribuir](CONTRIBUTING.md) · [Publicar una versión](docs/RELEASING.md) · [Historial](CHANGELOG.md)

## Código e identidad

Copyright © 2026 S3rri-dev y colaboradores. Código **GPL-3.0-or-later**. [Licencia](LICENSE) · [Nombre e identidad](TRADEMARKS.md) · [Procedencia](THIRD_PARTY_NOTICES.md)

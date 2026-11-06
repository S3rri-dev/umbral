# Instalar Umbral

Umbral 1.0.0 se compila para Mac con Apple Silicon y tiene como objetivo mínimo macOS 14. Consulta las [comprobaciones realizadas](VERIFICATION.md) para conocer los entornos probados.

1. Descarga `Umbral-1.0.0-arm64.dmg` de [Releases](https://github.com/S3rri-dev/umbral/releases/latest).
2. Abre la imagen y arrastra **Umbral.app** a **Aplicaciones**.
3. Abre Umbral desde Aplicaciones.

También puedes extraer el ZIP de la app y moverla a Aplicaciones. El DMG y el ZIP contienen el mismo bundle.

La aplicación lleva **firma ad hoc**, sin Developer ID ni notarización. Gatekeeper puede impedir el primer arranque de la descarga. Apple explica las opciones en su [guía de apertura de apps](https://support.apple.com/es-es/102445). Puedes revisar y compilar la etiqueta publicada con `./scripts/build.sh`.

Para comprobar una descarga, coloca el paquete y `SHA256SUMS.txt` en la misma carpeta y ejecuta `shasum -a 256 -c SHA256SUMS.txt`. La orden verifica todos los paquetes presentes en el fichero de sumas.

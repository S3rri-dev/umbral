# Asistente de ventiladores

- Conserva la validación de firma y la identidad XPC de la app y del asistente. Revisa también `Sources/Umbral/Services/FanControl/` y el plist de LaunchDaemons al cambiar el protocolo, el identificador o el empaquetado.
- Preserva el retorno a automático ante una sesión interrumpida, una conexión perdida o un error al aplicar los ajustes. Mantén el control manual condicionado a la firma de distribución configurada para Umbral.
- Ejecuta `./tests/run.sh` desde la raíz para verificar el bundle y el `--selftest` del asistente en Apple Silicon. El self-test valida la lógica sin registrar el daemon. Una prueba de control físico requiere un equipo compatible, firma y autorización expresas.

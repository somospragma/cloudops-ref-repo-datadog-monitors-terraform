# Changelog

Todos los cambios notables en este módulo serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [Unreleased]

## [1.0.0] - 2025-01-06

### Added
- Estructura inicial del módulo de referencia para Datadog Monitors
- Soporte para creación de múltiples monitors mediante `for_each`
- Sistema de nomenclatura estándar enterprise (`{client}-{project}-{environment}-monitor-{key}`)
- Sistema de etiquetado de dos niveles (gobernanza + específicos)
- Variables de configuración con validaciones robustas
- Outputs granulares de IDs, nombres, tipos y queries de monitors
- Ejemplo funcional en directorio `sample/` con 9 monitors configurados:
  - Lambda errors
  - EKS nodes (memory y CPU)
  - EKS pods (CrashLoopBackOff)
  - API Gateway (5xx, 4xx, latency, anomalies)
  - RDS CPU utilization
- Documentación completa en README.md
- Cumplimiento con reglas PC-IAC adaptadas a Datadog
- Soporte para múltiples tipos de monitors (metric alert, log alert, service check, query alert, composite, event alert)
- Configuración de thresholds (critical, warning, recovery)
- Configuración de notificaciones y re-notificaciones
- Configuración de comportamiento con datos faltantes (on_missing_data)
- Configuración de prioridades (1-5)
- Configuración de evaluation_delay para métricas con retraso
- Tags personalizables por monitor
- Provider con alias `datadog.project` para inyección desde Root
- Validaciones de variables (client, project, environment, monitors_config)
- Lifecycle rules para prevenir destrucción accidental

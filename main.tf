# Recursos principales del módulo
#
# PC-IAC-010: for_each obligatorio para múltiples recursos
# PC-IAC-023: Responsabilidad única - solo crea Monitors de Datadog
# PC-IAC-014: Bloques dinámicos para configuraciones opcionales

# ============================================================================
# Datadog Monitors
# ============================================================================

resource "datadog_monitor" "this" {
  for_each = var.monitors_config
  provider = datadog.project

  # Configuración básica del monitor
  name    = each.value.name
  type    = each.value.type
  query   = each.value.query
  message = each.value.message

  # PC-IAC-014: Bloque dinámico para thresholds
  monitor_thresholds {
    critical          = each.value.thresholds.critical
    warning           = each.value.thresholds.warning
    critical_recovery = each.value.thresholds.critical_recovery
    warning_recovery  = each.value.thresholds.warning_recovery
  }

  # Configuración de notificaciones
  renotify_interval   = each.value.renotify_interval
  require_full_window = each.value.require_full_window

  # Configuración opcional de evaluation_delay
  evaluation_delay = each.value.evaluation_delay

  # Configuración opcional de priority (1=alta, 5=baja)
  priority = each.value.priority

  # Configuración de comportamiento cuando faltan datos
  # NOTA: on_missing_data reemplaza notify_no_data y no_data_timeframe (son mutuamente excluyentes)
  on_missing_data = each.value.on_missing_data

  # PC-IAC-004: Sistema de etiquetado de dos niveles
  # Combina tags base del módulo con tags adicionales específicos del monitor
  tags = concat(
    local.base_module_tags,
    each.value.additional_tags
  )

  # PC-IAC-010: Lifecycle para prevenir destrucción accidental de monitors críticos
  lifecycle {
    create_before_destroy = true
  }
}

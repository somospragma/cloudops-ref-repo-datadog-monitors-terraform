# Outputs del módulo
#
# PC-IAC-007: Outputs granulares con descriptions obligatorios
# PC-IAC-014: Uso de expresiones para extracción de colecciones

# ============================================================================
# Outputs de Monitors
# ============================================================================

output "monitor_ids" {
  description = "Mapa de IDs de los Monitors creados. La clave es el identificador del monitor y el valor es su ID."
  value = {
    for key, monitor in datadog_monitor.this :
    key => monitor.id
  }
}

output "monitor_names" {
  description = "Mapa de nombres de los Monitors creados. La clave es el identificador del monitor y el valor es su nombre."
  value = {
    for key, monitor in datadog_monitor.this :
    key => monitor.name
  }
}

output "monitor_types" {
  description = "Mapa de tipos de los Monitors creados. La clave es el identificador del monitor y el valor es su tipo."
  value = {
    for key, monitor in datadog_monitor.this :
    key => monitor.type
  }
}

output "monitor_queries" {
  description = "Mapa de queries de los Monitors creados. La clave es el identificador del monitor y el valor es su query."
  value = {
    for key, monitor in datadog_monitor.this :
    key => monitor.query
  }
}

output "all_monitor_ids" {
  description = "Lista de todos los IDs de monitors creados."
  value       = values(datadog_monitor.this)[*].id
}

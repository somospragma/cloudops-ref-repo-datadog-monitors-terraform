# Outputs del ejemplo
#
# PC-IAC-007: Outputs para validar la infraestructura del ejemplo

output "monitor_ids" {
  description = "IDs de los monitors creados en el ejemplo"
  value       = module.datadog_monitors.monitor_ids
}

output "monitor_names" {
  description = "Nombres de los monitors creados en el ejemplo"
  value       = module.datadog_monitors.monitor_names
}

output "all_monitor_ids" {
  description = "Lista de todos los IDs de monitors creados"
  value       = module.datadog_monitors.all_monitor_ids
}

output "monitor_count" {
  description = "Número total de monitors creados"
  value       = length(module.datadog_monitors.all_monitor_ids)
}

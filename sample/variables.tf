# Variables del ejemplo
#
# PC-IAC-002: Definición de variables con tipos explícitos

variable "client" {
  description = "Nombre del cliente o unidad de negocio"
  type        = string
}

variable "project" {
  description = "Nombre del proyecto específico"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn, prod)"
  type        = string
}

variable "monitors_config" {
  description = "Mapa de configuraciones de monitors de Datadog"
  type = map(object({
    name    = string
    type    = string
    query   = string
    message = string
    thresholds = object({
      critical          = number
      warning           = optional(number)
      critical_recovery = optional(number)
      warning_recovery  = optional(number)
    })
    renotify_interval   = optional(number, 0)
    require_full_window = optional(bool, false)
    evaluation_delay    = optional(number)
    priority            = optional(number)
    on_missing_data     = optional(string, "default")
    additional_tags     = optional(list(string), [])
  }))
}

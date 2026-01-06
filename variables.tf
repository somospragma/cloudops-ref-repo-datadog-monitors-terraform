# Variables de entrada del módulo
#
# PC-IAC-002: Variables obligatorias y buenas prácticas de declaración
# PC-IAC-009: Tipos de datos inteligentes con map(object())
# PC-IAC-016: Manejo de datos sensibles

# ============================================================================
# Variables de Gobernanza (Obligatorias - PC-IAC-002)
# ============================================================================

variable "client" {
  description = "Nombre del cliente o unidad de negocio. Usado para construcción de nomenclatura estándar y tags."
  type        = string

  validation {
    condition     = length(var.client) > 0 && length(var.client) <= 10
    error_message = "El nombre del cliente debe tener entre 1 y 10 caracteres."
  }
}

variable "project" {
  description = "Nombre del proyecto específico. Usado para construcción de nomenclatura estándar y tags."
  type        = string

  validation {
    condition     = length(var.project) > 0 && length(var.project) <= 15
    error_message = "El nombre del proyecto debe tener entre 1 y 15 caracteres."
  }
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn, prod). Usado para construcción de nomenclatura estándar y tags."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "pdn", "prod"], var.environment)
    error_message = "El ambiente debe ser uno de: dev, qa, pdn, prod."
  }
}

# ============================================================================
# Configuración de Monitors (PC-IAC-009)
# ============================================================================

variable "monitors_config" {
  description = <<-EOT
    Mapa de configuraciones de Monitors de Datadog. La clave del mapa se usa como identificador único.
    
    Estructura:
    - name: (string) Nombre completo del monitor (debe venir construido desde el Root con PC-IAC-025)
    - type: (string) Tipo de monitor (metric alert, service check, log alert, etc.)
    - query: (string) Query del monitor en sintaxis de Datadog
    - message: (string) Mensaje de notificación del monitor
    - thresholds: (object) Umbrales críticos y de warning
      - critical: (number) Umbral crítico
      - warning: (number, opcional) Umbral de warning
      - critical_recovery: (number, opcional) Umbral de recuperación crítica
      - warning_recovery: (number, opcional) Umbral de recuperación de warning
    - renotify_interval: (number, opcional) Minutos entre re-notificaciones (default: 0 = no renotificar)
    - require_full_window: (bool, opcional) Si requiere ventana completa de datos (default: false)
    - evaluation_delay: (number, opcional) Segundos de retraso en evaluación (default: null)
    - priority: (number, opcional) Prioridad del monitor de 1 (alta) a 5 (baja) (default: null)
    - on_missing_data: (string, opcional) Comportamiento cuando faltan datos: default, show_no_data, show_and_notify_no_data, resolve (default: "default")
    - additional_tags: (list, opcional) Tags adicionales específicos del monitor
    
    Ejemplo:
    {
      "lambda-errors" = {
        name    = "pragma-ecommerce-dev-monitor-lambda-errors"
        type    = "metric alert"
        query   = "avg(last_5m):sum:aws.lambda.errors{environment:dev} by {functionname} > 5"
        message = "Lambda function {{functionname.name}} error rate is high: {{value}} errors"
        thresholds = {
          critical = 5
          warning  = 2
        }
        priority        = 1
        on_missing_data = "show_and_notify_no_data"
        additional_tags = ["service:lambda", "severity:critical"]
      }
    }
  EOT
  type = map(object({
    name    = string
    type    = string
    query   = string
    message = string
    thresholds = object({
      critical           = number
      warning            = optional(number)
      critical_recovery  = optional(number)
      warning_recovery   = optional(number)
    })
    renotify_interval   = optional(number, 0)
    require_full_window = optional(bool, false)
    evaluation_delay    = optional(number)
    priority            = optional(number)
    on_missing_data     = optional(string, "default")
    additional_tags     = optional(list(string), [])
  }))

  validation {
    condition     = length(var.monitors_config) > 0
    error_message = "Debe proporcionar al menos un monitor en la configuración."
  }

  validation {
    condition = alltrue([
      for key, monitor in var.monitors_config :
      length(monitor.name) > 0 && length(monitor.type) > 0 && length(monitor.query) > 0 && length(monitor.message) > 0
    ])
    error_message = "Todos los monitors deben tener name, type, query y message no vacíos."
  }

  validation {
    condition = alltrue([
      for key, monitor in var.monitors_config :
      contains(["metric alert", "service check", "log alert", "query alert", "composite", "event alert"], monitor.type)
    ])
    error_message = "El tipo de monitor debe ser uno de: metric alert, service check, log alert, query alert, composite, event alert."
  }

  validation {
    condition = alltrue([
      for key, monitor in var.monitors_config :
      monitor.priority == null || (monitor.priority >= 1 && monitor.priority <= 5)
    ])
    error_message = "La prioridad debe estar entre 1 (alta) y 5 (baja), o ser null."
  }

  validation {
    condition = alltrue([
      for key, monitor in var.monitors_config :
      contains(["default", "show_no_data", "show_and_notify_no_data", "resolve"], monitor.on_missing_data)
    ])
    error_message = "on_missing_data debe ser uno de: default, show_no_data, show_and_notify_no_data, resolve."
  }
}

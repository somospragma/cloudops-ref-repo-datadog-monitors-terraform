# Transformaciones del ejemplo
#
# PC-IAC-026: Todas las transformaciones deben estar en locals.tf
# PC-IAC-025: Construcción de nomenclatura completa en el Root

locals {
  # Prefijo de gobernanza para nomenclatura estándar
  # PC-IAC-003: {client}-{project}-{environment}
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # PC-IAC-025: Transformar configuración de monitors agregando nomenclatura completa
  # El nombre se construye aquí, no en el módulo
  monitors_config_transformed = {
    for key, config in var.monitors_config : key => merge(config, {
      # Inyectar nombre completo si está vacío (PC-IAC-009)
      name = length(config.name) > 0 ? config.name : "${local.governance_prefix}-monitor-${key}"
    })
  }
}

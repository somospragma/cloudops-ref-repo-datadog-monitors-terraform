# Invocación del módulo padre
#
# PC-IAC-026: Este archivo SOLO debe contener la invocación del módulo
# PROHIBIDO: Incluir bloques locals {} aquí

############################################################################
# Invocación del Módulo Padre (Datadog Monitors)
############################################################################

module "datadog_monitors" {
  source = "../"  # 👈 Apunta al directorio padre (el módulo de referencia)

  providers = {
    datadog.project = datadog.principal
  }

  # Variables obligatorias de gobernanza (PC-IAC-002)
  client      = var.client
  project     = var.project
  environment = var.environment

  # ✅ Configuración transformada desde locals (PC-IAC-026)
  # El nombre completo ya viene construido desde locals.tf
  monitors_config = local.monitors_config_transformed
}

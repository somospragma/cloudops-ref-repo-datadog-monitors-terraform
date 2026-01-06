# Valores locales y transformaciones
#
# PC-IAC-012: Estructuras de datos y reutilización en Locals
# PC-IAC-003: Nomenclatura estándar

locals {
  # Prefijo de gobernanza para tags y referencias
  # PC-IAC-003: Construcción del prefijo base
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # Tags base del módulo para todos los monitors
  # PC-IAC-004: Sistema de etiquetado de dos niveles
  base_module_tags = [
    "managed_by:terraform",
    "module:datadog-monitors",
    "client:${var.client}",
    "project:${var.project}",
    "environment:${var.environment}"
  ]
}

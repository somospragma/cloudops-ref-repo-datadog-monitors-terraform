# Data sources del ejemplo
#
# PC-IAC-011: Data Sources para obtener información dinámica
# En el caso de Datadog, típicamente no se necesitan data sources
# ya que la configuración es declarativa.
# Este archivo existe para cumplir con PC-IAC-001.

# Ejemplo de data source si se necesitara obtener información de Datadog:
# data "datadog_monitor" "existing" {
#   name_filter = "some-monitor-name"
# }

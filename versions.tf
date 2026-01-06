# Requisitos de versión de Terraform y providers
#
# PC-IAC-006: Versiones y Estabilidad
# PC-IAC-005: Configuración de alias del provider

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    datadog = {
      source                = "DataDog/datadog"
      version               = ">= 3.0.0"
      configuration_aliases = [datadog.project]
    }
  }
}

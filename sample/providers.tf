# Configuración de providers para el ejemplo
#
# PC-IAC-005: Provider con alias para inyección
# PC-IAC-008: Backend S3 para gestión de estado

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }
  }

  # PC-IAC-008: Backend S3 con cifrado y bloqueo
  # Configuración para almacenar el estado de Terraform de forma segura
  # backend "s3" {
  #   bucket = "pragma-terraform-state"           # Bucket para el estado
  #   key    = "datadog-monitors/sample/terraform.tfstate"  # Ruta del archivo de estado
  #   region = "us-east-1"                        # Región del bucket
    
  #   # Seguridad obligatoria (PC-IAC-008)
  #   encrypt        = true                       # Cifrado en reposo
  #   use_lockfile   = true                       # Bloqueo de estado para prevenir ejecuciones concurrentes
    
  #   # Opcional: Para uso local con perfiles de AWS
  #   # profile = "pra_backend_dev"
    
  #   # Opcional: Para uso con DynamoDB para bloqueo (alternativa a use_lockfile)
  #   # dynamodb_table = "terraform-state-lock"
  # }
}

# Provider principal del ejemplo
# Las credenciales se inyectan mediante variables de entorno:
# - DATADOG_API_KEY
# - DATADOG_APP_KEY
provider "datadog" {
  alias = "principal"
}




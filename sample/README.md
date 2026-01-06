# Ejemplo de Uso del Módulo Datadog Monitors

Este directorio contiene un ejemplo funcional completo de cómo usar el módulo de Datadog Monitors.

## 📋 Descripción

Este ejemplo demuestra:
- Configuración de monitors en `terraform.tfvars`
- Transformación de configuración en `locals.tf`
- Invocación del módulo padre en `main.tf`
- Uso de data sources para obtener información dinámica (si aplica)

## 🚀 Cómo Ejecutar

### Prerrequisitos

1. Terraform >= 1.0.0 instalado
2. Credenciales de Datadog configuradas:
   - `DATADOG_API_KEY` - API Key de Datadog
   - `DATADOG_APP_KEY` - Application Key de Datadog

### Pasos

1. **Configurar variables de entorno**:
   ```bash
   export DATADOG_API_KEY="tu-api-key"
   export DATADOG_APP_KEY="tu-app-key"
   ```

2. **Editar terraform.tfvars**:
   ```bash
   cp terraform.tfvars terraform.tfvars.local
   # Editar terraform.tfvars.local con tus valores
   ```

3. **Inicializar Terraform**:
   ```bash
   terraform init
   ```

4. **Validar configuración**:
   ```bash
   terraform validate
   terraform fmt -check
   ```

5. **Ver plan de ejecución**:
   ```bash
   terraform plan
   ```

6. **Aplicar cambios**:
   ```bash
   terraform apply
   ```

7. **Ver outputs**:
   ```bash
   terraform output
   ```

## 📁 Estructura de Archivos

```
sample/
├── README.md              # Este archivo
├── terraform.tfvars       # Configuración de ejemplo
├── variables.tf           # Definición de variables
├── data.tf                # Data sources (si aplica)
├── locals.tf              # Transformaciones de configuración
├── main.tf                # Invocación del módulo padre
├── outputs.tf             # Outputs del ejemplo
└── providers.tf           # Configuración del provider
```

## 🔄 Flujo de Datos (PC-IAC-026)

```
terraform.tfvars → variables.tf → locals.tf → main.tf → ../
    (config)        (tipos)      (transform)  (invoca módulo padre)
```

## 📝 Notas

- Este ejemplo usa configuración local para demostración
- En producción, usa el módulo desde un repositorio remoto versionado
- Las credenciales de Datadog se inyectan mediante variables de entorno
- Los nombres de monitors siguen la nomenclatura estándar enterprise

## 🧹 Limpieza

Para destruir los recursos creados:

```bash
terraform destroy
```

## ⚠️ Advertencias

- Este ejemplo crea monitors reales en Datadog
- Asegúrate de usar un ambiente de prueba
- Los monitors pueden generar alertas si los thresholds se alcanzan
- Revisa los costos asociados con tu plan de Datadog

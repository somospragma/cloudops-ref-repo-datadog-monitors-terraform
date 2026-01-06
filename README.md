# Módulo de Referencia: Datadog Monitors

Módulo de Terraform para la creación y gestión de Monitors en Datadog siguiendo los estándares enterprise de gobernanza PC-IAC.

## 📋 Descripción

Este módulo permite crear múltiples monitors de Datadog de forma estandarizada, aplicando nomenclatura consistente, sistema de etiquetado de dos niveles y mejores prácticas de configuración.

### Características Principales

- ✅ Creación de múltiples monitors mediante `for_each`
- ✅ Nomenclatura estándar enterprise (`{client}-{project}-{environment}-monitor-{key}`)
- ✅ Sistema de etiquetado de dos niveles (gobernanza + específicos)
- ✅ Soporte para diferentes tipos de monitors (metric alert, log alert, service check, etc.)
- ✅ Configuración de thresholds (critical, warning, recovery)
- ✅ Gestión de notificaciones y re-notificaciones
- ✅ Configuración de alertas por falta de datos (no_data)
- ✅ Tags personalizables por monitor
- ✅ Outputs granulares de IDs y nombres

## 🚀 Uso

### Ejemplo Básico

```hcl
module "datadog_monitors" {
  source = "git::https://github.com/org/cloudops-ref-repo-datadog-monitors-terraform.git?ref=v1.0.0"

  providers = {
    datadog.project = datadog.principal
  }

  # Variables de gobernanza
  client      = "pragma"
  project     = "ecommerce"
  environment = "dev"

  # Configuración de monitors
  monitors_config = {
    "lambda-errors" = {
      name    = "pragma-ecommerce-dev-monitor-lambda-errors"
      type    = "metric alert"
      query   = "avg(last_5m):sum:aws.lambda.errors{environment:dev} by {functionname} > 5"
      message = <<-EOT
        Lambda function {{functionname.name}} error rate is critically high: {{value}} errors
        
        @slack-alerts @pagerduty-oncall
      EOT
      
      thresholds = {
        critical = 5
        warning  = 2
      }
      
      notify_no_data    = true
      no_data_timeframe = 10
      renotify_interval = 60
      
      additional_tags = [
        "service:lambda",
        "severity:critical",
        "metric:errors"
      ]
    }
    
    "rds-cpu" = {
      name    = "pragma-ecommerce-dev-monitor-rds-cpu"
      type    = "metric alert"
      query   = "avg(last_5m):avg:aws.rds.cpuutilization{environment:dev} by {dbinstanceidentifier} > 90"
      message = "RDS instance {{dbinstanceidentifier.name}} CPU is high: {{value}}% @slack-alerts"
      
      thresholds = {
        critical = 90
        warning  = 80
      }
      
      notify_no_data = true
      
      additional_tags = [
        "service:rds",
        "severity:warning",
        "metric:cpu"
      ]
    }
  }
}
```

### Ejemplo con Evaluación Retrasada

```hcl
monitors_config = {
  "cloudwatch-metric" = {
    name    = "pragma-ecommerce-dev-monitor-cloudwatch-metric"
    type    = "metric alert"
    query   = "avg(last_5m):avg:aws.ec2.cpuutilization{environment:dev} > 85"
    message = "EC2 CPU is high @slack-alerts"
    
    thresholds = {
      critical = 85
      warning  = 75
    }
    
    # Retraso de 5 minutos para métricas de CloudWatch
    evaluation_delay = 300
    
    additional_tags = ["service:ec2"]
  }
}
```

## 📥 Inputs

| Nombre | Descripción | Tipo | Requerido | Default |
|--------|-------------|------|-----------|---------|
| `client` | Nombre del cliente o unidad de negocio | `string` | ✅ | - |
| `project` | Nombre del proyecto específico | `string` | ✅ | - |
| `environment` | Entorno de despliegue (dev, qa, pdn, prod) | `string` | ✅ | - |
| `monitors_config` | Mapa de configuraciones de monitors | `map(object)` | ✅ | - |

### Estructura de `monitors_config`

```hcl
monitors_config = {
  "identificador-unico" = {
    name                = string           # Nombre completo del monitor
    type                = string           # Tipo: metric alert, log alert, service check, etc.
    query               = string           # Query de Datadog
    message             = string           # Mensaje de notificación
    thresholds = {
      critical          = number           # Umbral crítico (requerido)
      warning           = number           # Umbral de warning (opcional)
      critical_recovery = number           # Umbral de recuperación crítica (opcional)
      warning_recovery  = number           # Umbral de recuperación de warning (opcional)
    }
    notify_no_data      = bool             # Notificar cuando no hay datos (default: false)
    no_data_timeframe   = number           # Minutos sin datos antes de notificar (default: 10)
    renotify_interval   = number           # Minutos entre re-notificaciones (default: 0)
    require_full_window = bool             # Requiere ventana completa (default: false)
    evaluation_delay    = number           # Segundos de retraso en evaluación (opcional)
    additional_tags     = list(string)     # Tags adicionales (default: [])
  }
}
```

## 📤 Outputs

| Nombre | Descripción | Tipo |
|--------|-------------|------|
| `monitor_ids` | Mapa de IDs de los monitors creados | `map(string)` |
| `monitor_names` | Mapa de nombres de los monitors creados | `map(string)` |
| `monitor_types` | Mapa de tipos de los monitors creados | `map(string)` |
| `monitor_queries` | Mapa de queries de los monitors creados | `map(string)` |
| `all_monitor_ids` | Lista de todos los IDs de monitors creados | `list(string)` |

## 📋 Requisitos

| Nombre | Versión |
|--------|---------|
| terraform | >= 1.0.0 |
| datadog | >= 3.0.0 |

## 🏗️ Tipos de Monitors Soportados

- `metric alert` - Alertas basadas en métricas
- `service check` - Verificaciones de estado de servicios
- `log alert` - Alertas basadas en logs
- `query alert` - Alertas basadas en queries personalizadas
- `composite` - Monitors compuestos
- `event alert` - Alertas basadas en eventos

## 🏷️ Sistema de Etiquetado

El módulo aplica automáticamente tags de gobernanza a todos los monitors:

```
managed_by:terraform
module:datadog-monitors
client:{client}
project:{project}
environment:{environment}
```

Además, puedes agregar tags específicos por monitor mediante `additional_tags`.

## 🔒 Mejores Prácticas

### Nomenclatura de Monitors

Los nombres de monitors deben seguir el patrón:
```
{client}-{project}-{environment}-monitor-{identificador}
```

Ejemplo: `pragma-ecommerce-dev-monitor-lambda-errors`

### Mensajes de Notificación

Incluye información contextual y menciones a canales de notificación:

```hcl
message = <<-EOT
  {{#is_alert}}
  🚨 ALERT: {{rule.name}}
  {{/is_alert}}
  
  Service: {{service.name}}
  Value: {{value}}
  
  @slack-critical @pagerduty-oncall
EOT
```

### Thresholds

- Define siempre un umbral `critical`
- Usa `warning` para alertas preventivas
- Configura `critical_recovery` y `warning_recovery` para evitar flapping

### No Data Alerts

Para métricas críticas, activa `notify_no_data`:

```hcl
notify_no_data    = true
no_data_timeframe = 10  # minutos
```

### Evaluation Delay

Para métricas de CloudWatch o con retraso, usa `evaluation_delay`:

```hcl
evaluation_delay = 300  # 5 minutos en segundos
```

## 📚 Cumplimiento de Reglas PC-IAC

Este módulo cumple con las siguientes reglas de gobernanza enterprise:

| Regla | Descripción | Implementación |
|-------|-------------|----------------|
| **PC-IAC-001** | Estructura de módulo | 18 archivos obligatorios (10 raíz + 8 sample/) |
| **PC-IAC-002** | Variables obligatorias | Variables `client`, `project`, `environment` con validaciones |
| **PC-IAC-003** | Nomenclatura estándar | Prefijo `{client}-{project}-{environment}` en locals |
| **PC-IAC-004** | Sistema de etiquetado | Tags de gobernanza + tags adicionales por monitor |
| **PC-IAC-005** | Providers con alias | Alias `datadog.project` para inyección desde Root |
| **PC-IAC-006** | Versiones y estabilidad | Pinning de provider Datadog >= 3.0.0 |
| **PC-IAC-007** | Outputs granulares | Outputs de IDs, nombres, tipos y queries |
| **PC-IAC-009** | Tipos de datos inteligentes | `map(object())` para `monitors_config` |
| **PC-IAC-010** | for_each obligatorio | Uso de `for_each` para múltiples monitors |
| **PC-IAC-012** | Estructuras en locals | Prefijo de gobernanza y tags base en locals |
| **PC-IAC-014** | Bloques dinámicos | Bloque `monitor_thresholds` dinámico |
| **PC-IAC-016** | Manejo de secretos | API keys no expuestas en el módulo |
| **PC-IAC-023** | Responsabilidad única | Solo crea recursos de Datadog monitors |
| **PC-IAC-025** | Nomenclatura en Root | Nombres completos inyectados desde Root |
| **PC-IAC-026** | Patrón sample/ | Ejemplo funcional con transformaciones en locals |

### Decisiones de Diseño

#### 1. Adaptación de Reglas AWS a Datadog

Las reglas PC-IAC fueron diseñadas para AWS, pero se adaptaron exitosamente a Datadog:

- **Provider Alias**: Se usa `datadog.project` en lugar de `aws.project`
- **Data Sources**: No aplican típicamente en Datadog, el archivo existe vacío
- **Hardenizado**: Se adapta a mejores prácticas de Datadog (thresholds, no_data, renotify)
- **Nomenclatura**: Se mantiene el patrón enterprise estándar

#### 2. Configuración de Thresholds

Se usa un objeto anidado para thresholds en lugar de bloques separados para:
- Facilitar la validación de configuración
- Permitir thresholds opcionales (warning, recovery)
- Mantener la configuración cohesiva

#### 3. Tags como Lista

Los tags de Datadog se manejan como lista de strings (`list(string)`) en lugar de mapa porque:
- Es el formato nativo de la API de Datadog
- Permite tags sin valor (ej: `severity:critical`)
- Facilita la concatenación de tags base + adicionales

#### 4. Nombres Completos desde Root

Siguiendo PC-IAC-025, los nombres de monitors vienen completos desde el Root:
- El módulo no construye nomenclatura internamente
- Facilita personalización de nombres por proyecto
- Reduce dependencias del módulo

## 📖 Ejemplos Adicionales

Ver el directorio `sample/` para un ejemplo funcional completo que demuestra:
- Configuración en `terraform.tfvars`
- Transformaciones en `locals.tf`
- Invocación del módulo en `main.tf`
- Uso de data sources para obtener información dinámica

## 🤝 Contribución

Para contribuir a este módulo:

1. Asegúrate de cumplir con todas las reglas PC-IAC
2. Actualiza el CHANGELOG.md
3. Agrega tests si introduces nueva funcionalidad
4. Actualiza la documentación

## 📄 Licencia

Este módulo es propiedad de [Organización] y está sujeto a las políticas internas de uso.

## 👥 Mantenedores

- Equipo de CloudOps
- Equipo de DevOps

## 📞 Soporte

Para soporte o preguntas sobre este módulo, contacta al equipo de CloudOps.

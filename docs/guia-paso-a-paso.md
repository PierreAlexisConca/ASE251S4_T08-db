# Guía paso a paso — ASE251S4_T08-db
## Implementación automatizada de bases de datos con Docker
### Proyecto AVSA Cañete — Team 08

---

## ¿Qué es este proyecto?

Este repositorio empaqueta las dos bases de datos del proyecto AVSA como
**imágenes Docker versionadas**. En lugar de ejecutar scripts manualmente,
cualquier integrante del equipo puede levantar todo el entorno de base de
datos con dos comandos, en cualquier computadora que tenga Docker instalado.

**Bases de datos del proyecto:**
- **SQL Server 2022** → datos transaccionales (pedidos, ventas, aplicaciones de campo, alertas, auditoría)
- **MongoDB 7** → datos maestros (clientes, productos, agroquímicos, notificaciones)

---

## Requisitos previos

Antes de comenzar, verificar que tienes instalado:

| Herramienta | Versión mínima | Verificación |
|---|---|---|
| Docker Desktop | 24.x o superior | `docker --version` |
| Git | cualquier versión reciente | `git --version` |

---

## Paso 1 — Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd ASE251S4_T08-db
```

Al clonar, obtienes esta estructura de carpetas:

```
ASE251S4_T08-db/
├── docs/                          documentación del proyecto
├── sqlserver/
│   ├── Dockerfile                 imagen de SQL Server
│   ├── docker/entrypoint.sh       script de arranque automático
│   └── init/                      scripts SQL numerados (01 al 08)
├── mongodb/
│   ├── Dockerfile                 imagen de MongoDB
│   └── init/                      scripts JS numerados (01 al 06)
├── .env.example                   plantilla de variables de entorno
└── README.md
```

---

## Paso 2 — Configurar las variables de entorno

Copiar el archivo de ejemplo y renombrarlo:

```bash
# En Windows PowerShell:
Copy-Item .env.example .env

# En Linux/Mac:
cp .env.example .env
```

El archivo `.env` contiene las contraseñas de los motores. Su contenido:

```env
# SQL Server
MSSQL_SA_PASSWORD=Avsa@Admin12345
SQLSERVER_PORT=1433

# MongoDB
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=Avsa@Admin12345
MONGODB_PORT=27017
```

> **Nota:** El archivo `.env` está en `.gitignore` y nunca se sube al repositorio
> para proteger las contraseñas.

---

## Paso 3 — Construir las imágenes Docker

Este paso toma los Dockerfiles y los scripts de `init/` y los empaqueta en
imágenes inmutables y versionadas.

### Construir imagen de SQL Server

```bash
docker build -t ase251s4-t08-sqlserver:1.0 ./sqlserver
```

Lo que hace internamente:
1. Parte de la imagen oficial `mcr.microsoft.com/mssql/server:2022-latest`
2. Copia los 8 scripts SQL de `sqlserver/init/` dentro de la imagen
3. Copia el `entrypoint.sh` que los ejecutará automáticamente al arrancar

### Construir imagen de MongoDB

```bash
docker build -t ase251s4-t08-mongodb:1.0 ./mongodb
```

Lo que hace internamente:
1. Parte de la imagen oficial `mongo:7`
2. Copia los 6 scripts JS de `mongodb/init/` en `/docker-entrypoint-initdb.d/`
3. MongoDB los ejecuta automáticamente en orden alfabético al primer arranque

### Verificar que las imágenes se crearon

```bash
docker images | grep ase251s4-t08
```

Salida esperada:
```
ase251s4-t08-mongodb     1.0    <id>   hace X min   800MB
ase251s4-t08-sqlserver   1.0    <id>   hace X min   1.6GB
```

---

## Paso 4 — Levantar los contenedores

### Levantar SQL Server

```bash
docker run -d \
  --name avsa-sqlserver \
  -p 1433:1433 \
  --env-file .env \
  ase251s4-t08-sqlserver:1.0
```

### Levantar MongoDB

```bash
docker run -d \
  --name avsa-mongodb \
  -p 27017:27017 \
  --env-file .env \
  ase251s4-t08-mongodb:1.0
```

### Verificar que ambos están corriendo

```bash
docker ps
```

Salida esperada:
```
CONTAINER ID   IMAGE                        PORTS                    NAMES
da0a9a679147   ase251s4-t08-mongodb:1.0     0.0.0.0:27017->27017    avsa-mongodb
d96f6f13ae10   ase251s4-t08-sqlserver:1.0   0.0.0.0:1433->1433      avsa-sqlserver
```

---

## Paso 5 — Verificar los logs de inicialización

### SQL Server

SQL Server tarda aproximadamente 1-2 minutos en iniciar por primera vez.
Esperar hasta ver el mensaje de éxito:

```bash
docker logs avsa-sqlserver 2>&1 | grep -E "INFO|SUCCESS"
```

Salida esperada (en orden):
```
[INFO] Esperando a que SQL Server este listo...
[INFO] SQL Server esta listo.
[INFO] Executing 01_database.sql
[INFO] Executing 02_schemas.sql
[INFO] Executing 03_tables.sql
[INFO] Executing 04_constraints.sql
[INFO] Executing 05_indexes.sql
[INFO] Executing 06_views.sql
[INFO] Executing 07_procedures.sql
[INFO] Executing 08_seed.sql
[SUCCESS] All initialization scripts executed.
```

Esto confirma que:
- La base de datos `avsa_db` fue creada ✅
- Las 11 tablas fueron creadas ✅
- Las FK y CHECK constraints fueron aplicadas ✅
- Los 15 índices fueron creados ✅
- Las 3 vistas fueron creadas ✅
- Los stored procedures fueron creados ✅
- Los datos de prueba fueron insertados ✅

### MongoDB

```bash
docker logs avsa-mongodb 2>&1 | grep -E "SUCCESS|INFO|RESULTADO"
```

Salida esperada:
```
[SUCCESS] Base de datos 'db_avsa' seleccionada.
[SUCCESS] Colecciones de db_avsa creadas correctamente.
[INFO] Validador customer aplicado.
[INFO] Validador productos aplicado.
[INFO] Validador agrochemicals aplicado.
[SUCCESS] Validadores aplicados correctamente.
[INFO] Indices customer creados.
[INFO] Indices productos creados.
[INFO] Indices agrochemicals creados.
[SUCCESS] Todos los indices creados correctamente.
[INFO] customer: 5 documentos insertados.
[INFO] productos: 5 documentos insertados.
[INFO] agrochemicals: 5 documentos insertados.
[SUCCESS] Seed de MongoDB ejecutado correctamente.
[RESULTADO Pipeline 1] Productos por categoria:
  - Cítricos | productos: 2 | precioPromedio: 87.5 | stockTotal: 780
  - Frutas   | productos: 3 | precioPromedio: 108.33 | stockTotal: 1050
[RESULTADO Pipeline 2] Ranking de fabricantes:
  - Syngenta | productos: 2 | categorias: INSECTICIDE, FUNGICIDE | diasEsperaPromedio: 17.5
  - Bayer CropScience | productos: 2 | categorias: HERBICIDE, FERTILIZER | diasEsperaPromedio: 7.5
[SUCCESS] Pipelines de agregacion verificados correctamente.
```

---

## Paso 6 — Verificar los datos directamente en la base de datos

### SQL Server — consultar tablas creadas

```bash
docker exec avsa-sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "Avsa@Admin12345" -C \
  -Q "USE avsa_db; SELECT name FROM sys.tables ORDER BY name;"
```

### SQL Server — consultar datos del seed

```bash
docker exec avsa-sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "Avsa@Admin12345" -C \
  -Q "USE avsa_db; SELECT username, role FROM dbo.app_users;"
```

### MongoDB — consultar colecciones y documentos

```bash
docker exec avsa-mongodb mongosh \
  -u admin -p "Avsa@Admin12345" --authenticationDatabase admin \
  --eval "db = db.getSiblingDB('db_avsa'); print(db.customer.countDocuments()); db.customer.find({},{razonSocial:1,tipoCliente:1}).forEach(printjson);"
```

---

## Descripción de los scripts de inicialización

### SQL Server (`sqlserver/init/`)

| Script | Qué hace |
|---|---|
| `01_database.sql` | Crea la base de datos `avsa_db` si no existe |
| `02_schemas.sql` | Documenta el schema `dbo` como punto formal de referencia |
| `03_tables.sql` | Crea las 11 tablas del proyecto con sus columnas y tipos |
| `04_constraints.sql` | Aplica FK entre tablas y CHECK de valores permitidos |
| `05_indexes.sql` | Crea 15 índices en las columnas de búsqueda más frecuente |
| `06_views.sql` | Crea 3 vistas: pedidos activos, alertas pendientes, aplicaciones de campo |
| `07_procedures.sql` | Crea stored procedures: soft delete, restore y resumen de pedidos |
| `08_seed.sql` | Inserta datos de prueba en todas las tablas (usuarios, agroquímicos, productores, etc.) |

### MongoDB (`mongodb/init/`)

| Script | Qué hace |
|---|---|
| `01_database.js` | Selecciona la base de datos `db_avsa` |
| `02_collections.js` | Crea explícitamente las 6 colecciones del proyecto |
| `03_validators.js` | Aplica validadores de esquema JSON a customer, productos y agrochemicals |
| `04_indexes.js` | Crea índices optimizados en todas las colecciones |
| `05_seed.js` | Inserta 5 clientes, 5 productos, 5 agroquímicos y 3 notificaciones |
| `06_aggregations.js` | Verifica y ejecuta los 2 pipelines de agregación del proyecto |

---

## Arquitectura de persistencia poliglota

El proyecto usa dos motores, cada uno donde tiene ventaja:

```
┌─────────────────────────────────────────────────────────┐
│                     AVSA Cañete                         │
│                                                         │
│   SQL Server 2022          MongoDB 7                    │
│   (Transacciones)          (Maestros)                   │
│                                                         │
│   • customer_orders        • customer                   │
│   • field_applications     • productos                  │
│   • inventory_deliveries   • agrochemicals              │
│   • alerts                 • notificaciones             │
│   • audit_logs             • dashboard_metrics          │
│   • producers / fields                                  │
└─────────────────────────────────────────────────────────┘
```

La referencia entre motores es **lógica**: `customer_orders.customer_id`
guarda el `_id` de MongoDB como texto (`NVARCHAR(50)`), sin FK física.
La validación de integridad ocurre en el backend Spring WebFlux.

---

## Comandos de mantenimiento

```bash
# Detener los contenedores
docker stop avsa-sqlserver avsa-mongodb

# Iniciar nuevamente
docker start avsa-sqlserver avsa-mongodb

# Eliminar contenedores (los datos se pierden)
docker rm -f avsa-sqlserver avsa-mongodb

# Eliminar imágenes
docker rmi ase251s4-t08-sqlserver:1.0 ase251s4-t08-mongodb:1.0

# Ver logs en tiempo real
docker logs -f avsa-sqlserver
docker logs -f avsa-mongodb
```

---

## Datos de conexión para herramientas externas

### SQL Server (DBeaver, SSMS, Azure Data Studio)
- **Host:** `localhost`
- **Puerto:** `1433`
- **Usuario:** `sa`
- **Contraseña:** `Avsa@Admin12345`
- **Base de datos:** `avsa_db`

### MongoDB (Compass, mongosh)
- **URI:** `mongodb://admin:Avsa@Admin12345@localhost:27017/?authSource=admin`
- **Base de datos:** `db_avsa`

---

*Documento elaborado por el equipo T08 — AVSA Cañete*
*Curso: Arquitectura de Software Empresarial — Valle Grande*

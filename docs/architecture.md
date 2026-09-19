# Arquitectura del repositorio ASE251S4_T08-db

## Persistencia poliglota

El proyecto AVSA Cañete utiliza dos motores de base de datos, cada uno
especializado en el tipo de información que administra:

- **SQL Server**: información transaccional y relacional, donde la
  integridad referencial y las transacciones ACID son críticas (pedidos
  de clientes, ventas, entregas de inventario, aplicaciones de campo,
  auditoría).
- **MongoDB**: información de catálogo y maestros con esquema flexible,
  donde los documentos requieren lectura frecuente y estructura variable
  (clientes, productos, agroquímicos, notificaciones, métricas de dashboard).

Las tecnologías se separan por carpetas físicas (`sqlserver/`, `mongodb/`),
pero se unifican bajo un único ecosistema de control de versiones (este
mismo repositorio Git), siguiendo la estrategia GitFlow institucional
(rama `develop` para el desarrollo activo del equipo).

## Infraestructura como código

En lugar de entregar scripts sueltos, cada motor de base de datos se
empaqueta como una **imagen Docker independiente y versionada**:

1. **Materia prima**: el `Dockerfile` de cada motor, más su carpeta
   `init/` con los scripts ordenados por dependencias.
2. **Build**: `docker build` fusiona esos scripts con la imagen base
   oficial del motor (`mssql/server:2022` o `mongo:7`).
3. **Imagen**: el resultado es un artefacto sólido, versionado e
   inmutable (ej. `ase251s4-t08-sqlserver:1.0`).
4. **Contenedor**: `docker run` levanta instancias operativas idénticas
   a partir de esa imagen, en cualquier entorno donde se necesite.

## Orden de ejecución de los scripts

Los scripts dentro de cada carpeta `init/` se numeran para que se
ejecuten respetando sus dependencias bloqueantes:

**SQL Server:**
`01_database.sql` → `02_schemas.sql` → `03_tables.sql` → `04_constraints.sql`
(bloqueado hasta que existan las tablas) → `05_indexes.sql` → `06_views.sql`
→ `07_procedures.sql` → `08_seed.sql`

**MongoDB:**
`01_database.js` → `02_collections.js` → `03_validators.js` → `04_indexes.js`
(bloqueado hasta que existan las colecciones) → `05_seed.js` → `06_aggregations.js`

## Verificación de la plataforma

Una plataforma se considera correctamente implementada cuando cumple,
para ambos motores:

| Criterio de éxito | SQL Server | MongoDB |
|---|---|---|
| Imagen construida exitosamente | ✔ | ✔ |
| Contenedor instanciado y creado | ✔ | ✔ |
| Motor de base de datos activo | ✔ | ✔ |
| Scripts ejecutados lógicamente | ✔ | ✔ |
| Datos iniciales consultables | ✔ | ✔ |

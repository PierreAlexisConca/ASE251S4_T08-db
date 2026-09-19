# ASE251S4_T08-db

Implementación automatizada (como código) de las bases de datos del proyecto
**AVSA Cañete**, usando persistencia poliglota: **SQL Server** para datos
transaccionales y **MongoDB** para datos de catálogo con esquema flexible.

## Estructura

```
ASE251S4_T08-db/
├── docs/
│   ├── architecture.md        Arquitectura general y justificación
│   └── data-ownership.md      Matriz de propiedad de datos (qué va en cada motor)
├── sqlserver/
│   ├── Dockerfile
│   ├── docker/
│   │   └── entrypoint.sh      Arranca SQL Server y ejecuta los scripts de init/
│   └── init/                  Scripts SQL, ejecutados en orden 01 -> 08
├── mongodb/
│   ├── Dockerfile
│   └── init/                  Scripts JS, ejecutados en orden 01 -> 06
├── .env.example
└── .gitignore
```

## Cómo construir las imágenes

```bash
docker build -t ase251s4-t08-sqlserver:1.0 ./sqlserver
docker build -t ase251s4-t08-mongodb:1.0 ./mongodb
```

## Cómo correr los contenedores

Copia `.env.example` a `.env` y completa tus contraseñas, luego:

```bash
docker run -d --name avsa-sqlserver -p 1433:1433 --env-file .env ase251s4-t08-sqlserver:1.0
docker run -d --name avsa-mongodb -p 27017:27017 --env-file .env ase251s4-t08-mongodb:1.0
```

## Verificar que todo quedó corriendo

```bash
docker ps
docker logs avsa-sqlserver
docker logs avsa-mongodb
```

## Datos de conexión (desarrollo local)

- SQL Server: `localhost:1433`, base de datos `avsa_db`
- MongoDB: `localhost:27017`, base de datos `db_avsa`

## Documentación adicional

- [Arquitectura del proyecto](docs/architecture.md)
- [Matriz de propiedad de datos](docs/data-ownership.md)

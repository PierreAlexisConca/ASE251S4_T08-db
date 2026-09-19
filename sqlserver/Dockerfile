# =========================================
# Dockerfile - SQL Server (AVSA Cañete)
# =========================================
FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
# La contraseña real se pasa por variable de entorno al correr el contenedor
# (ver .env.example), nunca se deja escrita aqui.
ENV MSSQL_PID=Express

USER root

# Copia los scripts de inicializacion, en orden de dependencias
COPY init/ /init/
COPY docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 1433

ENTRYPOINT ["/entrypoint.sh"]

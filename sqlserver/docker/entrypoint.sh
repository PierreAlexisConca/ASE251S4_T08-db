#!/bin/bash
set -e

# Arranca SQL Server en segundo plano
/opt/mssql/bin/sqlservr &

# Espera hasta que SQL Server acepte conexiones
echo "[INFO] Esperando a que SQL Server este listo..."
for i in {1..60}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1" > /dev/null 2>&1; then
        echo "[INFO] SQL Server esta listo."
        break
    fi
    sleep 1
done

# Ejecuta cada script .sql dentro de /init en orden alfabetico (01_, 02_, 03_...)
for script in /init/*.sql; do
    echo "[INFO] Executing $(basename "$script")"
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -i "$script"
done

echo "[SUCCESS] All initialization scripts executed."

# Mantiene el contenedor vivo en primer plano
wait

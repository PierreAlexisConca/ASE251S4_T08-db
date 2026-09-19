# =========================================
# Dockerfile - MongoDB (AVSA Cañete)
# =========================================
FROM mongo:7

# La imagen oficial de Mongo ejecuta automaticamente, en orden alfabetico,
# cualquier script .js que encuentre en /docker-entrypoint-initdb.d/
# la PRIMERA vez que el contenedor arranca con el volumen de datos vacio.
COPY init/*.js /docker-entrypoint-initdb.d/

EXPOSE 27017

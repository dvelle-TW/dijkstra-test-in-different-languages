# Usar Debian como base
FROM debian:stable-slim

# Instalar Free Pascal y otras utilidades necesarias
RUN apt-get update && \
    apt-get install -y --no-install-recommends fpc && \
    rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar el archivo de código fuente al contenedor
COPY Dijkstra.pas .

# Compilar el archivo de código fuente
RUN fpc Dijkstra.pas

# Ejecutar el programa compilado
CMD ["./Dijkstra"]

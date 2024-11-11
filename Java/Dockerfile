# Usar una imagen de base que tenga JDK 17
FROM openjdk:17-slim

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar el código fuente al contenedor
COPY Dijkstra.java .

# Compilar el código Java
RUN javac Dijkstra.java

# Ejecutar el programa
CMD ["java", "Dijkstra"]
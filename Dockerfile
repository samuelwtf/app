# Etapa de construcción
FROM python:3.12-slim AS builder

WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y curl unzip git && \
    apt-get clean

# Instalar Reflex
RUN pip install reflex

# Copiar el código de la app
COPY . .

# Ejecutar Reflex en modo producción (compila frontend y backend)
RUN reflex run --env prod --frontend-only
RUN reflex run --env prod --backend-only

# Etapa final
FROM python:3.12-slim

WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y curl unzip git && \
    apt-get clean

# Instalar Reflex nuevamente
RUN pip install reflex

# Copiar la app desde el builder
COPY --from=builder /app /app

# Exponer puertos necesarios
EXPOSE 3000 8000

# Ejecutar Reflex (modo producción)
CMD ["reflex", "run", "--env", "prod"]

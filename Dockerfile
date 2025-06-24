# Etapa de construcción
FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y curl unzip git && apt-get clean

# Instalar Reflex
RUN pip install reflex

# Copiar código fuente
COPY . .

# Inicializar app y compilar producción
RUN reflex init
RUN reflex run --env prod --backend-only
RUN reflex run --env prod --frontend-only

# Etapa final
FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl unzip git && apt-get clean

# Instalar Reflex
RUN pip install reflex

# Copiar app compilada
COPY --from=builder /app /app

# Exponer puertos
EXPOSE 3000 8000

# Iniciar en producción
CMD ["reflex", "run", "--env", "prod"]

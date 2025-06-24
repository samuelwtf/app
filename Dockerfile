# Build stage
FROM python:3.11-slim AS builder

WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Instalar Reflex
RUN curl -sSL https://reflex.dev/install.sh | bash

# Asegurar que el binario esté disponible
ENV PATH="/root/.reflex/bin:$PATH"

# Copiar tu app
COPY . .

# Build de la app (modo producción)
RUN reflex export --production

# Final stage
FROM python:3.11-slim

WORKDIR /app

# Copiar archivos exportados desde el build stage
COPY --from=builder /app/dist /app

# Instalar gunicorn para correr el servidor (si es necesario)
RUN pip install gunicorn

# Exponer el puerto de Reflex
EXPOSE 3000

# Comando para iniciar el servidor Reflex
CMD ["reflex", "run", "--backend-only", "--env", "production"]

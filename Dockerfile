# -------- BUILD STAGE --------
FROM python:3.12-slim AS builder

WORKDIR /app

# Instalar dependencias necesarias (incluye unzip)
RUN apt-get update && \
    apt-get install -y curl unzip git && \
    pip install --no-cache-dir reflex && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar el proyecto
COPY . .

# Exportar la app para producción
RUN reflex export --env prod

# -------- FINAL STAGE --------
FROM node:20-alpine AS runner

# Instalar http-server
RUN npm install -g http-server

WORKDIR /web

# Copiar archivos exportados
COPY --from=builder /app/web/_export/ .

EXPOSE 3000

CMD ["http-server", ".", "-p", "3000"]

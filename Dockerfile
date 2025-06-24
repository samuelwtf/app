# ---------------- BUILDER ----------------
FROM python:3.12-slim AS builder

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y curl unzip build-essential git && \
    apt-get clean

# Instalar Reflex
RUN pip install reflex

# Crear carpeta de trabajo
WORKDIR /app

# Copiar todo el código del proyecto
COPY . .

# Exportar la app en modo producción
RUN reflex export --env prod

# ---------------- RUNNER ----------------
FROM node:20-slim AS runner

# Instalar servidor para servir frontend
RUN npm install -g http-server

WORKDIR /app

# Copiar la exportación desde el builder (correcto con Reflex v0.4+)
COPY --from=builder /app/.web/_export/ .

# Exponer los puertos de frontend (3000) y backend (8000)
EXPOSE 3000 8000

# Ejecutar ambos servicios
CMD ["sh", "-c", "python3 -m http.server 8000 & http-server . -p 3000"]

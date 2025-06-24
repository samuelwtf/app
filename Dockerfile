# ---------------- BUILDER ----------------
FROM python:3.12-slim AS builder

# Instalar dependencias del sistema necesarias
RUN apt-get update && \
    apt-get install -y curl unzip build-essential git && \
    apt-get clean

# Instalar Reflex
RUN pip install reflex

# Crear directorio de la app
WORKDIR /app

# Copiar el código de la app
COPY . .

# Exportar la app en modo producción (esto genera web/_export)
RUN reflex export --env prod

# ---------------- RUNTIME ----------------
FROM node:20-slim AS runner

# Instalar http-server globalmente para servir frontend
RUN npm install -g http-server

WORKDIR /app

# Copiar archivos exportados desde el builder
COPY --from=builder /app/web/_export/ .

# Exponer los puertos del backend y frontend
EXPOSE 3000 8000

# Iniciar ambos servidores (frontend y backend)
CMD ["sh", "-c", "python -m http.server 8000 & http-server . -p 3000"]

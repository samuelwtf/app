# -------- BUILD STAGE --------
FROM python:3.12-slim AS builder

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y curl unzip git

# Instalar bun (gestor de paquetes JS que usa Reflex)
RUN curl -fsSL https://bun.sh/install | bash && \
    ln -s /root/.bun/bin/bun /usr/local/bin/bun

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias de Python
RUN pip install --upgrade pip && pip install reflex

# Compilar para producción
RUN reflex export --env prod

# -------- FINAL STAGE --------
FROM node:20-alpine AS runner

# Instalar http-server para servir frontend
RUN npm install -g http-server

WORKDIR /web

# Copiar archivos exportados desde el builder
COPY --from=builder /app/.web/_export/ .

# Exponer puerto 3000 para la web
EXPOSE 3000

# Comando para iniciar el servidor
CMD ["http-server", ".", "-p", "3000"]

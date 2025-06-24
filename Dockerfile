# -------- BUILD STAGE --------
FROM python:3.12-slim AS builder

WORKDIR /app

# Instalar Reflex
RUN pip install --no-cache-dir reflex

# Copiar tu proyecto
COPY . .

# Compilar para producción
RUN reflex export --env prod

# -------- FINAL STAGE --------
FROM node:20-alpine AS runner

# Instalar http-server
RUN npm install -g http-server

WORKDIR /web

# Copiar los archivos exportados
COPY --from=builder /app/web/_export/ .

# Exponer el puerto en el que servirá la app
EXPOSE 3000

# Iniciar el servidor estático
CMD ["http-server", ".", "-p", "3000"]

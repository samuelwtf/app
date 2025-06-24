# -------- STAGE 1: Build --------
FROM python:3.12-slim AS builder

# Instalar dependencias necesarias del sistema
RUN apt-get update && apt-get install -y curl unzip git build-essential

# Instalar Bun para manejar frontend (lo requiere Reflex)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# Crear y movernos al directorio de la app
WORKDIR /app

# Copiar dependencias y el código fuente
COPY . .

# Instalar Reflex
RUN pip install reflex

# Inicializar y exportar la app en modo producción
RUN reflex export --env prod

# -------- STAGE 2: Runtime --------
FROM python:3.12-slim

# Instalar servidor estático
RUN pip install httpserver

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos exportados desde el builder
COPY --from=builder /app/.web/_export/ .

# Exponer puertos para backend y frontend
EXPOSE 8000
EXPOSE 3000

# Comando de arranque en producción
CMD ["httpserver", "."]

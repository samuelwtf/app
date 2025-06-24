# Etapa de construcción
FROM python:3.12-slim AS builder

WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y curl unzip git && apt-get clean

# Instalar Reflex
RUN pip install reflex

# Copiar tu código
COPY . .

# Establecer la ruta correcta a tu app
ENV REFLEX_APP=app.app.app

# Inicializar y exportar para producción
RUN reflex init
RUN reflex export --env prod

# Etapa final
FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl unzip git && apt-get clean
RUN pip install reflex

# Establecer la ruta correcta a tu app
ENV REFLEX_APP=app.app.app

# Copiar archivos exportados
COPY --from=builder /app/.web/_export/ .

# Exponer los puertos
EXPOSE 3000 8000

# Ejecutar en producción
CMD ["reflex", "run", "--env", "prod"]

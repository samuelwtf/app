FROM python:3.12-slim

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unzip \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Instalar Reflex
RUN pip install --no-cache-dir reflex

# Exponer el puerto que usa Reflex
EXPOSE 3000

# Ejecutar Reflex en modo producción
CMD ["reflex", "run", "--env", "prod"]

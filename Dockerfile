FROM python:3.11-slim

WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements e instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la aplicación
COPY . .

# Inicializar Reflex (instala dependencias de Node.js)
RUN reflex init

# Compilar la aplicación para producción
RUN reflex export --frontend-only

# Exponer puertos
EXPOSE 3000
EXPOSE 8000

# Comando para ejecutar en producción
CMD ["reflex", "run", "--env", "prod", "--port", "3000", "--backend-port", "8000"]

FROM python:3.11-slim

WORKDIR /app

# Instalar todas las dependencias del sistema necesarias para Reflex
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    zip \
    build-essential \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verificar instalaciones
RUN node --version && npm --version && unzip -v

# Copiar requirements e instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la aplicación
COPY . .

# Inicializar Reflex (instala Bun y dependencias de Node.js)
RUN reflex init

# Compilar la aplicación para producción
RUN reflex export --frontend-only

# Exponer puertos
EXPOSE 3000
EXPOSE 8000

# Comando para ejecutar en producción
FROM python:3.11-slim

WORKDIR /app

# Instalar todas las dependencias del sistema necesarias para Reflex
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    zip \
    build-essential \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verificar instalaciones
RUN node --version && npm --version && unzip -v

# Copiar requirements e instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código de la aplicación
COPY . .

# Inicializar Reflex (instala Bun y dependencias de Node.js)
RUN reflex init

# Compilar la aplicación para producción
RUN reflex export --frontend-only

# Exponer puertos
EXPOSE 3000
EXPOSE 8000

# Comando para ejecutar en producción
CMD ["reflex", "run"]

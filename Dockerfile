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
    nginx \
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

# Configurar nginx para proxy del backend
RUN echo 'server { \
    listen 3000; \
    location / { \
        proxy_pass http://127.0.0.1:3001; \
        proxy_http_version 1.1; \
        proxy_set_header Upgrade $http_upgrade; \
        proxy_set_header Connection "upgrade"; \
        proxy_set_header Host $host; \
        proxy_set_header X-Real-IP $remote_addr; \
    } \
    location /_event { \
        proxy_pass http://127.0.0.1:8000; \
        proxy_http_version 1.1; \
        proxy_set_header Upgrade $http_upgrade; \
        proxy_set_header Connection "upgrade"; \
        proxy_set_header Host $host; \
        proxy_set_header X-Real-IP $remote_addr; \
    } \
    location /api/ { \
        proxy_pass http://127.0.0.1:8000; \
        proxy_set_header Host $host; \
        proxy_set_header X-Real-IP $remote_addr; \
    } \
}' > /etc/nginx/sites-available/default

# Exponer solo el puerto 3000 (nginx hará el proxy interno)
EXPOSE 3000

# Crear script de inicio que ejecuta nginx y reflex
RUN echo '#!/bin/bash\nnginx -g "daemon off;" &\nreflex run --env prod --backend-port 8000 --frontend-port 3001' > /app/start.sh && \
    chmod +x /app/start.sh

CMD ["/app/start.sh"]

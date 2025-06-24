# Etapa base con Python 3.12
FROM python:3.12-slim

# Añadir Reflex al PATH
ENV PATH="/root/.reflex/bin:$PATH"
WORKDIR /app

# Instalar dependencias del sistema y Reflex CLI
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/* && \
    curl -sSL https://reflex.dev/install.sh | bash

# Copiar el código fuente de la app
COPY . .

# Compilar la app para producción
RUN reflex export --production

# Instalar servidor WSGI Gunicorn
RUN pip install gunicorn

# Exponer el puerto estándar para Reflex
EXPOSE 3000

# Ejecutar la app (usa el objeto `app` del archivo app.py)
CMD ["gunicorn", "--bind", "0.0.0.0:3000", "app:app"]

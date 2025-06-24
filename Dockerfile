FROM python:3.12-slim

# Crear y establecer directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Instalar unzip y curl para poder instalar bun
RUN apt-get update && apt-get install -y unzip curl

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Ejecutar reflex export para compilar frontend/backend
RUN reflex export

# Cambiar al directorio exportado
WORKDIR /app/.web

# Instalar Gunicorn
RUN pip install gunicorn

# Ejecutar la app con Gunicorn
#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.app:app"]
CMD ["gunicorn", "web.app.app:app", "--bind", "0.0.0.0:8000"]


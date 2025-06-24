FROM python:3.12-slim

WORKDIR /app/.web

# Copiar archivos
COPY . .

# Instalar unzip y curl para permitir la instalación de bun (frontend)
RUN apt-get update && apt-get install -y unzip curl

# Instalar dependencias Python
RUN pip install --no-cache-dir -r requirements.txt

# Exportar la app (compila frontend y backend)
RUN reflex export

# Instalar Gunicorn para servir FastAPI
RUN pip install gunicorn

# Comando para iniciar el servidor
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.app:app"]

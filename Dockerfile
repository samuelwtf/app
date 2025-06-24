FROM python:3.12-slim

WORKDIR /app

# Copiar archivos
COPY . .

# Instalar unzip para que Reflex pueda descargar bun
RUN apt-get update && apt-get install -y unzip

# Instalar dependencias Python
RUN pip install --no-cache-dir -r requirements.txt

# Exportar la app (compila frontend y backend)
RUN reflex export

# Instalar Gunicorn para servir FastAPI
RUN pip install gunicorn

# Comando para iniciar el servidor
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "reflex_export.app:app"]

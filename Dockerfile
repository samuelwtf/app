FROM python:3.12-slim

ENV PATH="/root/.local/bin:$PATH"
WORKDIR /app

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Instalar Reflex usando pip directamente
RUN pip install reflex

# Copiar el código de la app
COPY . .

# Exportar la app para producción
RUN reflex export --production

# Instalar gunicorn para servir la app
RUN pip install gunicorn

EXPOSE 8000

# Ejecutar la app desde el archivo app.py
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]

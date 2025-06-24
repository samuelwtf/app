FROM python:3.12-slim

WORKDIR /app

# Copiar archivos
COPY . .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Exportar la app (sin la opción incorrecta)
RUN reflex export

# Instalar gunicorn para servir FastAPI
RUN pip install gunicorn

# Servir el backend generado por Reflex
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "reflex_export.app:app"]

FROM python:3.12-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Exportar la app estática para producción
RUN reflex export --no-frontend

# Instalar gunicorn para servir FastAPI
RUN pip install gunicorn

# Comando para servir FastAPI app generado por Reflex
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "reflex_export.app:app"]

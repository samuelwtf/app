FROM python:3.12-slim

ENV PATH="/root/.local/bin:$PATH"
WORKDIR /app

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Instalar Reflex desde pip
RUN pip install reflex

# Copiar el código fuente
COPY . .

# Exportar la app
RUN reflex export

# Instalar gunicorn para servir la app
RUN pip install gunicorn

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.app:app"]

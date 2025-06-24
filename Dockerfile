# Etapa base con Python
FROM python:3.12-slim

# Instala unzip y curl (necesarios para instalar bun)
RUN apt-get update && apt-get install -y curl unzip

# Instala Reflex
RUN pip install reflex

# Crea el directorio de trabajo
WORKDIR /app

# Copia todo el código
COPY . .

# Establece el entrypoint si tu archivo raíz está en app/app/app.py
ENV REFLEX_ENTRYPOINT=app/app/app.py

# Expone los puertos: 8000 (backend/ws) y 3000 (frontend)
EXPOSE 3000 8000

# Ejecuta en modo producción (con FastAPI + WebSocket)
#CMD ["reflex", "run", "--env", "prod"]
CMD ["python3", "-m", "reflex", "run", "--env", "prod"]

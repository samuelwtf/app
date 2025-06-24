FROM python:3.12-slim

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Verifica que npm y node están instalados
RUN node -v && npm -v

# Establece el directorio de trabajo
WORKDIR /app

# Copia archivos del proyecto
COPY . .

# Instala dependencias Python
RUN pip install --no-cache-dir reflex

# Expone el puerto
EXPOSE 3000

# Ejecuta Reflex
CMD ["reflex", "run", "--env", "production"]

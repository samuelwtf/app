FROM python:3.12-slim

# Instala Node.js (npm)
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Verifica que npm y node están instalados
RUN node -v && npm -v

# Establece directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto
COPY . .

# Instala Reflex
RUN pip install --no-cache-dir reflex

# Expone el puerto predeterminado de Reflex
EXPOSE 3000

# Comando de inicio (modo producción)
CMD ["reflex", "run", "--env", "prod"]

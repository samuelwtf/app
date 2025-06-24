# Usa la imagen base de Python 3.12 (versión slim para menor tamaño)
FROM python:3.12-slim-bookworm

# Establece el directorio de trabajo base dentro del contenedor
WORKDIR /app

# Actualiza los índices de paquetes e instala las dependencias del sistema necesarias
RUN apt-get update && \
    apt-get install -y unzip curl && \
    rm -rf /var/lib/apt/lists/*

# Copia el archivo de requisitos e instala las dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Instala gunicorn explícitamente para asegurar que esté en el PATH
RUN pip install gunicorn==21.2.0

# Copia todo el código de tu aplicación al contenedor
# Esto copiará app.py, rxconfig.py, etc., directamente a /app
COPY . .

# Exporta la aplicación Reflex para producción
# Reflex ahora encuentra app.py y rxconfig.py en el WORKDIR /app
RUN reflex export --frontend-only

# Expone el puerto 8000, que es donde Gunicorn (el servidor de Python) escuchará
EXPOSE 8000

# Comando para ejecutar la aplicación Reflex usando Gunicorn
# La ruta 'app:app' es correcta porque app.py está en la raíz del WORKDIR /app
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", "app:app", "--access-logfile", "-", "--error-logfile", "-"]

# Usa la imagen base de Python 3.12 (versión slim para menor tamaño)
FROM python:3.12-slim

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Actualiza los índices de paquetes e instala las dependencias del sistema necesarias
# 'unzip' es para que Reflex pueda descomprimir archivos (ej. Bun)
# 'curl' es para que Reflex pueda descargar archivos (ej. scripts de instalación como Bun)
RUN apt-get update && \
    apt-get install -y unzip curl && \
    rm -rf /var/lib/apt/lists/*

# Copia el archivo de requisitos e instala las dependencias de Python
# '--no-cache-dir' reduce el tamaño de la imagen final al no guardar el caché de pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código de tu aplicación al contenedor
COPY . .

# Inicializa y exporta la aplicación Reflex para producción
# El comando `reflex init` prepara la aplicación.
# El comando `reflex export --frontend-only` construye el frontend estático.
# Asegúrate de que 'tu_app_nombre' es el nombre real de tu módulo principal de Reflex.
# Por ejemplo, si tu aplicación principal es `my_project/my_project.py`, tu_app_nombre es `my_project`.
RUN reflex init
RUN reflex export --frontend-only

# Expone el puerto 8000, que es donde Gunicorn (el servidor de Python) escuchará
EXPOSE 8000

# Comando para ejecutar la aplicación Reflex usando Gunicorn
# Gunicorn servirá el backend de Reflex. Asegúrate de reemplazar 'tu_app_nombre.rx:app'
# con la ruta correcta a la instancia de tu objeto 'app' de Reflex.
# Si tu app principal está en `myapp

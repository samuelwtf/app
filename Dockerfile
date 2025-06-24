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

# Copia el resto del código de tu aplicación al contenedor
# Esto copiará 'src' y todo lo demás a /app
COPY . .

# Elimina cualquier rastro de la configuración predeterminada de Reflex si existe
# y luego cambia el directorio de trabajo a la carpeta 'src'
# antes de ejecutar los comandos de Reflex.
RUN rm -rf .reflex && rm -rf .web
WORKDIR /app/src

# Exporta la aplicación Reflex para producción
# ¡IMPORTANTE! Usamos --app para especificar la ubicación de tu aplicación
# 'app' es el nombre del archivo (app.py) dentro de src/.
RUN reflex export --frontend-only --app app

# Vuelve al directorio raíz de la app para el CMD de Gunicorn
# Gunicorn espera la ruta del módulo desde /app
WORKDIR /app

# Expone el puerto 8000, que es donde Gunicorn (el servidor de Python) escuchará
EXPOSE 8000

# Comando para ejecutar la aplicación Reflex usando Gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", "src.app:app", "--access-logfile", "-", "--error-logfile", "-"]

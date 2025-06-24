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

# Elimina cualquier rastro de la configuración de Reflex si existe
RUN rm -rf .reflex && rm -rf .web

# *** CAMBIO CRUCIAL: Mantenemos el WORKDIR en /app para el export ***
# Esto es vital para que Reflex exporte correctamente
# y encuentre los archivos en la estructura esperada por rxconfig.py.
# El error 'app.app' sugiere que Reflex necesita la vista desde la raíz del proyecto.
# Ya no necesitamos un WORKDIR /app/src para el export.
# Simplemente nos aseguramos que el rxconfig.py de la raíz apunte al módulo correcto.

# Exporta la aplicación Reflex para producción
# Reflex ahora buscará la app basándose en rxconfig.py.
# Ya no se necesitan argumentos de ruta explícitos para export.
RUN reflex export --frontend-only

# Expone el puerto 8000, que es donde Gunicorn (el servidor de Python) escuchará
EXPOSE 8000

# Comando para ejecutar la aplicación Reflex usando Gunicorn
# La ruta 'src.app:app' sigue siendo correcta aquí.
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", "src.app:app", "--access-logfile", "-", "--error-logfile", "-"]

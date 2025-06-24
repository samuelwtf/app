# Usar una imagen base de Python
FROM python:3.10-slim-buster

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo de requisitos e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de tu código de aplicación
COPY . .

# Build the Reflex app for production
# Esto asume que tu app Reflex está en la raíz del proyecto o en una subcarpeta como 'your_app_name'
# Ajusta 'tu_app_nombre' al nombre real de tu módulo principal de Reflex (e.g., 'myapp')
RUN reflex init
RUN reflex export --frontend-only --zip-path /tmp/frontend.zip

# Instalar un servidor web de producción como Gunicorn para servir el backend
RUN pip install gunicorn==21.2.0 websockets==10.4

# Expone el puerto que usará Gunicorn para el backend
# Reflex por defecto corre su backend en 8000
EXPOSE 8000

# Comando para ejecutar la aplicación
# Sirve el backend de Reflex con Gunicorn y el frontend exportado
CMD gunicorn --workers 4 --bind 0.0.0.0:8000 tu_app_nombre.reflex_app_instance:app --access-logfile - --error-logfile - && python -m http.server 3000 --directory public
# Nota: El comando CMD de arriba es una simplificación.
# En un entorno de Coolify, generalmente configurarías dos servicios separados
# si Reflex necesita servir el frontend y el backend en puertos diferentes y separados.
# Para Coolify con un solo contenedor, la forma más común es que el backend de Reflex
# sirva los archivos estáticos del frontend.
# Una mejor aproximación para Coolify de un solo servicio sería:
# 1. Asegurarte de que tu Reflex app sirva los archivos estáticos desde el backend.
#    (Reflex lo hace automáticamente cuando se exporta).
# 2. Exponer un solo puerto (e.g., 8000) y que Gunicorn sirva todo.

# **Versión más sencilla y común para Coolify (Gunicorn sirviendo la app Reflex completa):**
# FROM python:3.10-slim-buster
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# COPY . .
# RUN reflex init
# RUN reflex export --frontend-only
# RUN pip install gunicorn==21.2.0
# EXPOSE 8000
# CMD gunicorn --workers 4 --bind 0.0.0.0:8000 tu_app_nombre.rx:app --access-logfile - --error-logfile -
# Reemplaza 'tu_app_nombre.rx:app' con la ruta a tu objeto 'app' de Reflex.
# Si tu app principal está en `myapp/myapp.py` y el objeto es `app`, sería `myapp.myapp:app`.
# Generalmente es `tu_modulo_principal.tu_instancia_de_app_reflex` (e.g., `mi_app.mi_app:app`)

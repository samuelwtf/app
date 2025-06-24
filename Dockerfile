# Usar una imagen base de Python
FROM python:3.10-slim-buster

# Establecer el directorio de trabajo
WORKDIR /app

# **NUEVA LÍNEA: Instalar unzip**
# Es buena práctica también actualizar los índices de paquetes antes de instalar.
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Copiar el archivo de requisitos e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de tu código de aplicación
COPY . .

# Build the Reflex app for production
# Esto asume que tu app Reflex está en la raíz del proyecto o en una subcarpeta como 'your_app_name'
# Ajusta 'tu_app_nombre' al nombre real de tu módulo principal de Reflex (e.g., 'myapp')
RUN reflex init
RUN reflex export --frontend-only

# Instalar gunicorn si no está en requirements.txt
# RUN pip install gunicorn==21.2.0

# Expone el puerto que usará Gunicorn para el backend
# Reflex por defecto corre su backend en 8000
EXPOSE 8000

# Comando para ejecutar la aplicación
# Reemplaza 'tu_app_nombre.rx:app' con la ruta a tu objeto 'app' de Reflex.
# Si tu app principal está en `myapp/myapp.py` y el objeto es `app`, sería `myapp.myapp:app`.
# Generalmente es `tu_modulo_principal.tu_instancia_de_app_reflex` (e.g., `mi_app.mi_app:app`)
CMD gunicorn --workers 4 --bind 0.0.0.0:8000 tu_app_nombre.rx:app --access-logfile - --error-logfile -

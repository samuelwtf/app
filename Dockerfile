# Usa la imagen base de Python 3.12 (como sugiere el blog)
FROM python:3.12

# Configura variables de entorno (REDIS_URL es opcional si no usas Redis)
ENV REDIS_URL=

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia todo el contenido de tu proyecto al contenedor
# Esto incluye Dockerfile, requirements.txt, rxconfig.py, y la carpeta system/
COPY . .

# Instala todas las dependencias de Python
RUN pip install -r requirements.txt

# El ENTRYPOINT ejecuta 'reflex run --backend-only'.
# Reflex leerá rxconfig.py para encontrar 'system.app' y servirá el backend.
# También compilará y servirá el frontend automáticamente.
ENTRYPOINT ["reflex", "run", "--env", "prod", "--backend-only", "--loglevel", "debug" ]

# Expone el puerto 8000, donde Reflex estará escuchando (backend y frontend)
EXPOSE 8000

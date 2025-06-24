# Imagen base oficial de Python
FROM python:3.12-slim

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia los archivos de requerimientos
COPY requirements.txt .

# Instala las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto de la aplicación
COPY . .

# Expone el puerto que usará la app
EXPOSE 8000

# Comando por defecto para ejecutar la app
CMD ["uvicorn", "app.app:app", "--host", "0.0.0.0", "--port", "8000"]

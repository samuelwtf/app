import reflex as rx

config = rx.Config(
    app_name="app",  # El nombre de tu módulo principal (el archivo app.py sin la extensión)
    api_url="http://0.0.0.0:8000", # URL donde tu backend de Reflex estará escuchando
    # db_url="sqlite:///reflex.db", # Opcional: si usas una base de datos SQLite
    # Otras configuraciones como tailwind, dependencias de frontend, etc.
)

import reflex as rx

config = rx.Config(
    app_name="app",
    frontend_port=3000,
    backend_port=8000,
    # Configuraciones adicionales para producción
    env=rx.Env.PROD,
    # Si usas base de datos
    # db_url="postgresql://user:pass@host:port/dbname"
    backend_host="0.0.0.0",
    frontend_host="0.0.0.0",    
    plugins=[rx.plugins.TailwindV3Plugin()]    
)

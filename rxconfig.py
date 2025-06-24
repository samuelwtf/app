import reflex as rx

config = rx.Config(
    app_name="system.app",  # ¡CRÍTICO! Esto le dice a Reflex dónde está tu módulo principal
    api_url="http://0.0.0.0:8000", # URL donde tu backend de Reflex estará escuchando
    # Puedes añadir otras configuraciones aquí si las necesitas
)

# app/app.py
import reflex as rx

def index():
    return rx.text("¡Hola desde Reflex en Coolify!")

app = rx.App()
app.add_page(index)

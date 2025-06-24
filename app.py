
import reflex as rx

# Define tu estado y funciones aquí si es necesario
class State(rx.State):
    pass

# Define tu página principal
@rx.page("/")
def index():
    return rx.center(
        rx.vstack(
            rx.text("¡Hola desde Reflex en Coolify!", font_size="2em"),
            rx.text("Esta es una instalación limpia. ¡Felicidades!"),
            spacing="1.5em",
            font_size="2em",
        )
    )

# Crea la instancia de tu aplicación Reflex
app = rx.App(
    # Puedes añadir configuraciones globales aquí
)

# Añade tus páginas a la aplicación
app.add_page(index)

# Si tienes más páginas, añádelas así:
# @rx.page("/otra_pagina")
# def otra_pagina():
#     return rx.text("Esta es otra página.")
# app.add_page(otra_pagina)

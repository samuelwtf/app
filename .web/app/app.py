import reflex as rx

# Define una página simple
def index() -> rx.Component:
    return rx.text("Hola desde Reflex!")

# Crea la app
app = rx.App()

# Agrega la ruta a la app
app.add_page(index)

# Agrega la API de la app (requerido por Reflex para exportar)
app.compile()

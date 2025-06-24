import reflex as rx

def index():
    return rx.center(
        rx.text("¡Hola desde Reflex en Coolify!", font_size="2em"),
        height="100vh"
    )

app = rx.App()
app.add_page(index)

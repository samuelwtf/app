import reflex as rx

def index():
    return rx.text("¡Hola desde Reflex!")

app = rx.App()
app.add_page(index)

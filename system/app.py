import reflex as rx

# Estado de la aplicación
class State(rx.State):
    count: int = 0

    def increment(self):
        self.count += 1

# Página principal
def index() -> rx.Component:
    return rx.vstack(
        rx.heading("¡Hola desde Reflex!"),
        rx.text(f"Contador: {State.count}"),
        rx.button("Incrementar", on_click=State.increment),
        padding="2em",
    )

# Agregar página a la app
app = rx.App()
app.add_page(index)


import reflex as rx

class State(rx.State):
    count: int = 0

    def increment(self):
        self.count += 1

def index():
    return rx.vstack(
        rx.heading("Hola desde Reflex 🚀"),
        rx.text(lambda: f"Contador: {State.count}"),
        rx.button("Incrementar", on_click=State.increment)
    )

app = rx.App()
app.add_page(index)

# ✅ Esto es clave para que gunicorn pueda servirlo correctamente
app = app.compile()

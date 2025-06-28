# login.py
import reflex as rx
from app.layout import main_layout

def login_page():
    return rx.center(
        rx.card(
            rx.vstack(
                rx.heading("Iniciar sesión", size="6"),
                rx.input(placeholder="Email"),
                rx.input(placeholder="Contraseña", type="password"),
                rx.button("Entrar", width="100%"),
                spacing="4",
            ),
            max_width="400px",
            padding="6",
        ),
        min_height="100vh",
        padding="4",
    )


import reflex as rx
from .login import login_page
from .register import register_page  # Asumiendo que también separaste el registro
from .layout import main_layout
from .navbar import navbar_user

# ---------- Layout base con menú ----------
def layout(content):
    return rx.container(
        rx.vstack(
            rx.hstack(
                rx.heading("Mi Plataforma", size="5", color="blue"),
                rx.spacer(),
                rx.link("Inicio", href="/", size="2"),
                rx.link("Registrarse", href="/register", size="2"),
                rx.link("Login", href="/login", size="2"),
                spacing="4",
                padding_y="4",
            ),
            rx.divider(),
            content,
        ),
        max_width="100%",
        padding_x="6",
    )


# ---------- Página principal (home) ----------
def index():
    return layout(
        navbar_user()
    )


# ---------- Configuración de la app ----------
app = rx.App()
app.add_page(index, route="/")
app.add_page(register_page, route="/register")
app.add_page(login_page, route="/login")

import reflex as rx
from .login import login_page
from .register import register_page  # Asumiendo que también separaste el registro


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
        rx.center(
            rx.vstack(
                rx.heading("Bienvenido a Mi Plataforma", size="8", color="blue"),
                rx.text(
                    "Una solución moderna para gestionar tus cuentas, servicios y más.",
                    size="3",
                    color="gray",
                    text_align="center",
                    max_width="500px",
                ),
                rx.hstack(
                    rx.link(
                        rx.button("Crear cuenta", size="3", variant="solid", color_scheme="blue"),
                        href="/register",
                    ),
                    rx.link(
                        rx.button("Iniciar sesión", size="3", variant="outline", color_scheme="blue"),
                        href="/login",
                    ),
                    spacing="4",
                    padding_top="4",
                ),
                spacing="6",
                align="center",
            ),
            min_height="80vh",
        )
    )


# ---------- Configuración de la app ----------
app = rx.App()
app.add_page(index, route="/")
app.add_page(register_page, route="/register")
app.add_page(login_page, route="/login")

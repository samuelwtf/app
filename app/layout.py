# app/layout.py

import reflex as rx

def main_layout(content: rx.Component) -> rx.Component:
    return rx.container(
        rx.vstack(
            # Encabezado (Header)
            rx.hstack(
                rx.heading("Mi Plataforma", size="5", color="blue"),
                rx.spacer(),
                rx.link("Inicio", href="/", size="2", color="gray"),
                rx.link("Registro", href="/register", size="2", color="gray"),
                rx.link("Login", href="/login", size="2", color="gray"),
                spacing="4",
                padding_y="4",
            ),
            rx.divider(),

            # Contenido principal
            content,
        ),
        max_width="100%",
        padding_x="6",
        padding_y="4",
    )
